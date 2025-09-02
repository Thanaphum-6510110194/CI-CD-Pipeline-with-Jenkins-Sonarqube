pipeline {
  agent any

  environment {
    MAVEN_IMG      = 'maven:3.9.9'
    JENKINS_CTN    = 'jenkins_master'             // <-- ถ้าคอนเทนเนอร์ Jenkins ชื่ออื่น ให้แก้ตรงนี้
    PROJECT_DIR    = '.'                           // <-- ถ้า pom.xml อยู่ในโฟลเดอร์ย่อย ให้ใส่ชื่อโฟลเดอร์แทนจุด
    SONAR_URL      = 'http://host.docker.internal:9001'  // อย่าเติม / ท้าย URL
    SONAR_KEY      = 'SonarQube'
    SONAR_NAME     = 'SonarQube'
    SONAR_TOKEN    = 'sqp_a4749a0abf33d63b8f52ad673b0694c64e36dd84' // แนะนำให้ย้ายไป Credentials ภายหลัง
  }

  stages {
    stage('Show workspace & verify pom') {
      steps {
        sh '''
          echo "== Workspace =="
          pwd
          echo "== List root =="
          ls -la
          echo "== Check pom.xml at ${PROJECT_DIR} =="
          ls -la "${WORKSPACE}/${PROJECT_DIR}" || true
          test -f "${WORKSPACE}/${PROJECT_DIR}/pom.xml" || { echo "[ERR] pom.xml not found at ${WORKSPACE}/${PROJECT_DIR}"; exit 2; }
        '''
      }
    }

    stage('Prep cache') {
      steps {
        // เตรียมโฟลเดอร์ cache ของ Maven ในโวลุ่ม Jenkins (ช่วยให้ build เร็วขึ้น)
        sh 'mkdir -p /var/jenkins_home/.m2'
      }
    }

    stage('Maven Check') {
      steps {
        sh 'docker run --rm ${MAVEN_IMG} mvn -v'
      }
    }

    stage('Build') {
      steps {
        sh '''
          docker run --rm \
            --add-host=host.docker.internal:host-gateway \
            --volumes-from ${JENKINS_CTN} \
            -v /var/jenkins_home/.m2:/root/.m2 \
            -w "${WORKSPACE}/${PROJECT_DIR}" \
            ${MAVEN_IMG} mvn -B -V clean install
        '''
      }
    }

    stage('SonarQube') {
        steps {
            sh '''
            docker run --rm \
                --add-host=host.docker.internal:host-gateway \
                --volumes-from ${JENKINS_CTN} \
                -v /var/jenkins_home/.m2:/root/.m2 \
                -w "${WORKSPACE}/${PROJECT_DIR}" \
                ${MAVEN_IMG} mvn -B -V clean verify sonar:sonar \
                -Dsonar.projectKey=${SONAR_KEY} \
                -Dsonar.projectName="${SONAR_NAME}" \
                -Dsonar.host.url=${SONAR_URL} \
                -Dsonar.token=${SONAR_TOKEN}
            '''
        }
    }
  }
}
