pipeline {
    agent any

    stages {
        stage('Maven Check') {
            steps {
                sh 'docker run --rm maven:3.9.9 mvn --version'
            }
        }

        stage('Build') {
                        steps {
                                sh '''
                                docker run --rm \
                                    -v "/PSU Student/4_1/240-331 Mobile app Dev/Kitwara-DevOps/W3D2/java-hello-world-with-maven:/usr/src/mymaven" \
                                    -w /usr/src/mymaven maven:3.9.9 mvn clean install
                                '''
            }
        }

        stage('SonarQube') {
                        steps {
                                sh '''
                                docker run --rm \
                                    -v "/PSU Student/4_1/240-331 Mobile app Dev/Kitwara-DevOps/W3D2/java-hello-world-with-maven:/usr/src/mymaven" \
                                    -w /usr/src/mymaven maven:3.9.9 \
                                    mvn clean verify sonar:sonar \
                                    -Dsonar.projectKey=sample-sonarqube-lab \
                                    -Dsonar.projectName="sample-sonarqube-lab" \
                                    -Dsonar.host.url=http://host.docker.internal:9001/ \
                                    -Dsonar.token=sqp_49ec14e48eaf48cb02e34f1345e84aeabaf25101
                                '''
            }
        }
    }
}