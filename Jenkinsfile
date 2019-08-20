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
        }    
        }
   }
}