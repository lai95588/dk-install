#!/bin/bash

docker pull koenkk/zigbee2mqtt;

docker run -d -p 8099:8099 --restart=always --name=z2m --network host -it -v /etc/localtime:/etc/localtime:ro -v /home/hassio/z2m:/app/data --device=/dev/z-cc2652p koenkk/zigbee2mqtt;

sleep 2

docker stop z2m;

mv /home/hassio/z2m/configuration.yaml /opt/hassio/z2m/configuration.yaml.bak;

cat >> /home/hassio/z2m/configuration.yaml <<'EOF'
# Home Assistant integration (MQTT discovery)
homeassistant:
  enabled: true
  discovery_topic: hass-zigbee   #发现前端
  status_topic: csxm/status     #出生消息
permit_join: false
mqtt:
  base_topic: z2m
  server: mqtt://localhost:1883
  user: pi
  password: raspberry
serial:
  port: /dev/z-cc2652p
  adapter: zstack       #强制启动适配器
advanced:
  log_level: error
  channel: 11
  pan_id: 6760
  ext_pan_id:
    - 243
    - 61
    - 196
    - 228
    - 210
    - 200
    - 195
    - 139
  network_key:
    - 1
    - 8
    - 8
    - 7
    - 8
    - 11
    - 13
    - 15
    - 0
    - 2
    - 4
    - 6
    - 8
    - 10
    - 12
    - 13
  homeassistant_legacy_entity_attributes: false
  legacy_api: false
  legacy_availability_payload: false
frontend:
  port: 8099
EOF

docker restart z2m
