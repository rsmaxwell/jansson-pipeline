pipeline {
  agent {
    kubernetes {
      yamlFile 'KubernetesPod.yaml'
    }
  }
  stages {

    stage('prepare') {
      steps {
        container('tools') {
          dir('project') {
            echo 'preparing the application'
            checkout([
              $class: 'GitSCM', 
              branches: [[name: '*/master']], 
              extensions: [], 
              userRemoteConfigs: [[url: 'https://github.com/akheron/jansson.git']]
            ])
            sh('../scripts/prepare.sh')
          }
        }
      }
    }

    stage('build') {
      steps {
        container('tools') {
          dir('project') {
            echo 'building the application'
            sh('../scripts/build.sh')

            echo 'testing the application'
            sh('../scripts/test.sh')
          }
        }
      }
    }

    stage('deploy') {
      steps {
        container('maven') {
          dir('project') {
            echo 'packaging the application'
            sh('../scripts/package.sh')

            echo 'deploying the application'
            sh('../scripts/deploy.sh')
          }
        }
      }
    }
  }
}
