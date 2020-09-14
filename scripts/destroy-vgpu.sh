#!/bin/bash
envconfig="/var/vm/scripts/env.sh"
if [[ $EUID -ne 0 ]]; then
        echo "This script must be run by superuser."
        exit 1
fi

if [ -f $envconfig ]; then
        source $envconfig
else
        echo "Could not find necessary environment setting."
        exit 1
fi

unblock_script="/var/vm/scripts/unblock_update.sh"
if [ -f $unblock_script ]; then
        $unblock_script
fi


# iterate through vgpu uuid and create uuid
for uuid in $VGPU
do
        if [ -f "${BASEVGPU}/${uuid}/remove" ]; then
                /bin/sh -c "echo 1 > ${BASEVGPU}/${uuid}/remove"
        else
                echo "VGPU ${uuid} does not exist."
        fi
done
