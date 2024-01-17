pipeline {
    agent {
        label 'built-in'
    }

    options {
        buildDiscarder logRotator(artifactNumToKeepStr: '25', numToKeepStr: '25')
        skipDefaultCheckout()
    }

    stages {
        stage('Source Code Checkout') {
            steps {
                checkout scm
            }
        }
 
        stage('Check Commit Message') {
            when { 
                expression { return env.BRANCH_NAME.startsWith('dev') }
            }
            steps {
                script {
                    def comMessage = sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim()
                    def comTitle = comMessage.split("\n")[0]

                    // Check the message commit for compliance with best practice (first ticket gira code)

                    if (!comTitle.matches('^[A-Z]+-[0-9]+.*')) {
                        error("Commit title does not start with a JIRA ticket code")
                    }

                    // Checking the length of the commit header
                    if (comTitle.length() > 50) {
                        error("Commit title is longer than 50 characters")
                    }
                }
            }
        }

        stage('Linting Dockerfile') {
            steps {
                script {
                    sh 'docker run --rm -i hadolint/hadolint:2.10.0 < Dockerfile | tee -a docker_lint.txt'
                    echo "There are no erros found on Dockerfile!!"
                }
            }
        }

        stage('Check for Feature Branches') {
            steps {
                script {
                    def branches = checkout([$class: 'GitSCM', branches: [[name: '*/feature']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/ZhannaGuseva/jenkins-multi']]])

                    if (branches.size() > 0) {
                        echo('Warning: Merging feature branch into master NOT allowed! USE branch protection rules in Git')
                    }
                }
            }
        }
    }
    post {
        failure {
            script {
                echo 'Pipeline FAILED '
            }
        }
        success {
            script {
                echo 'Pipeline execution was Successful'
            }
        }
        always {
            archiveArtifacts 'docker_lint.txt'
        }
    }
}
