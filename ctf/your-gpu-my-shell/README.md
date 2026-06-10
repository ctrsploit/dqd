# A CTF Challenge: your gpu my shell

| Type | Image | Notes |
| ---- | ----- | ----- |
| dqd | ghcr.io/ctrsploit/your-gpu-my-shell:latest | points to `v0.1.1` |
| dqd | ghcr.io/ctrsploit/your-gpu-my-shell:v0.1.1 | migrate from docker_archive |
| dqd | ssst0n3/docker_archive:your-gpu-my-shell_v0.1.0 | - |
| ctr | ghcr.io/ctrsploit/your-gpu-my-shell:ctr_v0.1.1 | - |
| ctr | ssst0n3/docker_archive:ctr_your-gpu-my-shell_v0.1.0 | - |

## usage

### Start and connect

Recommended:

```shell
$ dqd up ctf/your-gpu-my-shell
$ ssh dqd-your-gpu-my-shell
```

Fallback without dqd CLI or SSH config:

```shell
$ cd ctf/your-gpu-my-shell
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

### Without kvm

```shell
$ cd ctf/your-gpu-my-shell
$ docker compose -f docker-compose.yml up -d
```

## writeup

// TODO: You could upload your writeup here.

## challenge description

Welcome to our state-of-the-art GPU-accelerated computing service! We provide a secure, containerized environment for you to run any Docker image of your choice.

Your task is simple:
1. Connect to the service.
2. Solve the initial Proof-of-Work challenge.
3. Specify a Docker image to run.
4. Escape from the container and capture the flag.

You will be granted shell access inside a container with direct access to the host's NVIDIA GPU devices. We are confident that our sandbox is inescapable.

The flag is located on the host system at `/flag`. Can you break out and capture it?

```shell
$ nc 127.0.0.1 25878
Welcome! The connection will be terminated after 5m0s.
sha256(xxxx+XHI4LinTgU82NYwK) == 574fd80d91b02fe083a9def8a74e81170b02e6330f5437cb8732d096f269e8d0
Give me xxxx:
M13Y                                                            
Proof of Work successful!
Please enter the Docker image to run (e.g., busybox:latest): busybox:latest
Pulling image busybox:latest... This may take a moment.
{"status":"Pulling from library/busybox","id":"latest"}
{"status":"Pulling fs layer","progressDetail":{},"id":"b05093807bb0"}
{"status":"Downloading","progressDetail":{"current":32106,"total":2226327},"progress":"[\u003e                                                  ]  32.11kB/2.226MB","id":"b05093807bb0"}
{"status":"Downloading","progressDetail":{"current":1375594,"total":2226327},"progress":"[==============================\u003e                    ]  1.376MB/2.226MB","id":"b05093807bb0"}
{"status":"Downloading","progressDetail":{"current":2226327,"total":2226327},"progress":"[==================================================\u003e]  2.226MB/2.226MB","id":"b05093807bb0"}
{"status":"Download complete","progressDetail":{},"id":"b05093807bb0"}
{"status":"Extracting","progressDetail":{"current":32768,"total":2226327},"progress":"[\u003e                                                  ]  32.77kB/2.226MB","id":"b05093807bb0"}
{"status":"Extracting","progressDetail":{"current":262144,"total":2226327},"progress":"[=====\u003e                                             ]  262.1kB/2.226MB","id":"b05093807bb0"}
{"status":"Extracting","progressDetail":{"current":2226327,"total":2226327},"progress":"[==================================================\u003e]  2.226MB/2.226MB","id":"b05093807bb0"}
{"status":"Extracting","progressDetail":{"current":2226327,"total":2226327},"progress":"[==================================================\u003e]  2.226MB/2.226MB","id":"b05093807bb0"}
{"status":"Pull complete","progressDetail":{},"id":"b05093807bb0"}
{"status":"Digest: sha256:fd8d9aa63ba2f0982b5304e1ee8d3b90a210bc1ffb5314d980eb6962f1a9715d"}
{"status":"Status: Downloaded newer image for busybox:latest"}
Image pull complete.
Creating container with GPU support...
--- Connected to container terminal (with GPU support) ---
You can now type commands. The session will end after 5 minutes or when you exit the shell.
Try running 'ls -lah /dev/nvidia*' to verify GPU access.
/ # ls -lah /dev/nvidia*
ls -lah /dev/nvidia*
crw-rw-rw-    1 root     root      195,   0 Jun 10 07:10 /dev/nvidia0
crw-rw-rw-    1 root     root      195,   1 Jun 10 07:10 /dev/nvidia1
crw-rw-rw-    1 root     root      195,   2 Jun 10 07:10 /dev/nvidia2
crw-rw-rw-    1 root     root      195,   3 Jun 10 07:10 /dev/nvidia3
crw-rw-rw-    1 root     root      195, 255 Jun 10 07:10 /dev/nvidiactl
```

## versions

```shell
root@your-gpu-my-shell:~# nvidia-container-toolkit --version
NVIDIA Container Runtime Hook version 1.17.6
commit: e627eb2e21e167988e04c0579a1c941c1e263ff6
root@your-gpu-my-shell:~# docker --version
Docker version 28.1.1, build 4eba377
root@your-gpu-my-shell:~# containerd --version
containerd containerd.io 1.7.27 05044ec0a9a75232cad458027ca83437aae3f4da
root@your-gpu-my-shell:~# cat /etc/os-release
PRETTY_NAME="Ubuntu 24.04.4 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.4 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo
root@your-gpu-my-shell:~# uname -a
Linux your-gpu-my-shell 6.8.0-71-generic #71-Ubuntu SMP PREEMPT_DYNAMIC Tue Jul 22 16:52:38 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=ctf/your-gpu-my-shell
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/your-gpu-my-shell:ctr_v0.1.1
```
