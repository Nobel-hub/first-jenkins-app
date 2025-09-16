pipeline{
    agent any
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
    }
}
