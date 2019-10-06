def label = "kaniko-${UUID.randomUUID().toString()}"
def unit  = "phpunit-${UUID.randomUUID().toString()}"
podTemplate(name: 'kaniko', label: label, yaml: """
kind: Pod
metadata:
  name: kaniko
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    command:
    - /busybox/cat
    tty: true
    volumeMounts:
      - name: jenkins-docker-cfg
        mountPath: /kaniko/.docker
  volumes:
  - name: jenkins-docker-cfg
    projected:
      sources:
      - secret:
          name: jenkins-docker-cfg
          items:
            - key: .dockerconfigjson
              path: config.json               
"""
  ) 

podTemplate(name: 'phpunit', label: unit, yaml: """
kind: Pod
metadata:
  name: two-containers
  namespace: test
spec:
  containers:
  - name: backend
    image: jacksonlima91/forum-app:30

  - name: mysql
    image: mysql:5.7
    args:
        - "--ignore-db-dir=lost+found"
    env:
        - name: MYSQL_ROOT_PASSWORD
          value: schoolofnet
        - name: MYSQL_PASSWORD
          value: secret
        - name: MYSQL_DATABASE
          value: homestead
        - name: MYSQL_USER
          value: laravel_user
    ports:
    - containerPort: 3306
      name: mysql         
"""
  ) 


  {
  node(label) {
    stage('Build Kaniko') {
      git 'https://github.com/jakelima18/jenkins-kubernetes.git'
      container(name: 'kaniko', shell: '/busybox/sh') {
          sh '''#!/busybox/sh
          /kaniko/executor -f Dockerfile -c `pwd` --destination=jacksonlima91/forum-app:$BUILD_NUMBER 
          '''
      }
    }
  }
  {
  node(unit) {
    stage('Unit Test') {
      container(name: 'backend') {
          sh 'vendor/bin/phpunit'
      }
    }
  }

}