pipeline{
    agent any
    stages {
        stage("Chekout"){
            steps {
                echo "Checking out the code...."
            }
        }   
        stage("Compile"){
            steps {
                echo "Compiling the code.... "
            }
        }  
        stage("Scan"){
            steps {
                echo "Scanning the code "
            }
        }  
        stage("Build"){
            steps {
                echo "Building the image...... "
            }
        }  
        stage("Push"){
            steps {
                sh 'echo "Pushing the image by .... $(whoami)"'
            }
        }  
    }
}
