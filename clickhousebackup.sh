#!/bin/bash
base64 -d <<<"ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIAogLC0tLS0tLiwtLS4sLS0uICAgICAgLC0tLiAgICAsLS0uICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAsLS0tLS0uICAgICAgICAgICAgICAgICwtLS4gICAgICAgICAg
ICAgICAgICAgCicgIC4tLS4vfCAgfGAtLScgLC0tLS58ICB8LC0uIHwgICwtLS0uICAsLS0tLiAs
LS0uLC0tLiAsLS0tLiAgLC0tLS4gICAgIHwgIHwpIC9fICAsLS0sLS0uICwtLS0ufCAgfCwtLiwt
LS4sLS0uICwtLS0uICAKfCAgfCAgICB8ICB8LC0tLnwgLi0tJ3wgICAgIC8gfCAgLi0uICB8fCAu
LS4gfHwgIHx8ICB8KCAgLi0nIHwgLi0uIDogICAgfCAgLi0uICBcJyAsLS4gIHx8IC4tLSd8ICAg
ICAvfCAgfHwgIHx8IC4tLiB8IAonICAnLS0nXHwgIHx8ICB8XCBgLS0ufCAgXCAgXCB8ICB8IHwg
IHwnICctJyAnJyAgJycgICcuLScgIGApXCAgIC0tLiAgICB8ICAnLS0nIC9cICctJyAgfFwgYC0t
LnwgIFwgIFwnICAnJyAgJ3wgJy0nICcgCiBgLS0tLS0nYC0tJ2AtLScgYC0tLSdgLS0nYC0tJ2At
LScgYC0tJyBgLS0tJyAgYC0tLS0nIGAtLS0tJyAgYC0tLS0nICAgIGAtLS0tLS0nICBgLS1gLS0n
IGAtLS0nYC0tJ2AtLSdgLS0tLScgfCAgfC0nICAKICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBgLS0nICAgIA=="
echo "By Tej <3" 
bold=`tput bold`
red=`tput setaf 1`
apt install inotify-tools -y

echo  "Enter your clickhouse docker container name: "
read Name
MONITORDIR1="/var/lib/clickhouse/data/"
syspathdata="/opt/$NEWFILE"
monitor() {
inotifywait -m -r -e create --format "%f" "$1" | while read NEWFILE
do
  mkdir $NEWFILE
done
}
monitor $MONITORDIR1 &
docker  cp  $Name:$MONITORDIR1 $syspathdata 




MONITORDIR2="/var/lib/clickhouse/metadata/"
syspathmeta="/opt/$NEWFILE" #Change to your desired download location path
monitor() {
inotifywait -m -r -e create --format "%f" "$1" | while read NEWFILE
do
  mkdir $NEWFILE
done
}
monitor $MONITORDIR2 &
docker  cp  $Name:$MONITORDIR2 $syspathmeta
echo -n "Do you want to restore data?(Y/n)\e[0m"
read usrinput
if [ "$usrinput" != "${usrinput#[Yy]}" ];then
  echo -n "Please specify desired restoration docker container name: "
  read dockername
  docker cp /opt/data/ $dockername:/var/lib/clickhouse/
  docker cp /opt/metadata/ $dockername:/var/lib/clickhouse/ 
  if [ $? -eq 0 ];then
    echo $bold"Data restoration started...Please wait!"
    sleep 3
    echo $bold"Executing restoration data\e[0m"
    sleep 5

    echo "\e[42m\e[1mData Restored Successfully!\e[0m"
    echo "Please wait....$dockername is restarting!!"
    docker restart $dockername
	else
    echo "${red}Data Restoration Problem Occured!\e[0m"
    exit 1
  fi
else
  echo "Data Restoration is Skipped!"
  exit 1
fi
