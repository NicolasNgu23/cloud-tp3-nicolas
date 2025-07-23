variable "bucket_name" {
  description = "Nom de base du bucket S3 (un suffixe aléatoire sera ajouté)"
  type        = string
  default     = "my-react-app-bucket"
}

variable "environment" {
  description = "Environnement de déploiement"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "Région AWS"
  type        = string
  default     = "eu-west-3"
}