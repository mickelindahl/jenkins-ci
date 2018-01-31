pipeline {
  agent any
  stages {
     stage('Git submodule') {
       steps {

         sh "git submodule init && git submodule update"
       }
     }
     stage('Environment') {
       steps {
         script {
           env.SECRET_FILE_ID="{secret-file-id}"
         }
         withCredentials(bindings: [file(credentialsId: env.SECRET_FILE_ID, variable: 'FILE_CREDENTIALS')]) {
           load "$FILE_CREDENTIALS"
           script {

               env.NAME = env.APP_NAME+"-"+env.BRANCH_NAME
               env.SITE_URL = env.BRANCH_NAME=='master' ? env.SITE_URL_MASTER : env.SITE_URL_TEST
               env.TAG = env.BUILD_ID
               env.o="StrictHostKeyChecking=no"
               env.user="jenkins"
               env.PATH_REMOTE_DEPLOY=env.PATH_REMOTE_DEPLOY+"/"+env.JOB_NAME.replaceAll('/','-')
           }
         }
       }
     }
     stage('Test') {
       steps {
         sh './jenkins-ci/lib/test.sh'
       }
     }
     stage('Build') {
       when {
         anyOf {
           branch 'master'
           branch 'test'
           branch 'develop'
         }
       }
       steps {

         sh './jenkins-ci/lib/build.sh'
       }
     }
     stage('Deploy') {
       when {
         anyOf {
           branch 'master'
           branch 'test'
           branch 'develop'
         }
       }
       steps {

         sshagent(credentials: ['deploy']) {
           sh '. ./jenkins-ci/lib/deploy.sh'
         }
       }
     }
  }
  post {

    always {
      sshagent(credentials: ['deploy']) {

         sh 'ssh -o StrictHostKeyChecking=no -l jenkins stakesarehigh.co mkdir -p $PATH_REMOTE_DEPLOY/'
         sh 'scp -o $o ./jenkins-ci/lib/always.sh jenkins@$SITE_URL:$PATH_REMOTE_DEPLOY/'
         sh 'ssh -o $o -l $user $SITE_URL "cd $PATH_REMOTE_DEPLOY; ./always.sh"'
      }
    }
    success {
      sshagent(credentials: ['deploy']) {

         sh 'scp -o $o ./jenkins-ci/lib/success.sh jenkins@$SITE_URL:$PATH_REMOTE_DEPLOY'
         sh 'ssh -o $o -l $user $SITE_URL "cd $PATH_REMOTE_DEPLOY; ./success.sh $NAME $TAG"'
      }
      script {

        def root_dir=pwd()+"/jenkins-ci/lib"
        def slack = load "${root_dir}/slack.groovy"
        slack.notify("success")
      }
    }
    failure {
      sshagent(credentials: ['deploy']) {

        sh '. ./jenkins-ci/lib/failure.sh'
      }
      script {

        def root_dir=pwd()+"/jenkins-ci/lib"
        def slack = load "${root_dir}/slack.groovy"
        slack.notify("failure")
      }
    }
  }
}