#!/bin/bash


remove_vm () {
  echo "Stopping and removing previous VM $1"
  sudo virsh shutdown $1
  sleep 5
  sudo virsh destroy $1
  sleep 5
  sudo virsh undefine $1
  sleep 5
  echo "removing storage file: /mnt/Storage-1/EH-ctl-Storage/$1-Storage-disk.qcow2"
  sudo rm /mnt/Storage-1/EH-ctl-Storage/$1-Storage-disk.qcow2
  
}

validate_user_input () {

    _VM=$(sudo virsh list --all | grep $1 | awk '{ print $2}')
    if [ -z $_VM ]; then
      echo "No VM found...exiting"
      echo "============================="
      sudo virsh list --all
      exit
    
    else

       echo -e "We will delete VM: $1, are you shure [y/n]? ";
       read user_input

       if [[ $user_input == "y" || $user_input == "Y" ]]
       then 
         remove_vm $1;
         sleep 2
         echo "Done..."
       else
         echo "input is not valide"
         exit
       fi
    fi


}


main () {
  if [ -z "$1" ];
  then
    echo "Please provide VM name to delete";
    sudo virsh list --all
    exit 0;
  else
    validate_user_input $1
  fi
}


_VM_NAME=$1
_ISO_IMG=controller-2022.11.1.1875.iso
main $_VM_NAME

