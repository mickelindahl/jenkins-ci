#!/usr/bin/env groovy

import groovy.json.JsonOutput

/*
 * Send slack notification
 *
 *  - `status` succeeded | failed
 *
 */
def notify(String status) {

    sh 'echo slack.notify'

    def color='good';
    def slack_emoji=":sunny:"
    if (status=='failure'){

        color='danger'
        slack_emoji=":cloud:"
    }

    def committer = sh(returnStdout: true, script: 'git log -1 --pretty=%an').trim()
    def commit = sh(returnStdout: true, script: 'git log -1 --pretty=%B').trim()
    def duration = currentBuild.durationString[0..-14]

    echo "slack.notify ${committer} ${commit} ${duration}"

    def fallback = "Build ${status} - [${env.BUILD_DISPLAY_NAME}] ${duration} (${committer})"



    def attachments=[
            ["fallback": fallback,
             "fields": [
                     [
                         "title": "Build ${status}",
                         "value": "<${env.BUILD_URL} | ${commit}>",
                         "short": true
                     ],
                     [
                         "title": "Commiter",
                         "value": "${committer}",
                         "short": true
                     ],
                     [
                         "title": "Build info",
                         "value": "${env.GIT_BRANCH} - ${env.BUILD_DISPLAY_NAME}",
                         "short": true
                     ],
                     [
                         "title": "Project",
                         "value": "${env.NODE_NAME}",
                         "short": true
                     ]
             ],
             "footer": "Duration ${duration}"
            ]]

    sh "echo slack.notify before json"
    def payload = JsonOutput.toJson([ color: color,
                                      username  : env.JOB_NAME + " " + status,
                                      icon_emoji: slack_emoji,
                                      attachments:attachments
    ])

    sh 'echo Send slack msg'
    sh "curl -X POST --data-urlencode \'payload=${payload}\' ${env.SLACK_WEBHOOK_URL}"

}

return this