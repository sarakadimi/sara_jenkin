pipeline {
  agent any
  stages {
    stage('Checkout code') {
      steps {
        checkout scm
      }
    }
    stage('Build') {
      steps {
        sh 'mvn -f pom.xml "-Djacoco=report checkstyle:checkstyle install" clean install'
        archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
      }
    }
    stage('Publish Test Coverage Report and Code Analysis') {
      steps {
        jacoco()
        echo 'recordIssues(tools: [checkStyle(), junitParser(), mavenConsole()])'
      }
    }
    stage('Déploiement') {
    steps {
        sh 'rm -rf /var/www/target'
        copyArtifacts fingerprintArtifacts: true, projectName: 'petclinic-build', target: '/var/www'
        sh 'sudo service monAppli stop'
        sh 'mv /var/www/target/spring-petclinic-*.jar /var/www/target/spring-petclinic-prod.jar'
        sh 'chmod 775 /var/www/target/spring-petclinic-prod.jar'
        sh 'sudo service monAppli start'
        sh 'sleep 30'
        echo '************************  fin de déployment avec succècs  ***************************'
        echo 'Le site est disponible à l\'adresse : 192.168.33.10:8081'
        }
    }
  }
}
