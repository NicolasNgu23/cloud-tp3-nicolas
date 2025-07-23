#!/bin/bash
# Script de configuration initiale de l'infrastructure AWS

set -e

echo "🚀 Configuration de l'infrastructure AWS pour React + S3 + CloudFront..."

# Vérifier que AWS CLI est installé
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI n'est pas installé. Installez-le avec:"
    echo "brew install awscli"
    exit 1
fi

# Vérifier que Terraform est installé
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform n'est pas installé. Installez-le avec:"
    echo "brew install terraform"
    exit 1
fi

# Vérifier la configuration AWS
echo "📋 Vérification de la configuration AWS..."
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ AWS n'est pas configuré. Configurez-le avec:"
    echo "aws configure"
    exit 1
fi

# Aller dans le dossier infra
cd "$(dirname "$0")/../infra"

# Initialisation de Terraform
echo "📦 Initialisation de Terraform..."
terraform init

# Validation de la configuration
echo "✅ Validation de la configuration Terraform..."
terraform validate

# Planification de l'infrastructure
echo "📋 Planification de l'infrastructure..."
terraform plan

# Demander confirmation
read -p "🤔 Voulez-vous créer cette infrastructure? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🏗️ Création de l'infrastructure..."
    terraform apply -auto-approve
    
    echo "✅ Infrastructure créée avec succès!"
    echo ""
    echo "📄 Informations importantes:"
    echo "Nom du bucket S3: $(terraform output -raw bucket_name)"
    echo "URL CloudFront: $(terraform output -raw cloudfront_url)"
    echo ""
    echo "🔗 Vous pouvez maintenant déployer votre application avec:"
    echo "./scripts/deploy.sh"
else
    echo "❌ Création annulée."
fi
