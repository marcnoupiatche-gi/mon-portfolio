pipeline {
    agent any

    environment {
        SITE_PORT = '8083'  // Port différent pour ton site (change si besoin)
        DOCKER_IMAGE = 'marcnoupiatche/mon-portfolio'  // Nom de ton image Docker (ex. : user/repo)
        DOCKER_REGISTRY = 'https://index.docker.io/v1/'  // Docker Hub par défaut
        DOCKER_CREDENTIALS = 'docker-hub-creds'  // ID de tes creds dans Jenkins (ajoute-les via Manage Credentials > Secret text avec user/pass Docker)
    }

    stages {
        stage('Clonage') {
            steps {
                checkout scm
                echo "Clonage du code sur branche dev terminé"
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
                echo "Lancement du build..."
                sh 'echo "Build en cours..." && sleep 2'  // Remplace par tes commandes réelles (ex. : npm install ou mvn build)
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
                script {
                    echo "Build et push de l'image Docker..."
                    // Build l'image Docker (assume un Dockerfile à la racine)
                    docker.build("${DOCKER_IMAGE}:${env.BUILD_NUMBER}")

                    // Push vers le registry
                    docker.withRegistry(DOCKER_REGISTRY, DOCKER_CREDENTIALS) {
                        dockerImage = docker.image("${DOCKER_IMAGE}:${env.BUILD_NUMBER}")
                        dockerImage.push()
                        dockerImage.push('latest')  // Optionnel : tag latest
                    }

                    echo "Lancement du site sur port ${SITE_PORT}..."
                    // Lance le container/site (ex. : pour un site web simple ; adapte à ton app)
                    sh """
                        docker run -d -p ${SITE_PORT}:80 --name mon-site ${DOCKER_IMAGE}:${env.BUILD_NUMBER}
                        sleep 5  // Donne du temps pour démarrer
                    """
                }
            }
            post {
                success {
                    script {
                        def siteUrl = "http://localhost:${SITE_PORT}"
                        slackSend channel: '#jenkins-notifs',
                                  color: 'good',
                                  message: """
*Deploy réussi !*  
`${env.JOB_NAME}` #${env.BUILD_NUMBER}  
Image poussée : ${DOCKER_IMAGE}:${env.BUILD_NUMBER}  
Lien site : <${siteUrl}|Ouvrir le site>  
Console : <${env.BUILD_URL}|Voir logs>
"""
                        // Ouvre le navigateur automatiquement
                        if (isUnix()) {
                            sh "xdg-open ${siteUrl} || true"
                        } else {
                            bat "start ${siteUrl}"
                        }
                    }
                }
                always {
                    slackSend channel: '#jenkins-notifs',
                              message: "*Deploy* terminé #${env.BUILD_NUMBER}"
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