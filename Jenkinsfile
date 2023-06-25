pipeline {
    agent {
        kubernetes {
            yamlFile 'build-pod.yaml'
            retries 2
        }
  }
    environment {
        CREDENTIALS= credentials('private-docker-credentials')
    }
    stages {
        stage('Release') {
            steps {
                container('rust'){
                    sh '''
                        VERSION=$(sed -n "3{s/.*\\([0-9]\\+\\.[0-9]\\+\\.[0-9]\\+\\).*/\\1/p}" Cargo.toml)
                        FILE=./remext-$VERSION.tar.gz
                        URL=https://gitea.flightless.dev/api/packages/flightless/generic/remext/$VERSION/remext.tar.gz
                        cargo build --release --features home_path
                        cp ./target/release/remext remext
                        tar -czvf remext-$VERSION.tar.gz remext
                        curl --user ${CREDENTIALS_USR}:${CREDENTIALS_PSW} --upload-file  $FILE $URL
                        rm remext remext-$VERSION.tar.gz
                    '''
                }
            }
        }
    }
}