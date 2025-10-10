pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "greet-app:00"
        HELM_RELEASE = "greet-app-release"
        HELM_CHART = "greet-app-chart"
	SONARQUBE_SERVER = 'SonarQube'
        SONAR_TOKEN = credentials('sonarqube-token')
    }

    stages {
        stage('Cloning') {
            steps {
                checkout scm
            }
        }
	stage('Code Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    sh '''
                        sonar-scanner  \
                        -Dsonar.projectKey=greet-app \
                        -Dsonar.projectName="Greet App" \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://localhost:9000 \
                        -Dsonar.login=${SONAR_TOKEN}
                    '''
                }
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
                    helm uninstall ${HELM_RELEASE} || echo "Release not found, continuing..."
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
		input message: "Wanna approve?", ok: "Merge"
            }
        }
    }
	// post{
	// 	success {
	// 		build job: "GreetAppCD"
	// 	}
	// }
}



