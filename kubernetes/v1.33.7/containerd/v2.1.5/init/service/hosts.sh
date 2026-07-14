#!/bin/bash

HOSTNAME="kubernetes-1-33-7-containerd-2-1-5"

echo "127.0.0.1 $HOSTNAME" >> /etc/hosts
echo "10.0.2.16 $HOSTNAME" >> /etc/hosts
