#!/bin/bash
# Script de déploiement de l'application React

set -e

echo "🚀 Déploiement de l'application React..."

# Aller dans le dossier my-app
echo "📂 Navigation vers le dossier my-app..."
cd "$(dirname "$0")/../my-app"

# Vérifier que node_modules existe
if [ ! -d "node_modules" ]; then
    echo "📦 Installation des dépendances npm..."
    npm install
fi

# Build de l'application React
echo "🏗️ Build de l'application React..."
npm run build

# Vérifier que le dossier build existe
if [ ! -d "build" ]; then
    echo "❌ Le dossier build n'existe pas. Le build a échoué."
    exit 1
fi

# Aller dans le dossier infra pour récupérer les informations Terraform
echo "📂 Navigation vers le dossier infra..."
cd "../infra"

# Vérifier que l'infrastructure existe
if [ ! -f "terraform.tfstate" ]; then
    echo "❌ L'infrastructure n'existe pas. Lancez d'abord:"
    echo "./scripts/setup.sh"
    exit 1
fi

# Récupérer le nom du bucket et l'ID de distribution
echo "📋 Récupération des informations d'infrastructure..."
BUCKET_NAME=$(terraform output -raw bucket_name)
DISTRIBUTION_ID=$(terraform output -raw cloudfront_distribution_id)

echo "📦 Upload vers S3 bucket: $BUCKET_NAME"

# Upload vers S3 avec synchronisation (supprime les fichiers qui n'existent plus)
aws s3 sync ../my-app/build/ s3://$BUCKET_NAME --delete

echo "🔄 Invalidation du cache CloudFront (ID: $DISTRIBUTION_ID)..."
INVALIDATION_ID=$(aws cloudfront create-invalidation \
    --distribution-id $DISTRIBUTION_ID \
    --paths "/*" \
    --query 'Invalidation.Id' \
    --output text)

echo "⏳ Attente de l'invalidation du cache CloudFront..."
aws cloudfront wait invalidation-completed \
    --distribution-id $DISTRIBUTION_ID \
    --id $INVALIDATION_ID

echo "✅ Déploiement terminé avec succès!"
echo ""
echo "🌐 Votre site est maintenant disponible sur:"
echo "   CloudFront (recommandé): $(terraform output -raw cloudfront_url)"
echo "   S3 direct: $(terraform output -raw website_url)"
echo ""
echo "📝 Note: Il peut falloir quelques minutes pour que les changements soient visibles sur CloudFront."
