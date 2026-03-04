# ubuntu 24.04

* dqd: 
	* ghcr.io/ctrsploit/ubuntu-24.04:latest -> ghcr.io/ctrsploit/ubuntu-24.04:v0.4.0
	* ghcr.io/ctrsploit/ubuntu-24.04:v0.4.0
	* ssst0n3/docker_archive:ubuntu-24.04_v0.3.0
	* ssst0n3/docker_archive:ubuntu-24.04_v0.2.0
	* ssst0n3/docker_archive:ubuntu-24.04_v0.1.0
* ctr: 
	* ghcr.io/ctrsploit/ubuntu-24.04:ctr_v0.4.0: migrate to dqd project
	* ssst0n3/docker_archive:ctr_ubuntu-24.04_v0.3.0: install built-in ssh key
	* ssst0n3/docker_archive:ctr_ubuntu-24.04_v0.2.0: installed common packages; squash
	* ssst0n3/docker_archive:ctr_ubuntu-24.04_v0.1.0

## usage

```shell
$ cd ubuntu/24.04
$ docker compose -f docker-compose.yml -f docker-compose.kvm.yml up -d
$ ./ssh
```

```shell
root@ubuntu24-04:~# cat /etc/os-release
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
root@ubuntu24-04:~# uname -a
Linux ubuntu24-04 6.8.0-101-generic #101-Ubuntu SMP PREEMPT_DYNAMIC Mon Feb  9 10:15:05 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

## build

```shell
make all ENV=ubuntu/24.04
```

for developers:

```dockerfile
FROM ghcr.io/ctrsploit/ubuntu-24.04:ctr_v0.4.0
```