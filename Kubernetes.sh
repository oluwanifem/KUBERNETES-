#!/bin/bash



#OWNER = OLUWANIFEMI 



#INSTALL LATION OF KUBERNETES ON UBUNTU LINUX INSTANCES
#REQUIREMENTS 


#This script will only run succefully on a machine with at least 2CPU and 2GB RAM
#Ignore the requirement for the worker node

#set hostname
sudo hostnamectl set-hostname "master"



#UPDATE THE SERVER
sudo apt-get update

#Get dockegpg key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#Add docker repository 
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
  stable"





#Install docker package on machine
sudo apt-get install -y docker.io




#Add ubuntu to docker group
sudo usermod -aG docker ubuntu


#Ask to continue


#Install requires packages
sudo apt-get install -y apt-transport-https ca-certificates curl





#Download the Google Cloud public signing key:
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -


#Add the Kubernetes apt repository:
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF



#Update apt package index with the new repository and install kubectl:
sudo apt-get update
sudo apt-get install docker-ce
sudo apt-get install kubelet=1.15.7-00 kubeadm=1.15.7-00 kubectl=1.15.7-00

clear
echo
echo
echo
echo THE FOLLOWING COMMANDS ARE FOR THE MASTER LOAD ONLY WILL YOU LIKE TO CONTINUE Y/N?
read ans

if [ $ans = y ] || [ $ans = Y ] || [ $ans = yes ]
        then
clear
echo CREATING A CLUSTER AND GENERATING A TOKEN FOR THE CLUSTER.........
sleep 5
echo 
echo
echo
echo What is the PRIVATE! IP Address of this machine [Master Node]
read ip

sudo kubeadm init --apiserver-advertise-address=$ip --pod-network-cidr=192.168.0.0/16
echo
echo
echo
echo !!!!!!PLEASE COPY THE KUBEADM JOIN COMMAND ABOVE AND PASTE IT IN EACH WORKER NODE!!!!!!
echo !!!!!!DO YOU WANT TO CONTINUE Y/N?!!!!!
read ans
if [ $ans = y ] || [ $ans = Y ] || [ $ans = yes ]
        then

echo '
#!/bin/bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config '  > config.sh

chmod 777 config.sh
./config.sh

elif [ $ans = n ] || [ $ans = N ] || [ $ans = no ]
                then
                echo
                echo Thanks Have a great Day!!
		exit
else
                echo Invalid character try again
		exit


fi




elif [ $ans = n ] || [ $ans = N ] || [ $ans = no ]
                then
		echo
                echo Thanks Have a great Day!!
		exit
else
                echo Invalid character try again
		exit
fi
~   

echo
echo
echo
echo !!!!APPLYING SOME CONFIGURATION!!!!!
sleep 5
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml







