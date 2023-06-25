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
                    sh 'VERSION=$(sed -n "3{s/.*\([0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/p}" Cargo.toml)'
                    sh 'FILE=./remext-$VERSION.tar.gz'
                    sh 'URL=https://gitea.flightless.dev/api/packages/flightless/generic/remext/$VERSION/remext.tar.gz'
                    sh 'cargo build --release --features home_path'
                    sh 'cp ./target/release/remext remext'
                    sh 'tar -czvf remext-$VERSION.tar.gz remext'
                    sh 'curl --user ${CREDENTIALS_USR}:${CREDENTIALS_PSW} --upload-file  $FILE $URL'
                    sh 'rm remext remext-$VERSION.tar.gz'
                }
            }
        }
    }
}