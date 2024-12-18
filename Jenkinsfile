pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-terraform-credentials')  // Make sure this matches the credentials ID in Jenkins
        AWS_SECRET_ACCESS_KEY = credentials('aws-terraform-credentials')
        TF_VAR_region = 'us-east-1' // Set your region here
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Krupa2003/workspace', branch: 'main'
            }
        }

        stage('Initialize Terraform') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan -var-file=dev.tfvars'  // Use dev.tfvars or prod.tfvars based on workspace
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply -auto-approve -var-file=dev.tfvars'
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform applied successfully!'
        }
        failure {
            echo 'Terraform application failed.'
        }
    }
}
