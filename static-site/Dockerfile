FROM nginx
ENV AUTHOR=Docker
EXPOSE 80

WORKDIR /usr/share/nginx/html
COPY Hello_docker.html /usr/share/nginx/html
# envconsul
ADD https://releases.hashicorp.com/envconsul/0.7.3/envconsul_0.7.3_linux_amd64.tgz envconsul.tgz
RUN tar -xvzf envconsul.tgz
RUN mv envconsul /usr/local/bin/envconsul
RUN chmod +x /usr/local/bin/envconsul

# consul template
ADD https://releases.hashicorp.com/consul-template/0.19.4/consul-template_0.19.4_linux_amd64.tgz consul-template.tgz
RUN tar -xvzf consul-template.tgz
RUN mv consul-template /usr/local/bin/consul-template
RUN chmod +x /usr/local/bin/consul-template

COPY envconsul-config.hcl /usr/share/nginx/html
COPY consul-template-config.hcl /usr/share/nginx/html

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Run your program under Tini
#CMD ["/your/program", "-and", "-its", "arguments"]
# or docker run your-image /your/program ...
CMD ["consul-template", "-config", "/usr/share/nginx/html/consul-template-config.hcl"]
