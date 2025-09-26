#!/bin/bash
# scripts/deploy-prod.sh - Script de déploiement pour l'environnement PROD

set -e

echo "🏭 Déploiement de PrestaShop - Environnement PRODUCTION"
echo "======================================================"

# Vérifications renforcées pour la production
echo "🔍 Vérification des prérequis PRODUCTION..."

if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform n'est pas installé"
    exit 1
fi

if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI n'est pas installé"
    exit 1
fi

if ! az account show &> /dev/null; then
    echo "❌ Non connecté à Azure. Exécutez: az login"
    exit 1
fi

echo "✅ Prérequis validés"

ENV="prod"
TERRAFORM_DIR="./terraform/environments/$ENV"

if [ ! -d "$TERRAFORM_DIR" ]; then
    echo "❌ Dossier $TERRAFORM_DIR introuvable"
    exit 1
fi

cd "$TERRAFORM_DIR"

# Vérifications spécifiques à la production
if [ ! -f "terraform.tfvars" ]; then
    echo "❌ ERREUR: Fichier terraform.tfvars manquant pour la PRODUCTION"
    echo "Créez ce fichier avec des valeurs sécurisées avant de déployer en production"
    exit 1
fi

echo "⚠️  ATTENTION: Vous êtes sur le point de déployer en PRODUCTION"
echo "Cela va créer des ressources Azure facturables"
echo ""
read -p "🔐 Confirmez en tapant 'PRODUCTION': " confirmation

if [ "$confirmation" != "PRODUCTION" ]; then
    echo "❌ Confirmation incorrecte. Déploiement annulé"
    exit 1
fi

echo "📦 Initialisation de Terraform..."
terraform init

echo "📋 Validation de la configuration..."
terraform validate

echo "🔍 Planification du déploiement PRODUCTION..."
terraform plan -out=tfplan

echo ""
echo "🚨 DERNIÈRE VÉRIFICATION AVANT PRODUCTION 🚨"
echo "Vérifiez attentivement le plan ci-dessus"
echo ""
read -p "🤔 CONFIRMER le déploiement en PRODUCTION ? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Déploiement PRODUCTION annulé"
    exit 1
fi

echo "🚀 Déploiement PRODUCTION en cours..."
echo "⏳ Cela peut prendre plusieurs minutes..."
terraform apply tfplan

echo ""
echo "🎉 Déploiement PRODUCTION terminé avec succès !"
echo "📊 Informations de connexion :"
terraform output

echo ""
echo "🌐 PrestaShop PRODUCTION accessible à :"
echo "   Frontend: $(terraform output -raw prestashop_url)"
echo "   Admin:    $(terraform output -raw prestashop_admin_url)"
echo ""
echo "🔒 SÉCURITÉ: Changez immédiatement les mots de passe par défaut !"
