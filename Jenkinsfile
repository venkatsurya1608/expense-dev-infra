pipeline {
    agent {
        label 'AGENT-1'
    }
    options {
        timeout(time: 1, unit: 'SECONDS')
        disableConcurrentBuilds()
    }
    environment { 
        Deploy_To = 'dev'
    }    
    stages {
        stage('init') { 
            steps {
                sh """
                 cd 01-vpc
                 terraform init -reconfigure
                """
            }
        }
        stage('plan') { 
            steps {
                sh 'echo this venkat-test' 
            }
        }
        stage('Deploy') { 
            steps {
                sh 'echo this is production'
            }
        }
    }
}

