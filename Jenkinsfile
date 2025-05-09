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
        stage('Deploy') {
             when {
                expression { env.GIT_BRANCH = 'origin/main'}
            }
            steps {
                  
                sh "echo 'This is Deploying...'"
                // error "This is error in the Deploy stage"
            }
        }
        stage('PrintParams') {
            steps {
                echo "Hello ${params.PERSON}"
                echo "Biography: ${params.BIOGRAPHY}"
                echo "Toggle: ${params.TOGGLE}"
                echo "Choice: ${params.CHOICE}"
                echo "Password: ${params.PASSWORD}"                
            }
        }
        // stage('Approval') {
        //     input {
        //         message "Should we continue?"
        //         ok "Yes, we  should."
        //         submitter "alice,bob"
        //         parameters {
        //             string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
        //         }
        //     }
        //     steps {
        //         echo "Hello, ${PERSON}, nice to meet you."
        //     }
        // }
    
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