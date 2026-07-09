#!/bin/bash

HOSTNAME="kubernetes-1-32-4-containerd-2-0-4"

echo "127.0.0.1 $HOSTNAME" >> /etc/hosts
echo "10.0.2.16 $HOSTNAME" >> /etc/hosts
