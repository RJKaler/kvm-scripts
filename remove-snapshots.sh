#!/bin/bash

vm_name="$1"

script_name="$(basename "$0")"

if [[ "$vm_name" =~ ^(-h|--h|help|Help|h)$ ]]; then
    echo "Enter a domain to remove all snapshots"
    echo "Ex): $script_name [ubuntu-server]"
    exit 0
fi


if [[ -z "$vm_name" ]]; then
    echo "Error - an arg is required"
    echo "Enter a domain"
    echo "Ex): $script_name [ubuntu-server]"
    exit 1
fi

proc() { virsh snapshot-list "$vm_name" | grep -iEv '\--|Name|^$' | awk '{ print $1 }' ; }

while IFS= read -r snap_name
do
    sudo virsh snapshot-delete "$vm_name" "$snap_name"
done < <(proc)

read -rep "Would you like to remove the host? (y|n) " ans

    if [[ "$ans" =~ ^(y|Y|yes|Yes)$ ]]; then
        sudo virsh undefine "$vm_name" --remove-all-storage || error
        echo "Successfully removed $vm_name"
        exit 0
    else
        echo "Ok - exiting script..."
        exit 0
    fi

