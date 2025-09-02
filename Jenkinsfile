pipeline {
  agent any

  environment {
    MAVEN_IMG = 'maven:3.9.9'
    SONAR_HOST_URL = 'http://host.docker.internal:9001' // SonarQube บนเครื่องโฮสต์พอร์ต 9001
    PROJECT_DIR = '.'  // ถ้า pom.xml อยู่ใต้โฟลเดอร์ย่อย ให้เปลี่ยนเป็นเช่น 'java-hello-world-with-maven'
  }

  stages {
    stage('Show workspace & verify pom') {
      steps {
        sh '''
          echo "Workspace:"; pwd
          echo "List:"; ls -la
          test -f "${PROJECT_DIR}/pom.xml" || { echo "[ERR] pom.xml not found in ${PROJECT_DIR}"; exit 2; }
        '''
      }
    }

    stage('Maven Check') {
      steps {
        sh '''
          docker run --rm ${MAVEN_IMG} mvn -v
        '''
      }
    }

    stage('Build') {
      steps {
        sh '''
          docker run --rm \
            --add-host=host.docker.internal:host-gateway \
            -v "$WORKSPACE:/usr/src/mymaven" \
            -v "$HOME/.m2:/root/.m2" \
            -w "/usr/src/mymaven/${PROJECT_DIR}" \
            ${MAVEN_IMG} mvn -B -V clean install
        '''
      }
    }

    stage('SonarQube') {
      steps {
        sh '''
          docker run --rm \
            --add-host=host.docker.internal:host-gateway \
            -v "$WORKSPACE:/usr/src/mymaven" \
            -v "$HOME/.m2:/root/.m2" \
            -w "/usr/src/mymaven/${PROJECT_DIR}" \
            ${MAVEN_IMG} mvn -B -V clean verify sonar:sonar \
              -Dsonar.projectKey=SonarQube \
              -D"sonar.projectName=SonarQube" \
              -Dsonar.host.url='${SONAR_HOST_URL}' \
              -Dsonar.token=sqp_a4749a0abf33d63b8f52ad673b0694c64e36dd84
        '''
      }
    }
  }
}
