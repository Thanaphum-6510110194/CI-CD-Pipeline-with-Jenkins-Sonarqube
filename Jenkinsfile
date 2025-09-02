pipeline {
  agent any

  environment {
    MAVEN_IMG = 'maven:3.9.9'
    SONAR_HOST_URL = 'http://host.docker.internal:9001'
  }

  stages {
    stage('Maven Check') {
      steps {
        sh '''
          docker run --rm \
            --add-host=host.docker.internal:host-gateway \
            ${MAVEN_IMG} mvn -v
        '''
      }
    }

    stage('Build') {
      steps {
        sh '''
          docker run --rm \
            --add-host=host.docker.internal:host-gateway \
            -v "$PWD:/usr/src/mymaven" \
            -v "$HOME/.m2:/root/.m2" \
            -w /usr/src/mymaven \
            ${MAVEN_IMG} mvn -B -V clean install
        '''
      }
    }

    stage('SonarQube') {
      steps {
        withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
          sh '''
            docker run --rm \
              --add-host=host.docker.internal:host-gateway \
              -v "$PWD:/usr/src/mymaven" \
              -v "$HOME/.m2:/root/.m2" \
              -w /usr/src/mymaven \
              ${MAVEN_IMG} mvn -B -V clean verify sonar:sonar \
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
