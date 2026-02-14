FROM registry.access.redhat.com/ubi9

# Update image and install httpd
RUN yum install -y httpd && yum clean all

# Expose the default httpd port 80
EXPOSE 80

# Run the httpd
CMD ["/usr/sbin/httpd", "-DFOREGROUND"]
