FROM centos:latest

RUN rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
RUN yum update -y
RUN yum install libunwind libicu dotnet-sdk-2.1 samba-client samba-common cifs-utils -y

RUN mkdir /mnt/eshoponweb

#RUN mount.cifs //mon12VSSrv17/eShopPub /mnt/eshoponweb -o user=vmadmin,password='DaisyCotton123!',vers=2.0
#ENTRYPOINT ["dotnet /mnt/eshoponweb/Web.dll"]

CMD ["/bin/bash"]
