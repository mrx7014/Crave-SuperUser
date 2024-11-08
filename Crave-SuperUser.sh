#!/bin/bash
clear
echo "Crave SuperUser"
echo ""
sleep 2
echo "Ubuntu in qmeu without any limits"
echo ""
echo "Based on Ubuntu Segfault Guide, So"
sleep 1
echo "username: root"
echo "password: segfault"
echo""
read -p "Enter Y to install all requirments, or N to stop everything (Y/N)" user_choose
if [ $user_choose == Y ]
then
echo "Install required packages and create metadata.yml file"
cd /crave-devspaces;git clone https://github.com/mrx7014/Crave-Fixer;cd Crave-Fixer;sudo mv /etc/apt/sources.list /etc/apt/sources.list.old;sudo cp /crave-devspaces/Crave-Fixer/sources.list /etc/apt; sudo apt-get update -y;sudo apt-get upgrade -y;[[ -z $URL ]] && URL="https://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-amd64.img"
IMAGE="${URL##*/}"
OS="${IMAGE%%-*}"
ARCH="${IMAGE##*-}"
ARCH="${ARCH%%.*}"
[[ $ARCH =~ ^[0-9]*$ ]] && ARCH="x86_64" # No ARCH in name
sudo apt-get install -y cloud-image-utils qemu-system
mkdir -p ~/.vm/"${OS}-${ARCH}" &>/dev/null && \
cd ~/.vm/"${OS}-${ARCH}" && \
cat >metadata.yaml <<-__EOF__
instance-id: iid-${SF_HOSTNAME:-THC}01
local-hostname: ${SF_HOSTNAME:-THC}-${OS}-${ARCH}-guest > /dev/null 2>&1
__EOF__
sleep 2
echo "Create an SSH key and configure the VM. The host's /crave-devspace directory will be shared with the VM:"
sleep 2
[[ ! -f ~/.ssh/id_ed25519 ]] && ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519
cat >user-data.yaml <<-__EOF__
#cloud-config
users:
  - name: root
    lock_passwd: false
    # OpenBSD: hashed_passwd: '$2b$06$mbQdo90rertzSkoBBeZCzePTMtdkx7cuOax8xv.1W5ta0tJiNAlMG'
    hashed_passwd: '$(echo segfault | openssl passwd -6 -stdin)'
    ssh_authorized_keys:
      - $(ssh-keygen -y -f ~/.ssh/id_ed25519)
bootcmd:
  #FreeBSD: - sed -i "" 's/#PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
  - mkdir -p /
mounts:
  - [ host0, / ]
__EOF__
# Edit this file for OpenBSD or FreeBSD
clear
sleep 2
echo "Create the seed.img file (aka cloud-init) and download and enlarge the cloud image"
sleep 2
cloud-localds seed.img user-data.yaml metadata.yaml
[[ ! -f "${IMAGE:?}" ]] && wget "${URL}"
qemu-img resize "${IMAGE}" 32G
clear
sleep 3
echo "Create bootable script"
echo "Default RAM size is 2GB, If you want to change it edit the StartVM.sh script -m 32G"
sleep 2
cd /crave-devspaces; touch StartVM.sh ; echo "cd /crave-devspaces;git clone https://github.com/mrx7014/Crave-Fixer;cd Crave-Fixer;sudo mv /etc/apt/sources.list /etc/apt/sources.list.old;sudo cp /crave-devspaces/Crave-Fixer/sources.list /etc/apt; sudo apt-get update -y;sudo apt-get upgrade -y;cd ~/.vm/ubuntu-amd64 ; qemu-system-x86_64 \
    -m 2G \
    -nographic \
    -device virtio-net-pci,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::2222-:22 \
    -drive "if=virtio,format=qcow2,file=ubuntu-22.04-server-cloudimg-amd64.img" \
    -drive "if=virtio,format=raw,file=seed.img" \
    -virtfs local,path=/,mount_tag=host0,security_model=passthrough" >> StartVM.sh ; chmod +x StartVM.sh > /dev/null 2>1&
sleep 2
echo "Everything is Done,Now use StartVM.sh to start the VM"
echo "Login info:"
echo "username: root"
echo "password: segfault"
fi
if [ $user_choose == N ]
then
clear;exit
fi
