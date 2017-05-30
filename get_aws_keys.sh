#!/bin/bash

[ "$#" -ne 1 ] && exit -1
[ "$1" != "ec2-user" ] && exit -1

usernames=$(aws iam list-users --query "Users[*].[UserName]" --output=text)
for username in $usernames; do
    aws iam list-ssh-public-keys --user-name "$username" --query "SSHPublicKeys[?Status == 'Active'].[SSHPublicKeyId]" --output text | while read -r KeyId; do
        aws iam get-ssh-public-key --user-name "$username" --ssh-public-key-id "$KeyId" --encoding SSH --query "SSHPublicKey.SSHPublicKeyBody" --output text
    done
done
