#!/bin/bash

docker pull nodered/node-red;

docker run -d --name=nodered --net=host --privileged --restart=always -it -p 1880:1880 -v /etc/localtime:/etc/localtime:ro -v /opt/hassio/nodered:/data nodered/node-red;

sleep 2

chmod -R 777 /opt/hassio/nodered

docker exec nodered /bin/bash -c "npm install node-red-contrib-home-assistant-websocket;npm install node-red-contrib-modbus;npm install node-red-dashboard;";

docker restart nodered;
