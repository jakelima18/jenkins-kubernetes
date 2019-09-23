pipeline {
    /* insert Declarative Pipeline here */
   agent any
   stages {
        stage('Build Docker') {
            steps {
                sh 'cp .env.example .env'
                sh "sed 's/DB_HOST.*/DB_HOST=database/g' .env.testing'"
                sh "sed 's/DB_HOST.*/DB_HOST=database/g' .env'"
                sh 'docker build -t jacksonlima91/forum-app:$BUILD_NUMBER .'
                sh 'docker build -t jacksonlima91/forum-web:$BUILD_NUMBER -f Dockerfile_Nginx .'
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