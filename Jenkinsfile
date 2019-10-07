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
  }
podTemplate(name: 'phpunit', label: unit, yaml: """
kind: Pod
metadata:
  name: two-containers
spec:
  containers:
  - name: backend
    image: jacksonlima91/forum-app:$BUILD_NUMBER

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
  node(unit) {
    stage('Unit Test') {
      container(name: 'backend', shell: '/bin/bash') {
          sh '/var/www/forum/waitforit.sh localhost:3306 -t 90'
          sh '/var/www/forum/vendor/bin/phpunit -c /var/www/forum/phpunit.xml'
      }
    }
  }
  }
  node {
  stage('Deploy') {
    container(name: 'kubectl')  {
     withKubeConfig([credentialsId: 'kubectl', serverUrl: 'https://13.92.176.247:443', caCertificate: 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUV5RENDQXJDZ0F3SUJBZ0lSQUlqV0xvaDlEUklRV1hpa2NKUkJvbUV3RFFZSktvWklodmNOQVFFTEJRQXcKRFRFTE1Ba0dBMVVFQXhNQ1kyRXdIaGNOTVRrd09URXlNakV4TXpReldoY05ORGt3T1RBME1qRXlNelF6V2pBTgpNUXN3Q1FZRFZRUURFd0pqWVRDQ0FpSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnSVBBRENDQWdvQ2dnSUJBT3hlClVpRXJQMnJSN1Z6Wk5rNHAyc3hRcDZRY1VIY2VqTjQ2Wm1PdlZoQzJBSGZsbVJnQWNoM0ZNOXNoSk1DOEpVUXIKUjNVcjNSdHhxV0Z0RlB5ZUxQUnJ4YzlZRVFabFEvUldjcy9Ca0ppenZlbmU4b215TGZOamc1SFdnSXdZSVFWYgpZZ09hUGN3V0NDaFFBeWVacEFFSWhOQXZxVVdsZElucDlkZzk4R2dRRVZ0N1VEOUxyeHVtZ0FDSFJqcXAyZVBXCjM1UDVTaUM1MnVNUksrZ2hHajdjYk0zQnA0MlVaRG90RWpveHRiWVV6TWh3VUNOaDdnN2o1UXpkdTQ5alVCeWwKVytweEVsYlJFeTliKzNJcXlNenBTdWx3R0cxelFWNkg4b2tRZ09yWjJrY0lBMjJ4Y2VVMC9qT3VNRE1ybk1LdQpEc3pTdG9zMlduMXRuS2EzZXk3Z0tPUE5JWWtyR1VtSk1ENjcxc1NzSGJPN3g3aTdMN29XTjc4Ni9YQ29aU3JCCkM3MjdZamd1YnZNUVNMaHkyaGVFTENWaXhBdVY1YmQ2Wkxxcm13U0d5T3A4eDlKVWRsNmZsU0NlT3pORVNLeUQKUEFqSWtNWmhYRVVveCtNdEUvbUtYY3R4NXI5RHRSTFQ5clRic0NTL1ZiY1VoWjFONXA4Rk5vLzhxQ3puSlQ5eQp1YnZRa0lWaVpaSDZ5bmc4UDhKWFVOUmVKNXE3RzlIUWhjTUU3c20waXRockRPN1JjcWg3MWI0ZTBWV0ZhbEZLCjRSUmJjU0JIaU1MRFFmTThqc1ByL1hTQ0hMVnJZRjhFZGZ1U3k4eHFlZnNhOG9WWUNHRDlaeXVJTk51N0JWQ2QKNTVneHlUdDhKWlhnMklTZzdGWUFWMzVrV0VkRDR2TDhlZ1JCb29COUFnTUJBQUdqSXpBaE1BNEdBMVVkRHdFQgovd1FFQXdJQ3BEQVBCZ05WSFJNQkFmOEVCVEFEQVFIL01BMEdDU3FHU0liM0RRRUJDd1VBQTRJQ0FRQXgxcG1kCjVzcjZVVC9IWHZPZm4yOHFESXdwSnlzVUJIdGtzbWtJdGlLUnJsTnpNOHRDQXF5ckV0VUVmR2RPbUdFdXNMRlIKbVJlZXE2TXB6YzEzQ1ZWRW1OOWJFMkhBNGVIMUEwSzdUZldWdGF4Vm5UQ2RvZTN2VlVEVllhNTh4S0lJZGZrYgpKQm5QNmhHSEYyMlpVVkFiQWhTZ1loSE42K3VLb3NzdUVJRkducXI4b2o2UU9vbEJuNVY0V2Q5R1ZLOUE4bitGCjFNWVZWc1pkcnNQSElWKzNyNXdlL29ITkR3SzJCamxDOWd3RHduMXlQVWUvcG9wV0I2Q2NMSmR5bHltV2NQVjIKa05jL2tVTUc4QUxxcURTSnNsK1BEYVZIRFlUdEpzMkhXN1JWUE9wZ3Z6TEpoNUdzajhQOFZHdEkyTzJmM3AydgpYSjJUOGttY2dWaUdIVzgvWW91TVM2YjFsZVpUQnJoZmkxUHZQVDBhcDR4Rm9tRVJha011em5RSmNCUHBzVDlFCkNheGpPdDFEREpOYytBdHU5YkMweVRSTmY3ckd6MzBvSTFYS3U4SVZ5dlBEYk9HMWFNY0JjTmN2dGRSMi9MUjgKa3JZdzV5eGl1L2FoenRpSkN1cnRqM3c4S3NUUUxJODlxRTFSams5QVduSTVjeWZId0FRQ25jYlh2UHN2a0VuNApUc0xiS05Wenl6RkZzWUpncFkxYWR2WC83SDBBdnpKTkkzTEYrVmV2R3N0dFpSajZvL042bmt4SDFoWGxtY0tHCmJVYUNYdVFLMHJmZ0FiMnZaZThSdTY3WjBzWlRjMUFlRjFMeGgxeDRMZ09QUVhtVUt6c3YwTm1QSVdUbmFOMjIKZ05ZV1pqSmpFYWRBcm1sT1JsUjNTKytVUU5wSStWdkE4VGN4OWc9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==', contextName: 'jenkins-kubernetes', clusterName: 'jenkins-kubernetes']) {
      sh 'kubectl set image deployment/forum-app backend=jacksonlima91/forum-app:$BUILD_NUMBER'
    }
      }
  }
}