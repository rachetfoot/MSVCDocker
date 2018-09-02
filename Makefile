MSVC_VERS = 15 14 12

define build-targets
  snapshot$1: Vagrantfile
		FIRSTBOOT=1 vagrant up win-msvc$1
		vagrant halt win-msvc$1
		vagrant up --provision win-msvc$1
		vagrant halt win-msvc$1

  msvc$1: Dockerfile
		docker build -f Dockerfile -t msvc:$1 --build-arg MSVC=$1 .
endef

$(foreach element,$(MSVC_VERS),$(eval $(call build-targets,$(element))))

# Microsoft's "Microsoft/EdgeOnWindows10" vagrant cloud image is out of date, so we have to jump through hoops
# see https://github.com/MicrosoftEdge/dev.microsoftedge.com-vms/issues/22
downloadbasebox:
	wget https://az792536.vo.msecnd.net/vms/VMBuild_20180425/Vagrant/MSEdge/MSEdge.Win10.Vagrant.zip -o build/MSEdge.Win10.Vagrant.zip
	unzip build/MSEdge.Win10.Vagrant.zip

importbasebox:
	vagrant box add --force "build/MSEdge - Win10.box" --name "Microsoft/EdgeOnWindows10"
	vagrant box list

setupbasebox: downloadbasebox importbasebox
