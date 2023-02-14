#!/bin/bash


get_iso_name () {
  echo -e "Enter iso name:\n [default value: $1]\n"
  read iso_name
  if [ -z $iso_name ]
    then
      echo "iso was set to $1"
      iso_name=$1
    else
      echo "iso was set to $iso_name"
  fi

}

remove_vm () {
  echo "Stopping and removing previous VM $1"
  VM=$(sudo virsh list --all |grep $1|awk {'print $2'})

  if [[ -z $VM ]] 
    then
      echo "$1 was not found..."
    else
      sudo virsh shutdown $1
      sleep 5
      sudo virst destroy $1
      sleep 5
      sudo virsh undefine $1
      sleep 5
      sudo rm -f /mnt/Storage-1/EH-ctl-Storage/$1-Storage-disk.qcow2
  fi 
}

create_vm () {
  echo "Creating Disk for VM"

  qemu-img create -f qcow2 \
                -o size=80G \
		/mnt/Storage-1/EH-ctl-Storage/$1-Storage-disk.qcow2

  echo "Done..."
  echo "Disk Info"

  qemu-img info /mnt/Storage-1/EH-ctl-Storage/$1-Storage-disk.qcow2

  echo "creating VM...Name=$1"

  sudo virt-install \
    --name $1 \
    --description "$1 EH Controller" \
    --ram=16384 \
    --vcpus=4 \
    --os-type=Linux \
    --os-variant ubuntu20.04 \
    --disk path="/mnt/Storage-1/EH-ctl-Storage/$1-Storage-disk.qcow2",size=80 \
    --cdrom /home/rdadmin/work/iso/$2 \
    --network type=direct,source=em1,target=macvtap3 \
    --console pty,target_type=serial  

  sudo virsh list

  echo "VM created..."
  echo "Login to the VM console with: sudo virsh console $1 "
  echo " "
}

main () {
  if [ -z "$1" ];
  then
    echo "Please provide VM name";
    exit 0;
  else
    echo "VM name is set to: $1";
    remove_vm $1;
    sleep 2
    get_iso_name $2
    create_vm $1 $iso_name;
  fi
}


_VM_NAME=$1
_ISO_IMG=controller-2022.12.0.1916.iso

main $_VM_NAME $_ISO_IMG

echo "Done"
