#!/bin/bash
DIRNAME=$0
if [ "${DIRNAME:0:1}" = "/" ];then
    CURDIR=`dirname $DIRNAME`
else
    CURDIR="`pwd`"/"`dirname $DIRNAME`"
fi
echo $CURDIR

export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_INVENTORY="${CURDIR}/ansible/inventory/hosts"

function setInventoryHosts(){
	echo "# setInventoryHosts"
	echo $1
	ansible-playbook $CURDIR/ansible/set_inventory.yaml  -e $1
}

function startNetWork(){
	
	echo "# start network"
	ansible-playbook $CURDIR/ansible/start.yaml  -e $1
	
}

function stopNetWork(){
	
	echo "# stop network"
	ansible-playbook $CURDIR/ansible/stop.yaml 
	
}

#Print the usage message
function printHelp () {
  echo "Usage: "
  echo "   sh run.sh start HOSTS_JSON |stop "
}

if [ $# -lt 1 ];
then
	printHelp
	exit
fi

if [ ! -f $ANSIBLE_INVENTORY ];then
	setInventoryHosts $2
fi

if [ $1 == "start" ] ; then	
	startNetWork $2
elif [ $1 == "stop" ] ; then
	stopNetWork
else 
	printHelp
fi


