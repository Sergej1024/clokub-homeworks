FROM fedora:latest
RUN dnf install -y python3-pip jq \
  	&& dnf clean all \
  	&& rm -rf /var/cache/yum \
    && pip3 install hvac==0.11.2
COPY module.py /opt/module.py
CMD ["sleep", "1000000"]