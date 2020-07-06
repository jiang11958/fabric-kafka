#!/bin/bash
DIRNAME=$0
if [ "${DIRNAME:0:1}" = "/" ];then
    CURDIR=`dirname $DIRNAME`
else
    CURDIR="`pwd`"/"`dirname $DIRNAME`"
fi
echo $CURDIR

export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_INVENTORY="ansible/inventory/hosts"

function startNetWork(){
	
	echo "# start network"
	ansible-playbook $CURDIR/ansible/start.yaml  
	
}

function stopNetWork(){
	
	echo "# stop network"
	ansible-playbook $CURDIR/ansible/stop.yaml 
	
}

#Print the usage message
function printHelp () {
  echo "Usage: "
  echo "   sh run.sh start|stop "
}

if [ $# -ne 1 ];
then
	printHelp
	exit
fi

if [ $1 == "start" ] ; then	
	startNetWork
elif [ $1 == "stop" ] ; then
	stopNetWork
else 
	printHelp
fi


