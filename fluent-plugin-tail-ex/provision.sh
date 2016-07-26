#!/bin/sh

curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh
td-agent-gem install fluent-plugin-tail-ex

tee /etc/td-agent/td-agent.conf <<-EOF
<source>
  type tail_ex
  path /var/log/**.log,/var/log/by-date/%Y/messages.%m/%Y%m%d
  tag tail_ex.*.${hostname}
  format /^(?<message>.*)$/
  pos_file /var/log/td-agent/fluentd.pos
  refresh_interval 1800
</source>
 
<match tail_ex.**>
  @type file
  path /var/log/td-agent/file.out
  append true
</match>
EOF

usermod -a -G root td-agent

/etc/init.d/td-agent start
