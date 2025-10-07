## 📊 Estimation

### 1. Environnement de Développement Terraform sur Azure

Cette section présente les estimations liées à la mise en place de l’infrastructure **en developpement** via Terraform sur Azure.
```bash
| Composant / Module              | Temps estimé | Coût mensuel estimé | Azure Service       | Remarques                           |
|--------------------------------|--------------|----------------------|----------------------|-------------------------------------|
| Backend pour `terraform state` | 15 min       | ~0 $                 | Azure Storage        | Compte de stockage + container blob |
| Réseau virtuel (VNet + subnets)| 30 min       | ~0 $                 | Azure Networking     | Module réseau Terraform             |
| Azure Container Apps (ACA)     | 1h           | 100–200 $/mois       | ACA                  | Sans re – 1.5Gi                     |
| Azure SQL Database             | 45 min       | 50 $/mois            | SQL Database         | Niveau basique / B_Standard_B1ms    |
```
📁 [Télécharger l’estimation complète (.xlsx)](./docs/devEnvEstimate.xlsx)

### 2. Environnement de Production Terraform sur Azure

Cette section présente les estimations liées à la mise en place de l’infrastructure **en production** via Terraform sur Azure.

| Composant / Module              | Temps estimé | Coût mensuel estimé | Azure Service       | Remarques                            |
|--------------------------------|--------------|----------------------|---------------------|--------------------------------------|
| Backend pour `terraform state` | 15 min       | ~0 $                 | Azure Storage       | Compte de stockage + container blob  |
| Réseau virtuel (VNet + subnets)| 30 min       | ~0 $                 | Azure Networking    | Module réseau Terraform              |
| Azure Container Apps (ACA)     | 1h           | 150–250 $/mois       | ACA                 | 2 containers, 1.5Gi chacun           |
| Azure SQL Database             | 45 min       | 80 $/mois            | SQL Database        | Standard tier (S1), sauvegardes 7j   |
| Azure Application Insights     | 20 min       | 10 $/mois            | Monitoring          | Logs + métriques pour ACA            |

📁 [Télécharger l’estimation complète (.xlsx)](./docs/prodEnvEstimate.xlsx)

---

> Ces estimations sont indicatives et peuvent évoluer selon l’utilisation réelle des ressources et les options choisies.  
> Pour obtenir une estimation dynamique basée sur votre configuration Terraform, vous pouvez utiliser [Infracost](https://www.infracost.io/).
