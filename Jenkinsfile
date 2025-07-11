pipeline {
    agent {
        label 'AGENT-1'
    }

    environment {
        PROJECT = 'expense'
        COMPONENT = 'backend'
        appVersion = ''
        region = 'us-east-1'
        environment = 'dev'
        ACC_ID = '897729141306'
        DEBUG = 'true'
    }

    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
    }
    parameters {
        booleanParam(name: 'deploy', defaultValue: false, description: 'Enter the application version')
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
                script{
                    sh  """

                        npm install
                    """
                }             
            } 
        }

        // stage('Run Sonarqube') {
        //     environment {
        //         scannerHome = tool 'SonarQube Scanner 7.1';
        //     }
        //     steps {
        //       withSonarQubeEnv('SonarQube Scanner 7.1') {
        //         sh "${scannerHome}/bin/sonar-scanner"
        //         // This is generic command works for any language
        //       }
        //     }
        // }
       /*  stage("Quality Gate") {
            steps {
              timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
              }
            }
        } */

        stage('Docker build') {
            steps {
                withAWS(region: 'us-east-1', credentials: 'aws-credentials') {
                    sh """
                        aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com

                        docker build -t ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}-${environment}-${COMPONENT}:${appVersion} .

                        docker images

                        docker push ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}-${environment}-${COMPONENT}:${appVersion}
                    """
                }
            }
        }
        stage('Trigger Deploy') {
            when {
                expression { params.deploy }
            }
            steps {
                build job: 'backend-cd', parameters: [string(name: 'version', value: "${appVersion}")],wait: true        
            }
        }    
    }           

    post {
        always {
            echo 'This will always run'
            cleanWs()  // 💡 Jenkins built-in step to clean workspace
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
