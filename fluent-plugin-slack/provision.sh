#!/bin/sh

curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh
td-agent-gem install fluent-plugin-slack

touch /var/log/td-agent/a.log

tee /etc/td-agent/td-agent.conf <<-EOF
<source>
  type tail
  format none
  path /var/log/td-agent/a.log
  pos_file /var/log/td-agent/a.log.pos
  tag message.a
</source>
 
<match message.*>
  type copy

  <store>
    type stdout
  </store>

  <store>
    @type slack
    webhook_url https://hooks.slack.com/services/XXX/XXX/XXX
    channel general
    username sowasowa
    icon_emoji :ghost:
    flush_interval 60s
  </store>
</match>
EOF

#/etc/init.d/td-agent start

