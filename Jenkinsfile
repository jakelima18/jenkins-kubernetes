def label = "kaniko-${UUID.randomUUID().toString()}"
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
        mountPath: /root
  volumes:
  - name: jenkins-docker-cfg
      - secret:
          name: jenkins-docker-cfg
"""
  ) {
  node(label) {
    stage('Build with Kaniko') {
      git 'https://github.com/jakelima18/forum-laravel-kubernetes.git'
      container(name: 'kaniko', shell: '/busybox/sh') {
          sh '''#!/busybox/sh
          /kaniko/executor -f Dockerfile --destination=jacksonlima91/forum-app:$BUILD_NUMBER  
          '''
      }
    }
  }
}