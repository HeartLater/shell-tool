#!/bin/sh
# netstat -nlt | grep 1111 |wc -l

function waitfun(){
    i=0
    bar=''
    index=0
    arr=( "|" "/" "-" "\\" )
    while [ $i -le 100 ]
    do
        let index=index%4
        printf "[%-100s][%d%%][\e[43;46;1m%c\e[0m]\r" "$bar" "$i" "${arr[$index]}"
        let i++
        let index++
        usleep 30000
        bar+='#'
    done
    printf "\n"
}
ps aux | grep servicemonitor | grep -v grep > /dev/null
if [ $? -ne 0 ]; then
    nohup java -jar servicemonitor-1.0.0-SNAPSHOT.jar --spring.config.location=application.properties >/dev/null 2>&1 &
    echo "servicemonitor is started successfully"
else
    echo "servicemonitor is already running!,it will be restart!"
    echo "servicemonitor is stoped"
    ps -ef | grep servicemonitor | grep -v grep | awk '{print $2}' | xargs kill -9
    echo "stop......"
    waitfun
    echo "start......"
    nohup java -jar servicemonitor-1.0.0-SNAPSHOT.jar --spring.config.location=application.properties >/dev/null 2>&1 &
    waitfun
    echo "servicemonitor is restarted successfully"
fi
