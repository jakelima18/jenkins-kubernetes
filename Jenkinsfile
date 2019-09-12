pipeline {
    /* insert Declarative Pipeline here */
   agent { node {label 'qa'}}
   stages {
        stage('Build') {
            steps {
                sh 'composer install'
            }
        }
        stage('Pre-Teste') {
            steps {
                sh 'ansible-playbook /home/easyit/laravel/mysql.yaml -i /home/easyit/laravel/mysql'
            }
        }
        stage('Test') {
            steps {
                sh 'vendor/bin/phpunit'
            }
        }
        stage('Packaging') {
            steps {
              sh 'rm -rf deploy.zip'  
              zip zipFile: 'deploy.zip', archive: true
            }
        }
        stage('Deploy Develop') {
            when {
                branch 'develop'
            }
            steps {
                sh 'ansible-playbook /home/easyit/laravel/playbook.yml'
            }
        }
        stage('Deploy Prod') {
            when {
                branch 'master'
            }
            steps {
                sh 'ansible-playbook /home/easyit/laravel/playbook-prod.yaml'
            }
        }
   }    
  post {
    failure {
      emailext(
            subject: "Job '${env.JOB_NAME} ${env.BUILD_NUMBER}'",
            body: """<p>A Build Falhou <a href="${env.BUILD_URL}">${env.JOB_NAME}</a></p>""",
            recipientProviders: [[$class: 'DevelopersRecipientProvider'],
            [$class: 'RequesterRecipientProvider']]
             )
       }
    success {
        emailext(
            subject: "Job '${env.JOB_NAME} ${env.BUILD_NUMBER}'",
            body: """<p>A Build foi feita com sucesso <a href="${env.BUILD_URL}">${env.JOB_NAME}</a></p>""",
            to: "jackson@schoolofnet.com"
             )     
            }     /*emailext body: 'A Test EMail', recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: 'Test'*/
        }
}