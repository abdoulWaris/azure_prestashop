#!/bin/bash
# scripts/check-status.sh - Vérifier l'état des environnements

echo "📊 État des environnements PrestaShop"
echo "======================================"

ENVIRONMENTS=("dev" "staging" "prod")

for ENV in "${ENVIRONMENTS[@]}"; do
    echo ""
    echo "🔍 Environnement: $ENV"
    echo "-------------------"
    
    TERRAFORM_DIR="./terraform/environments/$ENV"
    
    if [ -d "$TERRAFORM_DIR" ]; then
        cd "$TERRAFORM_DIR"
        
        if [ -f "terraform.tfstate" ]; then
            echo "✅ Infrastructure déployée"
            
            # Vérifier si les ressources existent toujours
            if terraform show > /dev/null 2>&1; then
                echo "🌐 URL: $(terraform output -raw prestashop_url 2>/dev/null || echo 'Non disponible')"
            else
                echo "⚠️  État incohérent - Vérification recommandée"
            fi
        else
            echo "❌ Infrastructure non déployée"
        fi
        
        cd - > /dev/null
    else
        echo "❌ Environnement non configuré"
    fi
done

echo ""
echo "💡 Utilisez './scripts/deploy-{env}.sh' pour déployer"
echo "💡 Utilisez './scripts/cleanup.sh' pour nettoyer"