pipeline {
    agent {
        label 'agent-1'
    }
    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
        // retry(1)
    }
    environment {
        DEBUG = true
        appVersion = '1.0.0' // this will become global variable across the pipeline

    }
     
    stages {                               
        stage('Read the Version') {
            steps {
                script {
                    def packageJSON = readJSON file: 'package.json'
                    appVersion = packageJSON.version
                    echo "Version: ${appVersion}"
                }
            }
        }
        stage('Install Dependencies') {
            steps {                  
                sh "npm install"              
            } 
        }
        stage('Docker build') {
            
            steps {
                  sh """
                    docker build -t peddireddylokesh/backend:${appVersion} .
                    docker images
                  """
              
            }
        }
      
    }           
        

    post {
        always {
            echo 'This will always run'     
            deleteDir()
        }
        success {
            echo 'This will run only if the pipeline is successful'
        }
        failure {
            echo 'This will run only if the pipeline fails'
        }
        unstable {
            echo 'This will run only if the pipeline is unstable'
        }
    }
}