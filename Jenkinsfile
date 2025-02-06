pipeline {
    agent any

    environment {
        IMAGE_NAME = "spring-petclinic-app"
        IMAGE_TAG = "latest"
        DOCKER_REGISTRY = "https://hub.docker.com/u/sonali5672"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Application') {
            steps {
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Push Docker Image to Registry') {
            steps {
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-credentials-id') {
                        sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
                        sh "docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
                    }
                }
            }
        }

        stage('Deploy Application') {
            steps {
                script {
                    // Stop any existing container
                    sh "docker stop spring-petclinic-container || true"
                    sh "docker rm spring-petclinic-container || true"
                    
                    // Run a new container
                    sh """
                    docker run --name spring-petclinic-container -d -p 8082:8082
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
