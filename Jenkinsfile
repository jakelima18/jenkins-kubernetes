pipeline {
    /* insert Declarative Pipeline here */
   agent none
   stages {
        stage('Build') {
            agent { node {label 'qa'}}
            steps {
                sh 'composer install'
            }
        }
        stage('Pre-Testing') {
            agent { node {label 'master'}}
            steps {
                sh 'ansible-playbook /home/easyit/laravel/mysql.yaml -i /home/easyit/laravel/mysql'
            }
        }
        stage('Test') {
            agent { node {label 'qa'}}
            steps {
                sh 'vendor/bin/phpunit'
            }
        stage('Deploy') {
            agent { node {label 'master'}}
            steps {
                sh 'ansible-playbook /home/easyit/laravel/playbook.yml'
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
        }    
        }