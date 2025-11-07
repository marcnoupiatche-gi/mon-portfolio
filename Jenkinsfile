pipeline {
    agent any

    environment {
        SITE_PORT = '8081'
        DOCKER_IMAGE = 'marcnoupiatche/mon-portfolio'
        DOCKER_CREDENTIALS = 'docker-hub-creds'
    }

    stages {
        stage('Clonage') {
            steps {
                checkout scm
                echo "Clonage OK"
            }
            post { always { slackSend channel: '#jenkins-notifs', message: "Clonage #${BUILD_NUMBER}" } }
        }

        stage('Build & Push Image') {
            steps {
                script {
                    def img = docker.build("${DOCKER_IMAGE}:${BUILD_NUMBER}")
                    docker.withRegistry('', DOCKER_CREDENTIALS) {
                        img.push()
                        img.push('latest')
                    }
                }
            }
            post { always { slackSend channel: '#jenkins-notifs', message: "Image build & push #${BUILD_NUMBER}" } }
        }

        stage('Deploy Site') {
            steps {
                sh """
                    docker stop mon-site || true
                    docker rm mon-site || true
                    docker run -d -p ${SITE_PORT}:80 --name mon-site ${DOCKER_IMAGE}:${BUILD_NUMBER}
                    sleep 10
                """
            }
            post {
                success {
                    script {
                        def url = "http://localhost:${SITE_PORT}"
                        slackSend channel: '#jenkins-notifs', color: 'good', message: "*SITE EN LIGNE* → <${url}|OUVRIR>"
                        sh "powershell.exe -Command \"Start-Process '${url}'\""
                    }
                }
                always {
                    slackSend channel: '#jenkins-notifs', message: "Deploy #${BUILD_NUMBER}"
                }
            }
        }
    }

    post {
        failure {
            slackSend channel: '#jenkins-notifs', color: 'danger', message: "*ÉCHEC* @here #${BUILD_NUMBER}\n<https://i.giphy.com/media/3o6Zt6ML6BklcMDbUa/giphy.gif|CHAT EXPLOSION>"
        }
    }
}