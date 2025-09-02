pipeline {
  agent any
  tools {
    jdk 'Temurin-17'
    maven 'Maven-3.9.9'
  }
  environment {
    SONAR_HOST_URL = 'http://localhost:9001'  // คุณใช้ 9001
  }
  stages {
    stage('Maven Check') {
      steps {
        sh 'mvn -v'
      }
    }
    stage('Build') {
      steps {
        sh 'mvn -B -V clean install'
      }
    }
    stage('SonarQube') {
      steps {
        withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
          sh '''
            mvn -B -V sonar:sonar \
              -Dsonar.projectKey=SonarQube \
              -D"sonar.projectName=SonarQube" \
              -Dsonar.host.url=${SONAR_HOST_URL} \
              -Dsonar.token=${SONAR_TOKEN}
          '''
        }
      }
    }
  }
}
