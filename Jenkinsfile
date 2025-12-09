pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "niketa15jain/greet-app:${BUILD_NUMBER}"
        HELM_RELEASE = "greet-app-release"
        HELM_CHART = "greet-app-chart"
    }

    stages {
        stage('Cloning') {
            steps {
                checkout scm
            }
        }	
        stage('Building') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
		sh "docker login -u niketa15jain -p niketa15jain"
		sh "docker push ${DOCKER_IMAGE}"
            }
        }

        stage('Deployment') {
            steps {
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
                '''
		input message: "Wanna approve?", ok: "Merge"
            }
        }
    }
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














