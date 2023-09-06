pipeline {
    agent any

    environment {
        REPO_URL = "https://github.com/prayag-sangode/html-app2.git"
        BRANCH = "main"  // Replace with the desired branch
        DOCKER_IMAGE_NAME = "prayags/html-app2"
    }

    stages {
        stage('Clean Workspace') {
            steps {
                // Clean the workspace at the beginning
                deleteDir()
            }
        }
        stage('Clone Repository') {
            steps {
                script {
                    // Create a workspace directory and navigate to it
                    sh "mkdir -p my-workspace"
                    dir('my-workspace') {
                        // Clone the Git repository using GitHub credentials
                        git credentialsId: 'github-id', url: REPO_URL, branch: BRANCH
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    dir('my-workspace') {
                        sh "pwd;ls"
                        sh "sudo docker build -t ${DOCKER_IMAGE_NAME} ."
                    }    
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Authenticate with Docker Hub using Jenkins credentials
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-id', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                        sh "sudo docker login -u ${DOCKERHUB_USERNAME} -p ${DOCKERHUB_PASSWORD}"
                        // Push Docker image to Docker Hub
                        sh "sudo docker push ${DOCKER_IMAGE_NAME}"
                        // Logout from Docker Hub (optional)
                        sh "sudo docker logout"
                    }
                }
            }
        }

        stage('Create Kubernetes Secret') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-id', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh "kubectl create secret generic regcred --from-literal=username=\$USERNAME --from-literal=password=\$PASSWORD"
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Use kubectl with the Kubernetes configuration content
                    dir('my-workspace') {
                    withCredentials([file(credentialsId: 'microk8s-id', variable: 'KUBECONFIG_FILE')]) {
                        sh "kubectl get nodes --kubeconfig=\${KUBECONFIG_FILE}"
                        sh "pwd;ls"
                        //sh "kubectl create secret generic regcred --from-file=.dockerconfigjson=docker-config.json --type=kubernetes.io/dockerconfigjson"
                        sh "kubectl apply -f deploy.yaml --kubeconfig=\${KUBECONFIG_FILE}"
                    }
                  }
                }
            }
        }

        // Add more stages for your pipeline here
    }

    post {
        success {
            echo "Pipeline completed successfully."
        }
        failure {
            echo "Pipeline failed."
        }
    }
}
