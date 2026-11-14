pipeline {
    agent any
    stages {
        stage('Create Server') {
            steps {
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
            }
        }
    }
}