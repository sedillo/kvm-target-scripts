#!/bin/sh
pidfile="/tmp/qemu_${1}.pid"
if [ ! -f "$pidfile" ]; then
	echo "PID file $pidfile does not exist"
	exit 0;
fi
pid=`cat $pidfile`
echo "PID is $pid"
pcmdl="/proc/${pid}/cmdline"
if [ -f "$pcmdl" ]; then
	isqemu=`grep qemu-system-x86_64 ${pcmdl}`
	if [ -z "$isqemu" ]; then
		echo "Removing stale pidfile: ${pidfile}"
		rm -f ${pidfile}
	else 
		echo "A valid process is running"
	fi
else 
	echo "Removing stale pidfile: ${pidfile}"
	rm -f ${pidfile}
fi
