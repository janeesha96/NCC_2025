pipeline {
    agent any

    environment {
        DOCKER_BFLASK_IMAGE = 'janeesha/gscomp283'
        DOCKER_REGISTRY_CREDS = 'docker-jenkins-token-1'
    }

    stages {
        stage('Build') {
            steps {
                sh 'docker build -t gscomp283 .'
                sh 'docker tag gscomp283 $DOCKER_BFLASK_IMAGE'
            }
        }

        stage('Deploy') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKER_REGISTRY_CREDS}",
                    passwordVariable: 'DOCKER_PASSWORD',
                    usernameVariable: 'DOCKER_USERNAME'
                )]) {
                    sh """
                        echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin docker.io
                        docker push $DOCKER_BFLASK_IMAGE
                    """
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}

