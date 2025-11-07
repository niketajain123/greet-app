pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "niketa15jain/greet-app:${BUILD_NUMBER}"
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
	// stage('Code Analysis') {
 //            steps {
 //                withSonarQubeEnv("${SONARQUBE_SERVER}") {
 //                    sh '''
 //                        sonar-scanner  \
 //                        -Dsonar.projectKey=greet-app \
 //                        -Dsonar.projectName="Greet App" \
 //                        -Dsonar.sources=. \
 //                        -Dsonar.host.url=http://localhost:9000 \
 //                        -Dsonar.token=${SONAR_TOKEN} \
	// 					-Dsonar.python.version=3.10
 //                    '''
 //                }
 //            }
 //        }
	



	
        stage('Building') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
		sh "docker login -u niketa15jain -p niketa15jain"
		sh "docker push ${DOCKER_IMAGE}"
            }
        }

        stage('Deployment') {
            steps {
                
                //    helm uninstall ${HELM_RELEASE} || echo "Release not found, continuing..."
                //    helm install ${HELM_RELEASE} ${HELM_CHART}
		sh '''
    			helm upgrade --install ${HELM_RELEASE} ${HELM_CHART} \
   			 --set image.repository=niketa15jain/greet-app \
   			 --set image.tag=${BUILD_NUMBER}
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
	post {
    success {
        withCredentials([string(credentialsId: 'slack-webhook', variable: 'SLACK_WEBHOOK')]) {
            sh '''
            curl -X POST -H 'Content-type: application/json' \
            --data '{"text":"✅ Deployment succeeded for greet-app!"}' \
            $SLACK_WEBHOOK
            '''
        }
    }
    failure {
        withCredentials([string(credentialsId: 'slack-webhook', variable: 'SLACK_WEBHOOK')]) {
            sh '''
            curl -X POST -H 'Content-type: application/json' \
            --data '{"text":"❌ Deployment failed for greet-app."}' \
            $SLACK_WEBHOOK
            '''
        }
    }
}
}









