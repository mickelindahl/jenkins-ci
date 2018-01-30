pipeline {
  agent any
  stages {
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
         sh './ci/lib/test.sh'
       }
     }
     stage('Build') {
       steps {

         sh './ci/lib/build.sh'
       }
     }
     stage('Deploy') {
       when {
            anyOf {
               branch 'master'
               branch 'test'
            }
       }
       steps {

         sshagent(credentials: ['deploy']) {
           sh '. ./ci/lib/deploy.sh'
         }
       }
     }
  }
  post {

    always {
      sshagent(credentials: ['deploy']) {

         sh 'cat ./ci/lib/always.sh'
         sh 'scp -o $o ./ci/lib/always.sh jenkins@$SITE_URL:$PATH_REMOTE_DEPLOY'
         sh 'ssh -o StrictHostKeyChecking=no -l jenkins stakesarehigh.co "cd /opt/deploy/test-ci-master; cat always.sh"'
         sh 'ssh -o $o -l $user $SITE_URL "cd $PATH_REMOTE_DEPLOY; ./always.sh"'
      }
    }
    success {
      sshagent(credentials: ['deploy']) {

         sh 'scp -o $o ./ci/lib/success.sh jenkins@$SITE_URL:$PATH_REMOTE_DEPLOY'
         sh 'ssh -o $o -l $user $SITE_URL "cd $PATH_REMOTE_DEPLOY; ./success.sh $NAME $TAG"'
      }
      script {

        def root_dir=pwd()+"/ci/lib"
        def slack = load "${root_dir}/slack.groovy"
        slack.notify("success")
      }
    }
    failure {
      sshagent(credentials: ['deploy']) {

        sh '. ./ci/lib/failure.sh'
      }
      script {

        def root_dir=pwd()+"/ci/lib"
        def slack = load "${root_dir}/slack.groovy"
        slack.notify("failure")
      }
    }
  }
}