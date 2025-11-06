pipeline {
    agent any
    stages {
        stage('Clonage') {
            steps { 
                checkout scm
                echo "Clonage terminé" 
            }
            post { 
                always { 
                    slackSend channel: '#jenkins-notifs', 
                              color: 'good', 
                              message: "*Clonage* terminé pour `${env.JOB_NAME}` #${env.BUILD_NUMBER}\n<${env.BUILD_URL}|Voir console>" 
                } 
            }
        }
        stage('Build') {
            steps { 
                sh 'echo "Build en cours..." && sleep 2' 
            }
            post { 
                always { 
                    slackSend channel: '#jenkins-notifs', 
                              color: 'good', 
                              message: "*Build* terminé #${env.BUILD_NUMBER}\n<${env.BUILD_URL}|Voir console>" 
                } 
            }
        }
        stage('Deploy') {
            steps { 
                sh 'echo "Deploy en cours..." && sleep 2' 
            }
            post { 
                always { 
                    slackSend channel: '#jenkins-notifs', 
                              color: 'good', 
                              message: "*Deploy* terminé #${env.BUILD_NUMBER}\n<${env.BUILD_URL}|Voir console>" 
                } 
            }
        }
    }
    post {
        success { 
            slackSend channel: '#jenkins-notifs', 
                      color: 'good', 
                      message: "*Pipeline COMPLET RÉUSSI* `${env.JOB_NAME}` #${env.BUILD_NUMBER}\n<${env.BUILD_URL}|Voir tout>" 
        }
        failure { 
            slackSend channel: '#jenkins-notifs', 
                      color: 'danger', 
                      message: "*Pipeline ÉCHOUÉ* @here #${env.BUILD_NUMBER}\n<https://i.giphy.com/media/3o6Zt6ML6BklcMDbUa/giphy.gif|CHAT EXPLOSION>\n<${env.BUILD_URL}|Corrige ça !>" 
        }
    }
}
