pipeline {
    /* insert Declarative Pipeline here */
   agent { node {label 'qa'}}
   stages {
        stage('Build') {
            steps {
                sh 'composer install'
            }
        }
        stage('Test') {
            steps {
                sh 'vendor/bin/phpunit'
            }
    post {
       always {
            emailext body: 'A Test EMail', recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: 'Test'
        }
    }
        }    
        }
   }