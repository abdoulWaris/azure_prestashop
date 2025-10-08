### 🔧 Suppression Post-Installation PrestaShop (via Azure CLI)

> Après l'installation de PrestaShop, la suppression du dossier /install est obligatoire pour des raisons de sécurité. Il est également recommandé de renommer le dossier admin.

## ⚠️ Étapes indispensables après l'installation

1.  Accéder à la console de la Container App

Utilisez la commande suivante pour ouvrir un terminal dans votre container :

```sh
az containerapp exec --name prestashop-prestashop-dev --resource-group prestashop-dev-rg --command /bin/bash
```

> Remplacez dev par prod dans prestashop-prestashop-dev et prestashop-dev-rg si vous utilisez un autre environnement.

2.  Supprimer le dossier /install et renommer le dossier /admin

Une fois dans le terminal du container, exécutez la commande suivante :

```sh
rm -rf /var/www/html/install && mv /var/www/html/admin /var/www/html/admin0811mvbwbeeftuqlevv
```

- ✅ Supprime le dossier /install
- 🔐 Renomme le dossier /admin pour sécuriser l'accès au back-

### ℹ️ Astuce : récupérer l'URL publique de la Container App

```sh
az containerapp show --name prestashop-prestashop-dev --resource-group prestashop-dev-rg --query "{Status: properties.runningStatus, URL: properties.configuration.ingress.fqdn}" --output table
```
