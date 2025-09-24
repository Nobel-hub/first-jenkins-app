pipeline {
    agent any
    environment {
        CONTAINER_REGISTRY_AND_REPOSITORY = "nobeldhakal/javaapp"
    }

    stages {
        stage("Compile") {
            steps {
                echo "Compiling the code...."
                sh "mvn clean compile"
            }
        }

        stage("Unit Test") {
            steps {
                echo "Running the unit tests...."
                sh "mvn test"
            }
        }

        stage("Build") {
            agent {
                label 'node-for-mavenapp'
            }
            steps {
                echo "Building the image...."
                sh "mvn clean package"
            }
            post {
                success {
                    echo "Build Successful, archiving the artifacts....."
                    archiveArtifacts artifacts: '**/*.war', followSymlinks: false
                }
            }
        }

        stage("Create Docker image") {
            agent {
                label 'node-for-mavenapp'
            }
            steps {
                echo "Creating the Docker image for the app..."
                sh "docker image build -t ${env.CONTAINER_REGISTRY_AND_REPOSITORY}:${env.BUILD_NUMBER} ."
            }
        }

        stage("Scanning the image") {
            agent {
                label 'node-for-mavenapp'
            }
            steps {
                echo "Scanning the available docker image...."
                sh "trivy image --scanners vuln --severity HIGH,CRITICAL --ignore-unfixed ${env.CONTAINER_REGISTRY_AND_REPOSITORY}:${env.BUILD_NUMBER} --format json -o report.json --exit-code 1"
            }
        }

        stage("Push the image") {
            agent {
                label 'node-for-mavenapp'
            }
            steps {
                echo "Pushing the docker image to Dockerhub....."
                withDockerRegistry([credentialsId: 'docregcred', url: '']) {
                    sh "docker image push ${env.CONTAINER_REGISTRY_AND_REPOSITORY}:${env.BUILD_NUMBER}"
                }
            }
        }

        stage("Deploy an app to Dev environment") {
            steps {
                echo "Running the image and opening the application in dev environment...."
                sh "docker rm -f myapp-dev || true"
                sh "docker container run -d --name myapp-dev -p 8086:8080 ${env.CONTAINER_REGISTRY_AND_REPOSITORY}:${env.BUILD_NUMBER}"
            }
        }

        stage("Deploy an app to Prod environment") {
            steps {
                script {
                    timeout(time: 1, unit: 'DAYS') {
                        input message: "Are you sure you want to deploy it to production instance?"
                    }

                    echo "Running the image and opening the application in prod environment...."
                    sh "docker rm -f myapp-prod || true"
                    sh "docker container run -d --name myapp-prod -p 8087:8080 ${env.CONTAINER_REGISTRY_AND_REPOSITORY}:${env.BUILD_NUMBER}"
                }
            }
        }
    }

    post {
        always {
            mail to: 'nobeldhakal01@gmail.com',
                 subject: "Job '${JOB_NAME}' (${BUILD_NUMBER}) is waiting for input",
                 body: "Please go to ${BUILD_URL} and verify the build"
        }
        success {
            mail bcc: '',
                 body: """Hi Team,

Build #${BUILD_NUMBER} is successful, please go through the url

${BUILD_URL}

and verify the details.

Regards,
DevOps Team""",
                 cc: '',
                 from: '',
                 replyTo: '',
                 subject: 'BUILD SUCCESS NOTIFICATION',
                 to: 'nobeldhakal01@gmail.com'
        }
        failure {
            mail bcc: '',
                 body: """Hi Team,
            
Build #${BUILD_NUMBER} is unsuccessful, please go through the url

${BUILD_URL}

and verify the details.

Regards,
DevOps Team""",
                 cc: '',
                 from: '',
                 replyTo: '',
                 subject: 'BUILD FAILED NOTIFICATION',
                 to: 'nobeldhakal01@gmail.com'
        }
    }
}
