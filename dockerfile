FROM jenkins/jenkins:lts
USER root
RUN apt-get update && apt-get install -y docker.io && rm -rf /var/lib/apt/lists/*
RUN groupadd -f docker && usermod -aG docker jenkins
USER jenkins
