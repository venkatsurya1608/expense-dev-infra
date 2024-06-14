pipeline {
    agent {
        label 'AGENT-1'
    }
    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
        ansiColor('xterm')
    }
    // parameters {
    //     choice(name: 'action', choices: ['Apply', 'Destroy'], description: 'Pick something')
    // }
    stages {
        stage('Init') {
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
                sh 'echo this is dev'
            }
        }
    }
}

