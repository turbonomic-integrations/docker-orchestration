pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'ls -alh'
                sh 'docker build --build-arg flavor=alpine -t turbointegrations/orchestration:0.1-alpine .'
                sh 'docker build --build-arg flavor=slim-buster -t turbointegrations/orchestration:0.1-slim-buster .'
                sh 'docker build --build-arg flavor=rhel -t turbointegrations/orchestration:0.1-rhel .'
            }
        }

        stage('Publish') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DockerHub', passwordVariable: 'DHPASS', usernameVariable: 'DHUSER')]) {
                    sh 'docker login -u $DHUSER -p $DHPASS'
                    sh 'docker push turbointegrations/orchestration:0.1-alpine'
                    sh 'docker push turbointegrations/orchestration:0.1-slim-buster'
                    sh 'docker push turbointegrations/orchestration:0.1-rhel'
                }
            }
        }
    }
}
