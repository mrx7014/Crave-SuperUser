<div align="center">

# Crave SuperUser

### Ubuntu in qmeu without any limits, You can use any other distro too

### Based On Ubuntu Segfault https://github.com/mrx7014/Ubuntu_on_Segfault

</div>

>[!NOTE]
> if you don't know what's crave check this https://crave.io
>

<hr />

# Let's GOOOOOO !

- First open your Crave server and update it

```sh
sudo apt-get update -y ; sudo apt-get upgrade -y
```

- After this you should use `tmate`, because when you use it you will be able to use **Ubuntu SuperUser** and **Default Ubuntu** at the same time.

- To use it just type `tmate` in terminal and copy `ssh session` to connect to server by it again.

<hr />

- This is some tricks to use tmate and create two tabs

- To create a new tab of tmate use this --> **ctrl + b + c**
- To move between tabs use this --> **ctrl + b + "number of tab"**
> you will see a number of tab at bottom in the green line
>

<hr />

# Intallation Guide:

- If you don't want to configure everything by yourself use this script (Read all the README file too):
```sh
git clone https://github.com/mrx7014/Crave-SuperUser;cd Crave-SuperUser;chmod +x Crave-SuperUser.sh;./Crave-SuperUser.sh
```
<br />

# IF you want to configure everything by yourself follow this guide.

- Create some configurations and install some packages:
```sh
cd /crave-devspaces;git clone https://github.com/mrx7014/Crave-Fixer;cd Crave-Fixer;sudo mv /etc/apt/sources.list /etc/apt/sources.list.old;sudo cp /crave-devspaces/Crave-Fixer/sources.list /etc/apt;sudo apt-get update -y;sudo apt-get upgrade -y;[[ -z $URL ]] && URL="https://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-amd64.img"
IMAGE="${URL##*/}"
OS="${IMAGE%%-*}"
ARCH="${IMAGE##*-}"
ARCH="${ARCH%%.*}"
[[ $ARCH =~ ^[0-9]*$ ]] && ARCH="x86_64" # No ARCH in name
apt-get install -y cloud-image-utils qemu-system
mkdir -p ~/.vm/"${OS}-${ARCH}" &>/dev/null && \
cd ~/.vm/"${OS}-${ARCH}" && \
cat >metadata.yaml <<-__EOF__
instance-id: iid-${SF_HOSTNAME:-THC}01
local-hostname: ${SF_HOSTNAME:-THC}-${OS}-${ARCH}-guest
__EOF__

```

- Create an SSH key and configure the VM. The host's `/crave-devspaces` directory will be shared with the VM:
```sh
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

```

- Create the `seed.img` file (aka cloud-init) and download and enlarge the cloud image:
```sh
cloud-localds seed.img user-data.yaml metadata.yaml
[[ ! -f "${IMAGE:?}" ]] && wget "${URL}"
qemu-img resize "${IMAGE}" 32G
```
- Create bootable script
```sh
cd crave-devspaces; touch StartVM.sh ; echo "cd /crave-devspaces;git clone https://github.com/mrx7014/Crave-Fixer;cd Crave-Fixer;sudo mv /etc/apt/sources.list /etc/apt/sources.list.old;sudo cp /crave-devspaces/Crave-Fixer/sources.list /etc/apt; sudo apt-get update -y;sudo apt-get upgrade -y;cd ~/.vm/ubuntu-amd64 ; qemu-system-x86_64 \
    -m 2G \
    -nographic \
    -device virtio-net-pci,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::2222-:22 \
    -drive "if=virtio,format=qcow2,file=ubuntu-22.04-server-cloudimg-amd64.img" \
    -drive "if=virtio,format=raw,file=seed.img" \
    -virtfs local,path=/,mount_tag=host0,security_model=passthrough" >> StartVM.sh ; chmod +x StartVM.sh
```
```diff
- Note: Tag -m pointing to size of server memorey,if you have 2 GB RAM "at a usual of server keep it,And if you have more than 2GB of RAM change the number "2" to what you want
```
- Now you can start a server by:
```sh
./StartVM.sh
```
*it will take sometime at first boot,Don't worry*

- If server freeze on `[  OK  ] Started Snap Daemon.` while booting just press `Enter`
- To stop server use `halt`, if not working stop the session form  `foss.crave.io` dashboard

<br />

- Now after it booting and ask you about user name and password type this:

- Username : `root`
- Password : `segfault`

- Now server is started.

<hr />

# Now let's setup server.

- Now we will update and setup server for everything.

- Just enter this command into the server
```sh
sudo apt update;git clone https://github.com/Crave-SuperUser;cd Crave-SuperUser;chmod +x setupserver.sh;./setupserver.sh
```
- Now everything is good

### Credits:
- <a href="https://crave.io">Crave</a>
- <a href="github.com/mrx7014">MRX7014</a>
