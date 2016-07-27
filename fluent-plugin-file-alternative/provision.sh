#!/bin/sh

curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh
td-agent-gem install fluent-plugin-file-alternative

touch /var/log/td-agent/message.log

tee /etc/td-agent/td-agent.conf <<-EOF
<source>
  type tail
  format none
  path /var/log/td-agent/message.log
  pos_file /var/log/td-agent/message.log.pos
  tag message.a
</source>

<match *.*>
  type rewrite_tag_filter
  rewriterule1 source stderr error.__TAG_PARTS[1]__
</match>

<match message.*>
  type copy

  <store>
    type stdout
  </store>

  <store>
    type file
    path /var/log/td-agent/messages/message.log
    time_slice_format %Y%m%d
    time_format %Y%m%dT%H%M%S%z
    flush_interval 5s
    time_slice_wait 20s
  </store>
</match>

<match error.*>
  type copy

  <store>
    type stdout
  </store>

  <store>
    type file
    path /var/log/td-agent/messages/error.log
    time_slice_format %Y%m%d
    time_format %Y%m%dT%H%M%S%z
    flush_interval 5s
    time_slice_wait 20s
  </store>
</match>
EOF

/etc/init.d/td-agent start

