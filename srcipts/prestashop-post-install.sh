#!/bin/bash
# scripts/prestashop-post-install.sh - Actions post-installation PrestaShop

set -e

echo "🛒 PrestaShop Post-Installation"
echo "=============================="

ENV=${1:-"dev"}
TERRAFORM_DIR="./terraform/environments/$ENV"

echo "🎯 Environnement: $ENV"

if [ ! -d "$TERRAFORM_DIR" ]; then
    echo "❌ Environnement $ENV introuvable"
    exit 1
fi

cd "$TERRAFORM_DIR"

# Récupérer les informations du déploiement
echo "📋 Récupération des informations..."

if [ ! -f "terraform.tfstate" ]; then
    echo "❌ Infrastructure non déployée"
    exit 1
fi

# Fonction pour Container Instances
handle_container_instance() {
    echo "🐳 Gestion Container Instance..."
    
    RG_NAME=$(terraform output -raw resource_group_name)
    CONTAINER_NAME=$(terraform show -json | jq -r '.values.root_module.child_modules[] | select(.address=="module.container") | .resources[] | select(.type=="azurerm_container_group") | .values.name')
    
    if [ -z "$CONTAINER_NAME" ] || [ "$CONTAINER_NAME" = "null" ]; then
        echo "❌ Container Group non trouvé"
        return 1
    fi
    
    echo "📦 Container Group: $CONTAINER_NAME"
    
    # Options pour supprimer le dossier install
    echo ""
    echo "🔧 Options pour supprimer le dossier /install:"
    echo "1. Redémarrer le container (recommandé)"
    echo "2. Exécuter une commande dans le container"
    echo "3. Modifier la configuration et redéployer"
    
    read -p "Choisissez une option (1-3): " option
    
    case $option in
        1)
            restart_container_instance "$RG_NAME" "$CONTAINER_NAME"
            ;;
        2)
            exec_in_container_instance "$RG_NAME" "$CONTAINER_NAME"
            ;;
        3)
            modify_config_and_redeploy "container-instance"
            ;;
        *)
            echo "❌ Option invalide"
            ;;
    esac
}

# Fonction pour Container Apps
handle_container_app() {
    echo "📱 Gestion Container App..."
    
    RG_NAME=$(terraform output -raw resource_group_name)
    APP_NAME=$(terraform show -json | jq -r '.values.root_module.child_modules[] | select(.address=="module.container_app") | .resources[] | select(.type=="azurerm_container_app") | .values.name')
    
    if [ -z "$APP_NAME" ] || [ "$APP_NAME" = "null" ]; then
        echo "❌ Container App non trouvé"
        return 1
    fi
    
    echo "📱 Container App: $APP_NAME"
    
    # Options pour Container Apps
    echo ""
    echo "🔧 Options pour supprimer le dossier /install:"
    echo "1. Créer une nouvelle révision (recommandé)"
    echo "2. Exécuter une commande via console"
    echo "3. Modifier la configuration et redéployer"
    
    read -p "Choisissez une option (1-3): " option
    
    case $option in
        1)
            create_new_revision "$RG_NAME" "$APP_NAME"
            ;;
        2)
            exec_in_container_app "$RG_NAME" "$APP_NAME"
            ;;
        3)
            modify_config_and_redeploy "container-app"
            ;;
        *)
            echo "❌ Option invalide"
            ;;
    esac
}

# Fonction pour redémarrer Container Instance
restart_container_instance() {
    local rg_name=$1
    local container_name=$2
    
    echo "🔄 Redémarrage du Container Instance..."
    
    # Le redémarrage va déclencher un nouveau pull de l'image et réinitialiser le container
    az container restart --resource-group "$rg_name" --name "$container_name"
    
    if [ $? -eq 0 ]; then
        echo "✅ Container redémarré avec succès"
        echo "⏳ Attendez 2-3 minutes puis vérifiez votre site"
        
        # Afficher l'URL
        PRESTASHOP_URL=$(terraform output -raw prestashop_url 2>/dev/null || echo "Non disponible")
        echo "🌐 URL: $PRESTASHOP_URL"
    else
        echo "❌ Erreur lors du redémarrage"
    fi
}

# Fonction pour exécuter une commande dans Container Instance
exec_in_container_instance() {
    local rg_name=$1
    local container_name=$2
    
    echo "⚠️  Exécution de commande dans Container Instance..."
    echo "Cette méthode peut ne pas fonctionner selon la configuration"
    
    # Essayer d'exécuter la commande pour supprimer le dossier install
    az container exec \
        --resource-group "$rg_name" \
        --name "$container_name" \
        --exec-command "/bin/bash -c 'rm -rf /var/www/html/install && echo \"Dossier install supprimé\"'"
    
    if [ $? -eq 0 ]; then
        echo "✅ Dossier install supprimé"
    else
        echo "❌ Impossible d'exécuter la commande"
        echo "💡 Essayez l'option redémarrage ou redéploiement"
    fi
}

# Fonction pour créer une nouvelle révision Container App
create_new_revision() {
    local rg_name=$1
    local app_name=$2
    
    echo "🚀 Création d'une nouvelle révision Container App..."
    
    # Forcer une nouvelle révision en changeant une variable d'environnement
    az containerapp revision copy \
        --resource-group "$rg_name" \
        --name "$app_name" \
        --from-revision "latest" \
        --env-vars "INSTALL_REMOVED=true"
    
    if [ $? -eq 0 ]; then
        echo "✅ Nouvelle révision créée"
        echo "⏳ La nouvelle révision va démarrer automatiquement"
        
        # Afficher l'URL
        PRESTASHOP_URL=$(terraform output -raw prestashop_url 2>/dev/null || echo "Non disponible")
        echo "🌐 URL: $PRESTASHOP_URL"
    else
        echo "❌ Erreur lors de la création de révision"
    fi
}

# Fonction pour exécuter une commande dans Container App
exec_in_container_app() {
    local rg_name=$1
    local app_name=$2
    
    echo "⚠️  Exécution de commande dans Container App..."
    
    # Container Apps n'a pas d'exec direct, mais on peut essayer via console
    echo "📝 Pour Container Apps, utilisez:"
    echo "1. Portail Azure > Container Apps > $app_name > Console"
    echo "2. Exécutez: rm -rf /var/www/html/install"
    echo ""
    echo "Ou utilisez l'option 1 (nouvelle révision) qui est plus fiable"
}

# Fonction pour modifier la configuration et redéployer
modify_config_and_redeploy() {
    local service_type=$1
    
    echo "⚙️  Modification de la configuration Terraform..."
    
    if [ "$service_type" = "container-instance" ]; then
        MODULE_DIR="../../modules/container-instance"
    else
        MODULE_DIR="../../modules/container-app"
    fi
    
    # Ajouter une variable pour indiquer que l'installation est terminée
    echo "📝 Ajout de la variable PS_INSTALL_COMPLETE..."
    
    # Modifier le main.tf pour ajouter la variable d'environnement
    if [ -f "$MODULE_DIR/main.tf" ]; then
        # Sauvegarder
        cp "$MODULE_DIR/main.tf" "$MODULE_DIR/main.tf.backup"
        
        # Ajouter la variable PS_INSTALL_COMPLETE
        if ! grep -q "PS_INSTALL_COMPLETE" "$MODULE_DIR/main.tf"; then
            # Trouver la section environment_variables et ajouter la nouvelle variable
            if [ "$service_type" = "container-instance" ]; then
                sed -i '/PS_ERASE_DB.*$/a\      PS_INSTALL_COMPLETE = "1"' "$MODULE_DIR/main.tf"
            else
                # Pour Container Apps
                sed -i '/PS_ERASE_DB.*$/a\      env {\n        name  = "PS_INSTALL_COMPLETE"\n        value = "1"\n      }' "$MODULE_DIR/main.tf"
            fi
            
            echo "✅ Variable ajoutée au module"
        fi
    fi
    
    # Redéployer
    echo "🚀 Redéploiement avec la nouvelle configuration..."
    
    terraform plan
    
    read -p "🤔 Continuer le redéploiement ? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        terraform apply -auto-approve
        
        if [ $? -eq 0 ]; then
            echo "✅ Redéploiement réussi"
            echo "🎉 Le dossier install devrait maintenant être supprimé"
        else
            echo "❌ Erreur lors du redéploiement"
        fi
    fi
}

# Fonction pour configurer la suppression automatique de /install
setup_auto_remove_install() {
    echo "🔧 Configuration de la suppression automatique du dossier install"
    
    cat << 'EOF' > post-install-script.sh
#!/bin/bash
# Script à exécuter après installation PrestaShop

echo "🧹 Suppression du dossier install..."
if [ -d "/var/www/html/install" ]; then
    rm -rf /var/www/html/install
    echo "✅ Dossier install supprimé"
else
    echo "ℹ️  Dossier install déjà supprimé"
fi

echo "🔒 Sécurisation des permissions..."
chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/

echo "✅ Post-installation terminée"
EOF
    
    chmod +x post-install-script.sh
    echo "📝 Script post-installation créé: post-install-script.sh"
}

# Détecter le type de service déployé
detect_service_type() {
    if terraform show -json | jq -r '.values.root_module.child_modules[].address' | grep -q "module.container_app"; then
        echo "container-app"
    elif terraform show -json | jq -r '.values.root_module.child_modules[].address' | grep -q "module.container"; then
        echo "container-instance"
    else
        echo "unknown"
    fi
}

# Fonction principale
main() {
    SERVICE_TYPE=$(detect_service_type)
    
    echo "🔍 Type de service détecté: $SERVICE_TYPE"
    echo ""
    
    case $SERVICE_TYPE in
        "container-app")
            handle_container_app
            ;;
        "container-instance")
            handle_container_instance
            ;;
        "unknown")
            echo "❌ Impossible de détecter le type de service"
            echo "💡 Vérifiez que l'infrastructure est bien déployée"
            exit 1
            ;;
    esac
    
    echo ""
    echo "🎉 Post-installation terminée !"
    echo ""
    echo "🔒 Pour sécuriser davantage votre PrestaShop:"
    echo "1. Changez le mot de passe admin"
    echo "2. Renommez le dossier /admin"
    echo "3. Configurez SSL/HTTPS"
    echo "4. Activez les sauvegardes"
}

# Lancement du script
main

cd - > /dev/null

---

# scripts/quick-remove-install.sh - Solution ultra rapide
#!/bin/bash

echo "⚡ Suppression rapide du dossier install PrestaShop"
echo "================================================"

ENV="dev"
cd "terraform/environments/$ENV"

# Méthode 1: Force refresh du container
echo "🔄 Méthode 1: Refresh du container..."

if terraform show -json | grep -q "azurerm_container_group"; then
    # Container Instance
    echo "🐳 Container Instance détecté"
    RG=$(terraform output -raw resource_group_name)
    CONTAINER=$(terraform show -json | jq -r '.values.root_module.child_modules[] | select(.address=="module.container") | .resources[] | select(.type=="azurerm_container_group") | .values.name')
    
    echo "🔄 Redémarrage du container..."
    az container restart --resource-group "$RG" --name "$CONTAINER"
    
elif terraform show -json | grep -q "azurerm_container_app"; then
    # Container App
    echo "📱 Container App détecté"
    
    # Forcer un nouveau déploiement en modifiant une variable
    echo "PS_INSTALL_REMOVED = \"$(date +%s)\"" >> terraform.tfvars
    
    echo "🚀 Nouveau déploiement..."
    terraform apply -auto-approve
    
    # Nettoyer la variable temporaire
    sed -i '/PS_INSTALL_REMOVED/d' terraform.tfvars
fi

echo ""
echo "✅ Action terminée !"
echo "⏳ Attendez 2-3 minutes puis vérifiez votre site"
echo "🌐 URL: $(terraform output -raw prestashop_url 2>/dev/null)"

cd - > /dev/null

---

# Solution alternative: Modifier la configuration Terraform
# terraform/modules/container-instance/main.tf - Ajouter cette variable

# Dans la section environment_variables, ajoutez:
# PS_INSTALL_AUTO = "0"  # Désactiver l'auto-install après la première fois

# Ou créer un script de post-installation personnalisé
cat > custom-prestashop-entrypoint.sh << 'EOF'
#!/bin/bash
# Entrypoint personnalisé pour PrestaShop

# Si c'est la première installation, laisser le processus normal
if [ ! -f "/var/www/html/.installed" ]; then
    echo "🚀 Première installation en cours..."
    # Lancer l'installation normale
    /tmp/docker_run.sh
    
    # Marquer comme installé et supprimer le dossier install
    touch /var/www/html/.installed
    rm -rf /var/www/html/install
    echo "✅ Installation terminée et dossier install supprimé"
else
    echo "ℹ️  PrestaShop déjà installé"
    # Juste démarrer Apache
    /usr/sbin/apache2ctl -D FOREGROUND
fi
EOF