#!/bin/bash
# Script de nettoyage de l'infrastructure AWS

set -e

echo "🗑️ Suppression de l'infrastructure AWS..."

# Aller dans le dossier infra
cd "$(dirname "$0")/../infra"

# Vérifier que l'infrastructure existe
if [ ! -f "terraform.tfstate" ]; then
    echo "❌ Aucune infrastructure à supprimer."
    exit 1
fi

# Récupérer le nom du bucket
echo "📋 Récupération des informations d'infrastructure..."
BUCKET_NAME=$(terraform output -raw bucket_name 2>/dev/null || echo "")

if [ ! -z "$BUCKET_NAME" ]; then
    echo "🗂️ Vidage du bucket S3: $BUCKET_NAME"
    aws s3 rm s3://$BUCKET_NAME --recursive 2>/dev/null || true
fi

# Demander confirmation
read -p "⚠️ Êtes-vous sûr de vouloir supprimer toute l'infrastructure? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🏗️ Suppression de l'infrastructure..."
    terraform destroy -auto-approve
    
    echo "✅ Infrastructure supprimée avec succès!"
else
    echo "❌ Suppression annulée."
fi
