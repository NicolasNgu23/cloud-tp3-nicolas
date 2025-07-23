# Application React hébergée sur AWS S3 + CloudFront

Cette application React est configurée pour être déployée automatiquement sur AWS S3 avec CloudFront comme CDN.

## 🏗️ Architecture

- **Frontend**: React 19
- **Hébergement**: AWS S3 (site web statique)
- **CDN**: AWS CloudFront
- **Infrastructure**: Terraform
- **Déploiement**: Scripts automatisés

## 📋 Prérequis

1. **Node.js** et **npm**
2. **AWS CLI** installé et configuré
3. **Terraform** installé

### Installation des outils

```bash
# Sur macOS avec Homebrew
brew install awscli terraform node

# Configuration AWS
aws configure
```

## 🚀 Déploiement

### 1. Configuration initiale (première fois seulement)

```bash
# Rendre les scripts exécutables
chmod +x scripts/*.sh

# Configurer l'infrastructure AWS
./scripts/setup.sh
```

Cette commande va :
- Créer un bucket S3 avec un nom unique
- Configurer l'hébergement web statique
- Créer une distribution CloudFront
- Configurer les politiques de sécurité

### 2. Déploiement de l'application

```bash
# Déployer l'application
./scripts/deploy.sh
```

Cette commande va :
- Installer les dépendances npm (si nécessaire)
- Builder l'application React
- Synchroniser les fichiers avec S3
- Invalider le cache CloudFront

### 3. Nettoyage (si nécessaire)

```bash
# Supprimer toute l'infrastructure
./scripts/cleanup.sh
```

## 📁 Structure du projet

```
cloud-tp3-nicolas/
├── my-app/                 # Application React
│   ├── src/
│   ├── public/
│   ├── package.json
│   └── build/             # Dossier généré après npm run build
├── infra/                 # Infrastructure Terraform
│   ├── main.tf           # Ressources S3 + CloudFront
│   ├── variables.tf      # Variables de configuration
│   ├── outputs.tf        # Sorties (URLs, noms des ressources)
│   └── provider.tf       # Configuration des providers
└── scripts/              # Scripts d'automatisation
    ├── setup.sh          # Configuration initiale
    ├── deploy.sh         # Déploiement
    └── cleanup.sh        # Nettoyage
```

## 🔧 Configuration

### Variables Terraform

Vous pouvez personnaliser les variables dans `infra/variables.tf` :

- `bucket_name`: Nom de base du bucket S3
- `environment`: Environnement (dev, prod, etc.)
- `aws_region`: Région AWS (par défaut: eu-west-3)

### Scripts npm

Dans le dossier `my-app`, vous pouvez utiliser :

```bash
npm start       # Développement local
npm run build   # Build de production
npm run deploy  # Build + déploiement
```

## 🔗 URLs après déploiement

Après le déploiement, vous obtiendrez :

- **URL CloudFront** (recommandée) : `https://dvrm5kon4u7fv.cloudfront.net`
- **URL S3 directe** : `http://my-react-app-bucket-f45gm93f.s3-website.eu-west-3.amazonaws.com`

## 🌐 Site en ligne

Votre site React est actuellement déployé et accessible à l'adresse :
**https://dvrm5kon4u7fv.cloudfront.net**

## 🛡️ Sécurité

- Le bucket S3 est configuré pour l'accès public en lecture uniquement
- CloudFront utilise HTTPS par défaut
- Origin Access Control (OAC) pour sécuriser l'accès S3 ↔ CloudFront

## 💰 Coûts

Cette architecture utilise uniquement des services AWS avec tarification à l'usage :
- S3: Stockage et requêtes
- CloudFront: Transfert de données
- Généralement très économique pour des sites statiques

## 🔍 Dépannage

### Problème avec AWS CLI
```bash
# Vérifier la configuration
aws sts get-caller-identity

# Reconfigurer si nécessaire
aws configure
```

### Problème avec Terraform
```bash
# Dans le dossier infra/
terraform validate
terraform plan
```

### Application qui ne se met pas à jour
```bash
# Forcer l'invalidation CloudFront
./scripts/deploy.sh
```

## 📝 Notes

- Les changements peuvent prendre quelques minutes à apparaître sur CloudFront
- Le cache CloudFront est invalidé automatiquement lors du déploiement
- Les erreurs 404 sont redirigées vers `index.html` pour supporter les SPA React
