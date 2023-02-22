#!/bin/bash

echo " The links below are valid for 7 days only..."
if [ -z "$1" ];
then
        echo "please provide s3 url to generate the link";
        echo "for example: ./aws_create_presign.sh s3://<path>/filename.tar.gz";
        echo "$0 should be fixed";

else
        LINK=$(aws s3 presign --region us-east-1 --expires-in 604800 $1);
        #echo "Download link: $LINK";
        F1=($(echo $1 | awk -F / '{print $NF}'));
        F2=$(awk '{print $5}' <<< $F1);

        echo "Run the command below to download:";
        echo -e "wget -O /tmp/$F1 ${LINK}";

fi
