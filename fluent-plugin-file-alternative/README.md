# larning-fluent-plugin-file-alternative

## ログ出力
```
echo '{"source":"stdout","field2":"value2"}' >> /var/log/td-agent/message.log
echo '{"source":"stderr","field2":"value2"}' >> /var/log/td-agent/message.log
```

## ログ確認
```
ls -l /var/log/td-agent/messages/
```
