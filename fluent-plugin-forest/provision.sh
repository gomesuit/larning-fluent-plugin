#!/bin/sh

curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh
td-agent-gem install fluent-plugin-forest

touch /var/log/td-agent/a.log
touch /var/log/td-agent/b.log

tee /etc/td-agent/td-agent.conf <<-EOF
<source>
  type tail
  format none
  path /var/log/td-agent/a.log
  pos_file /var/log/td-agent/a.log.pos
  tag message.a
</source>

<source>
  type tail
  format none
  path /var/log/td-agent/b.log
  pos_file /var/log/td-agent/b.log.pos
  tag message.b
</source>
 
<match message.*>
  type forest
  subtype copy

  <template>
    <store>
      type stdout
    </store>
  
    <store>
      type file
      path /var/log/td-agent/messages/__TAG_PARTS[1]__.log
      time_slice_format %Y%m%d
      time_format %Y%m%dT%H%M%S%z
      flush_interval 5s
      time_slice_wait 20s
    </store>
  </template>
</match>
EOF

/etc/init.d/td-agent start
