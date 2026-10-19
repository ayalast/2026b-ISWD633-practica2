FROM centos:7
RUN sed -i 's|^mirrorlist=|#mirrorlist=|g; s|^#baseurl=http://mirror.centos.org/centos/\$releasever|baseurl=https://vault.centos.org/7.9.2009|g' /etc/yum.repos.d/CentOS-*.repo && yum -y update
RUN yum -y install httpd && yum clean all
COPY ./web /var/www/html
EXPOSE 80
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
