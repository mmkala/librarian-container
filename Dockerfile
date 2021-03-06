FROM bitnami/minideb:jessie 

#set the working directory to where the librarian files will be stored 
WORKDIR /librarian_image

#set up the proxy information in apt.conf and etc/environment 
RUN echo "http_proxy=http://web-proxy.corp.hpecorp.net:8080/\nhttps_proxy=http://web-proxy.corp.hpecorp.net:8080/\nftp_proxy=http://web-proxy.corp.hpecorp.net:8080/" >> /etc/environment
RUN echo "Acquire::http::proxy \"http://web-proxy.corp.hp.com:8080\"; Acquire::https::proxy \"http://web-proxy.corp.hp.com:8080\"; Acquire::ftp::proxy \"http://web-proxy.corp.hp.com:8080\";" >> /etc/apt/apt.conf

#set build time proxy variables if you need to use the HPE proxy
ARG HTTP_PROXY=http://web-proxy.corp.hpecorp.net:8080
ARG HTTPS_PROXY=http://web-proxy.corp.hpecorp.net:8080


#expose ports for TCP and communication
EXPOSE 9093

#install git and any other packages needed, always use the -qy option
RUN apt-get update
RUN apt-get -qy install git 
RUN apt-get -qy install python3

#Add the book_data/book_register/librarian automatic script to the workdir
ADD script.sh /librarian_image


#pull the librarian from the FAME repo --> copy the librarian data into the container 
RUN git clone https://github.com/FabricAttachedMemory/tm-librarian.git

#run script.sh on startup of the container
ENTRYPOINT ["./script.sh"] 
