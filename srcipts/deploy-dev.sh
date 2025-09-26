
#!/bin/bash
# scripts/deploy-dev.sh - Script de déploiement pour l'environnement DEV

set -e  # Arrêter en cas d'erreur

echo "🚀 Déploiement de PrestaShop - Environnement DEV"
echo "================================================="

# Vérifications préalables
echo "🔍 Vérification des prérequis..."

if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform n'est pas installé"
    exit 1
fi

if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI n'est pas installé"
    exit 1
fi

# Vérifier la connexion Azure
if ! az account show &> /dev/null; then
    echo "❌ Non connecté à Azure. Exécutez: az login"
    exit 1
fi

echo "✅ Prérequis validés"

# Variables
ENV="dev"
TERRAFORM_DIR="./terraform/environments/$ENV"

# Vérifier que le dossier terraform existe
if [ ! -d "$TERRAFORM_DIR" ]; then
    echo "❌ Dossier $TERRAFORM_DIR introuvable"
    exit 1
fi

cd "$TERRAFORM_DIR"

# Vérifier terraform.tfvars
if [ ! -f "terraform.tfvars" ]; then
    echo "⚠️  Fichier terraform.tfvars introuvable"
    echo "Création d'un fichier d'exemple..."
    
    cat > terraform.tfvars << EOF
# Configuration pour l'environnement DEV
project_name           = "prestashop"
location              = "France Central"
dns_name_label        = "prestashop-dev-$(date +%s)"
mysql_admin_username  = "prestashopadmin"
mysql_admin_password  = "DevMySQL123!"
admin_email          = "admin@prestashop.dev"
admin_password       = "DevAdmin123!"
EOF
    
    echo "📝 Veuillez personnaliser le fichier terraform.tfvars avant de continuer"
    echo "En particulier, changez 'dns_name_label' pour qu'il soit unique"
    read -p "Appuyez sur Entrée quand c'est fait..."
fi

echo "📦 Initialisation de Terraform..."
terraform init

echo "📋 Validation de la configuration..."
terraform validate

echo "🔍 Planification du déploiement..."
terraform plan -out=tfplan

echo ""
read -p "🤔 Continuer le déploiement ? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Déploiement annulé"
    exit 1
fi

echo "🚀 Déploiement en cours..."
terraform apply tfplan

echo ""
echo "🎉 Déploiement terminé avec succès !"
echo "📊 Informations de connexion :"
terraform output

echo ""
echo "🌐 Accès PrestaShop :"
echo "   Frontend: $(terraform output -raw prestashop_url)"
echo "   Admin:    $(terraform output -raw prestashop_admin_url)"
echo ""
echo "🔑 Pour voir les identifiants :"
echo "   terraform output admin_credentials"
