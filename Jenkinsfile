pipeline {
    agent any

    stages {
        stage('Maven Check') {
            steps {
                sh 'docker run -i --rm --name my-maven-project maven:3.9.9 mvn --version'
            }
        }
        stage('Build') {
            steps {
                sh 'docker run -i --rm --name my-maven-project -v "/PSU Student/4_1/240-331 Mobile app Dev/Kitwara-DevOps/W3D2/java-hello-world-with-maven:/usr/src/mymaven" -w /usr/src/mymaven maven:3.9.9 mvn clean install'
            }
        }
        stage('SonarQube') {
                        steps {
                                sh '''
                                docker run -i --rm --name my-maven-project \
                                    -v "/PSU Student/4_1/240-331 Mobile app Dev/Kitwara-DevOps/W3D2/java-hello-world-with-maven:/usr/src/mymaven" \
                                    -w /usr/src/mymaven maven:3.9.9 \
                                    mvn clean verify sonar:sonar \
                                    -Dsonar.projectKey=SonarQube \
                                    -Dsonar.projectName='SonarQube' \
                                    -Dsonar.host.url=http://localhost:9001 \
                                    -Dsonar.token=sqp_a4749a0abf33d63b8f52ad673b0694c64e36dd84
                                '''
            }
        }
    }
}
