pipeline {
    agent any
    tools {
        //Specify maven installation
        maven 'Maven'
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKER_IMAGE = "sonali5672/spring-petclinic"
        DOCKER_TAG = "v${BUILD_NUMBER}"
        GIT_OPS_REPO = "https://github.com/Sonali6309/spring-petclinic-k8s.git"
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
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
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
         stage('Update Kubernetes Manifests') {
            steps {
                script {
                    // Clone the GitOps repository
                    sh """
                        git clone ${GIT_OPS_REPO} k8s-manifests
                        cd k8s-manifests
                        sed -i 's|image: ${DOCKER_IMAGE}:.*|image: ${DOCKER_IMAGE}:${DOCKER_TAG}|' k8s/deployment.yaml
                        git config user.email "siddasonali219@gmail.com"
                        git config user.name "Sonali6309"
                        git add k8s/deployment.yaml
                        git commit -m "Update image to ${DOCKER_TAG}"
                        git push origin main
                    """
                }
            }
        }
        post {
        always {
            cleanWs()
        }
    }
    }

    

