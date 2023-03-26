--- 
- name: set up webservers
  hosts: all
Become: true
  tasks: 
    - name: ensure nginx is at the latest version
      apt:
        name: nginx
        state: latest
    - name: start nginx
      service: 
        name: nginx
        state: started
        enabled: yes  # if you want to also enable nginx

$ ansible-playbook -i inventory.cfg nginx_install.yml -b

Sudo apt auto remove nginx






Ansile basic commands



Sudo apt update
We need to create private and public key
With the commd below…you must be in ubuntu home
Pwd =/root
ubuntu@ansible:/root$


ssh-keygen -t rsa -b 4096
Ls -la
Output

total 40
drwxr-xr-x 5 ubuntu ubuntu 4096 
ubuntu@ansible:~$ cd cd .ssh

Cd .ssh
Ls
output
authorized_keys  id_rsa  id_rsa.pub
done




Esteblsh ssh connection in nodes


 Esterblish the connection
Ssh-copy-id ubuntu@node1 ip addresss
Enter ,,then exit node1

Do that for all node ip address
Next node will require -f after putting the ip address

NODE CONFIGURATION


Go to node1 to establsh ssh connection with master-ansible
Set passwd
Passwd ubuntu
Enter passwd
Retype passwd


Elevate to root
Sudo su
 Cd /etc/ssh
Ls
Output
moduli        ssh_host_dsa_key      ssh_host_ecdsa_key.pub    ssh_host_rsa_key      sshd_config
ssh_config    ssh_host_dsa_key.pub  ssh_host_ed25519_key      ssh_host_rsa_key.pub  sshd_config.d
ssh_config.d  ssh_host_ecdsa_key    ssh_host_ed25519_key.pub  ssh_import_id
root@ip-172-31-61-98:/etc/ssh#

Edit this file
vi sshd_config
Passwd authen. no
Change no to yes
Exit

Then restart sshd
systemctl restart sshd
Done

nexus nexus
         NEXUS INSTALLATION t3. Xlarge

Prerequisites
Open JDK 8
Minimum CPU’s: 4
Ubuntu Server with User sudo privileges. t3. Xlarge
Set User limits
Web Browser
Firewall/Inbound port: 22, 8081
you can go through Nexus artifactory official page to know more about system requirement for Nexus.


#update the system packages
sudo apt-get update
sudo apt install openjdk-8-jre-headless         #1: Install OpenJDK 1.8 on Ubuntu 20.04 LTS
cd /opt

Download the SonaType Nexus on Ubuntu using wget
sudo wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz

Extract the Nexus repository setup in /opt directory
sudo tar -zxvf latest-unix.tar.gz

sudo mv /opt/nexus-3.30.1-01 /opt/nexus

As security practice, not to run nexus service using root user, so lets create new user named nexus to run nexus service
sudo adduser nexus

To set no password for nexus user open the visudo file in ubuntu
sudo visudo             #this command will open nano editor
add this below and save it
nexus ALL=(ALL) NOPASSWD: ALL                 #(SAVE WITH CTRL  X, its will prompt for yes/no, type y and press enter)

Give permission to nexus files and nexus directory to nexus user
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work

To run nexus as service at boot time, open /opt/nexus/bin/nexus.rc file, uncomment it and add nexus user as shown below
sudo vi /opt/nexus/bin/nexus.rc
run_as_user="nexus"
save it

To Increase the nexus JVM heap size, open the /opt/nexus/bin/nexus.vmoptions file, you can modify the size as shown below
In the below settings, the directory is changed from ../sonatype-work to ./sonatype-work
sudo vi /opt/nexus/bin/nexus.vmoptions 
-Xms1024m
-Xmx1024m
-XX:MaxDirectMemorySize=1024m
-XX:LogFile=./sonatype-work/nexus3/log/jvm.log
-XX:-OmitStackTraceInFastThrow
-Djava.net.preferIPv4Stack=true
-Dkaraf.home=.
-Dkaraf.base=.
-Dkaraf.etc=etc/karaf
-Djava.util.logging.config.file=/etc/karaf/java.util.logging.properties
-Dkaraf.data=./sonatype-work/nexus3
-Dkaraf.log=./sonatype-work/nexus3/log
-Djava.io.tmpdir=./sonatype-work/nexus3/tmp

To run nexus as service using Systemd
sudo vi /etc/systemd/system/nexus.service

[Unit]
Description=nexus service
After=network.target
[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort
[Install]
WantedBy=multi-user.target

Save it

To start nexus service using systemctl

sudo systemctl start nexus
sudo systemctl enable nexus
sudo systemctl status nexus

if the nexus service is not started, you can the nexus logs using below command
sudo tail -f /opt/sonatype-work/nexus3/log/nexus.log











