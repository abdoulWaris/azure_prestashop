#!/bin/bash
# scripts/cleanup.sh - Script de nettoyage des environnements

set -e

echo "🧹 Nettoyage des environnements PrestaShop"
echo "=========================================="

# Liste des environnements disponibles
ENVIRONMENTS=("dev" "staging" "prod")

echo "Environnements disponibles :"
for i in "${!ENVIRONMENTS[@]}"; do
    echo "$((i+1)). ${ENVIRONMENTS[i]}"
done

echo "0. Annuler"
echo ""
read -p "Choisissez un environnement à nettoyer (0-${#ENVIRONMENTS[@]}): " choice

if [ "$choice" = "0" ]; then
    echo "❌ Nettoyage annulé"
    exit 0
fi

if [ "$choice" -lt 1 ] || [ "$choice" -gt "${#ENVIRONMENTS[@]}" ]; then
    echo "❌ Choix invalide"
    exit 1
fi

ENV="${ENVIRONMENTS[$((choice-1))]}"
TERRAFORM_DIR="./terraform/environments/$ENV"

echo ""
echo "⚠️  ATTENTION: Vous allez DÉTRUIRE toutes les ressources de l'environnement '$ENV'"
echo "Cette action est IRRÉVERSIBLE !"
echo ""

if [ "$ENV" = "prod" ]; then
    echo "🚨 ENVIRONNEMENT PRODUCTION DÉTECTÉ 🚨"
    echo "Tapez exactement 'DELETE-PRODUCTION' pour confirmer:"
    read confirmation
    
    if [ "$confirmation" != "DELETE-PRODUCTION" ]; then
        echo "❌ Confirmation incorrecte. Nettoyage annulé"
        exit 1
    fi
else
    read -p "🤔 Confirmer la destruction de l'environnement '$ENV' ? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Nettoyage annulé"
        exit 1
    fi
fi

cd "$TERRAFORM_DIR"

echo "🧹 Destruction de l'infrastructure '$ENV'..."
terraform destroy -auto-approve

echo ""
echo "✅ Environnement '$ENV' nettoyé avec succès"
echo "💰 Les ressources Azure ne seront plus facturées"
