pipeline{
    agent any
    environment{
        CONTAINER_REGISTRY_AND_REPOSITORY="nobeldhakal/javaapp"
    }
    stages {
        stage("Compile"){
            steps {
                echo "Compiling the code...."
                sh "mvn clean compile"
            }
        }   
        stage("Test"){
            steps {
                echo "Compiling the code.... "
                sh "mvn test"
            }
        }  
        stage("Unit Test"){
            steps {
                echo "Running the unit tests.... "
            }
        }  
        stage("Build"){
            steps {
                echo "Building the image.... "
                sh "mvn clean package"
            }
            post{
                success{
                    echo "Build Successful, archiving the artifacts....."
                    archiveArtifacts artifacts: '**/*.war', followSymlinks: false
                }
            }
        }
        stage("Create Docker image"){
            steps {
                echo "Creating the Docker image for the app..."
                sh "docker image build -t ${env.CONTAINER_REGISTRY_AND_REPOSITORY}:${env.BUILD_NUMBER} ."
            }
        }  
        stage("Scanning the image"){
            steps {
                echo "Scanning the available docker image...."
                sh "trivy image --scanners vuln --severity HIGH,CRITICAL --ignore-unfixed ${env.CONTAINER_REGISTRY_AND_REPOSITORY}:${env.BUILD_NUMBER} --format json -o report.json --exit-code 1"
            }
        }
        stage("Push the image"){
            steps {
                echo "Pushing the docker image to Dockerhub....."
                withDockerRegistry([credentialsId: 'docregcred' , url: '']){
                    sh "docker image push ${env.CONTAINER_REGISTRY_AND_REPOSITORY}:${env.BUILD_NUMBER}"
                }
            }
        }   
    }
}
