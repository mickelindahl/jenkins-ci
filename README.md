# Jenkins CI

## Usage

**OBS Make sure tha shell in jenkins is /bin/bahs!**
*This apllies since sh is the standard shell in jenkins. You can change the stardar shell under Manage Jenins -> Configure system -> Shell -> Shell executable*. Otherwise will the shell script fails 
because they have bourne shell syntax that sh shell can not handel

Go to project source an run

git submodule add  https://github.com/mickelindahl/jenkins-ci

the cd into jenkins-ci and set remote got git
git remote set-url origin git@github.com:mickelindahl/jenkins-ci.git

This is so jenkins will be able to fetch submodule via https

Merge `jenkins-ci/example.sample.docker-compose.yml` with or your `sample.docker-compose.yml` 
or copy it to your project to have it as a start for creating `sample.docker-compose.yml`

Copy `jekins-ci/sample.credentials.groovy` to `credentials.groovy` 
and `credentials.groovy`to your .gitignore file"

### Enable publish with ssh-agent

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

Step 3, configure Jenkins OBS it is contetn of id_rsa not id_rsa.pub now

* In the jenkins web control panel, nagivate to "Credentials" -> "System" -> "Global credentials (unrestricted) -> Add credentials" -> "SSH username with private key"
* Enter username
* Add private key
* Enter ID, this will be used with the plugin as
   sshagent(credentials: ['{ID}']) {...}

* save


### Add secret file with credentials

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

Go into the directory and run git add ., git commit -am "" and git push as usally

