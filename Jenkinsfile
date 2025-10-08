pipeline{
    agent any
    environment {
		
	DOCKER_IMAGE = "greet-app:00"
        HELM_RELEASE = "greet-app-release"
        HELM_CHART = "greet-app-chart" }
	stage('Cloning') {
            steps {
                checkout scm
            }
        }

        stage('Building') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

	
	stage('Deployment') {
            steps {
                sh '''
                    helm uninstall ${HELM_RELEASE} || echo "Release not found, skipping uninstall"
                    helm install ${HELM_RELEASE} ${HELM_CHART}
                '''
            }
        }
	
	stage('Pods') {
            steps {
                sh '''
                    kubectl get pods
                    sleep 10
                '''
            }
        }

      
            }
        }
    }
}
