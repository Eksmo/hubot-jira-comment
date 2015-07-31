# Description:
#   Forward Jira comments to Slack.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_JIRA_URL
#
# Commands:
#   None
#
# Author:
#   mnpk <mnncat@gmail.com>

module.exports = (robot) ->
  robot.router.post '/hubot/chat-jira-comment/:room', (req, res) ->
    room = req.params.room
    body = req.body
    if body.webhookEvent == 'jira:issue_updated' && body.comment
      comment = body.comment
      issue = "#{body.issue.key} #{body.issue.fields.summary}"
      url = "#{process.env.HUBOT_JIRA_URL}/browse/#{body.issue.key}"
      text = body.comment.body
      attachment =
         fallback: issue
         color: "#3572b0"
         author_name: comment.author.displayName || comment.author.name
         author_icon: comment.author.avatarUrls["16x16"]
         title: issue
         title_link: url
         text: comment.body
      data =
         channel: room
         username: "jira"
         icon_emoji: ":jira:"
         attachments: [attachment]
      robot.adapter.customMessage data
    res.send 'OK'
