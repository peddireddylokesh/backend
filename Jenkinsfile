pipeline {
    agent {
        label 'AGENT-1'
       
    }

    environment {
        PROJECT = 'expense'
        COMPONENT = 'backend'
        appVersion = ''
        ACC_ID = '897729141306'
    }
    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
        // retry(1)
    }
    // environment {
    //     DEBUG = true
    //     appVersion = '1.0.0' // this will become global variable across the pipeline

    // }
     
    stages {                               
        stage('Read the Version') {
            steps {
                script {
                    def packageJSON = readJSON file: 'package.json'
                    appVersion = packageJSON.version
                    echo "Version: ${env.appVersion}"
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
                withAWS(region: 'us-east-1', credentials: 'aws-credentials') {
                  sh """
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com
                    docker build -t ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion} .
                    docker push ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion}
                  """
                    // docker build -t peddireddylokesh/backend:${appVersion} .
                    // docker images  # these both lines need to put in """   above  """ im practing so i put it here
                }
            }
        }    
      
    }           
        

    post {
        always {
            node {
                echo 'This will always run'
                deleteDir() // Wrapped inside script to ensure proper node context
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
}