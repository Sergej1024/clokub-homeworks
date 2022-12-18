FROM fedora:latest
RUN dnf -y install pip jq \
    && dnf clean all \
  	&& rm -rf /var/cache/yum \
    && pip install -q hvac
COPY secrets.py /opt/secret-hvac.py
RUN chmod +x /opt/secret-hvac.py
EXPOSE 8200
CMD ["python3", "/opt/secret-hvac.py"]
