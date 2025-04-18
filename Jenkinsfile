pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS_ID = 'azure-react-service-principal'
        RESOURCE_GROUP = 'rg-integrated-terraform'
        APP_SERVICE_NAME = 'khushapijenkins5673'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/khushboo-289/React-application.git'
            }
        }

        stage('Test Terraform') {
            steps {
                dir('terraform676') {
                    bat 'terraform --version'
                }
            }
        }

        stage('Terraform Setup') {
            steps {
                dir('terraform676') {
                    bat 'terraform init'
                    bat 'terraform plan -out=tfplan'
                    bat 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                dir('my-app') {
                    bat 'npm install'
                }
            }
        }

        stage('Build React App') {
            steps {
                dir('my-app') {
                    bat 'npm run build'
                }
            }
        }

        stage('Deploy to Azure') {
            steps {
                dir('my-app') {
                    withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                        bat 'az login --service-principal -u %AZURE_CLIENT_ID% -p %AZURE_CLIENT_SECRET% --tenant %AZURE_TENANT_ID%'

                        // Delete old zip if exists
                        bat 'IF EXIST build.zip DEL build.zip'

                        // Zip build folder using bestzip
                        bat 'bestzip build.zip build\\**\\*'

                        // Deploy zip to Azure Web App
                        bat 'az webapp deploy --resource-group %RESOURCE_GROUP% --name %APP_SERVICE_NAME% --src-path build.zip --type zip'
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment Successful!'
        }
        failure {
            echo 'Deployment Failed!'
        }
    }
}

