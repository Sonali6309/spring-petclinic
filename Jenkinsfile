pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKER_IMAGE = "sonali5672/spring-petclinic"
        DOCKER_TAG = "v${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push Docker Image to Registry') {
            steps {
                script {
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
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
