pipeline {
  agent any
  stages {
    stage('Create Server') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws-creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          sh 'export AWS_DEFAULT_REGION=ap-south-1 && terraform init'
          sh 'export AWS_DEFAULT_REGION=ap-south-1 && terraform apply -auto-approve'
        }
      }
    }
  }
}