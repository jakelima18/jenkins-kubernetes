pipeline {
    /* insert Declarative Pipeline here */
   agent { node {label 'qa'}}
   stages {
        stage('Build') {
            when {
               branch 'develop'
            }
            steps {
                sh 'composer install'
            }
        }
   }
}