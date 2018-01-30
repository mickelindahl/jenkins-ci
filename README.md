# Jenkins CI

## Use

git submodule add https://github.com/mickelindahl/jenkins-ci

Merge `jenkins-ci/example.sample.docker-compose.yml` with or your `sample.docker-compose.yml` 
or copy it to your project to have it as a start for creating `sample.docker-compose.yml`


Copy `jekins-ci/sample.credentials.groovy` to `credentials.groovy` 
and `credentials.groovy`to your .gitignore file"

**Make sure you can access deploy machine over ssh**

Step 0, setup jenkins user and deploy directory on to your deploy machine

Run `sudo adduser jenkins && sudo passwd jenkins`

Then create a directory for deploy root. Set jenkins as owner of this 
directory and add path to `PATH_REMOTE_DEPLOY` in `credentials.txt`

Enable docker for user jenkins
`sudo usermod -aG docker jenkins`

Step 1, generate public and private key on build server as user jenkins

Run `cat .ssh/id_rsa.pub`

Step 2, create `authorized_keys` in `.ssh/` paste the pub file contents. Then make sure  
`authorized_keys` has permission 644 and `.ssh/` has 700

Step 3, configure Jenkins
OBS it is contetn of id_rsa not id_rsa.pub now
* In the jenkins web control panel, nagivate to "Manage Jenkins" -> "Configure System" -> "Publish over SSH"
* Either enter the path of the file e.g. "var/lib/jenkins/.ssh/id_rsa", or paste in the same content as on the target server.
* Enter your passphrase, server and user details, and you are good to go!

Edit `credentials.groovy`.

Variables `COMPOSE_VARS_TEST` and `COMPOSE_VARS_BUILD` can be extended with variables.
These variables then also need to be added in `credentials.groovy` on a separate line.
Finally one have to make sure that the variable exists in sample.docker-compose.yml

E.g. if `env.COMPOSE_VARS_TEST="DUMMY` then `credentials.groovy` need to contain
`var.DUMMY="nada"` and sample.docker-compos.yml need to container `{DUMMY}`
which will be replaces with the string `nada`.

Upload `credentials.groovy` to jenkins as secret file. Remember the secret file `ID`.

Run `./jenkins-ci/scripts/create-jenkinsfile.sh` and enter secret file `ID`

Done!


## How to commit and push to submodule
