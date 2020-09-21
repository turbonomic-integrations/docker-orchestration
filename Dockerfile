ARG flavor=alpine

FROM turbointegrations/base:1-$flavor

COPY entrypoint.sh /entrypoint.sh

RUN apk update && \
    apk --no-cache add bash git openssh augeas shadow jq curl && \
    groupadd -g 1000 turbo && \
    useradd -r -m -p '' -u 1000 -g 1000 -c 'SSHD User' turbo && \
    mkdir -p /etc/authorized_keys && \
    mkdir -p /etc/ssh/keys && \
    mkdir -p /actionscripts && \
    chown -R turbo:turbo /actionscripts && \
    augtool 'set /files/etc/ssh/sshd_config/AuthorizedKeysFile "/etc/authorized_keys/%u"' && \
    augtool 'set /files/etc/ssh/sshd_config/HostKey[1] /etc/ssh/keys/hostkey' && \
    echo -e "Port 22\n" >> /etc/ssh/sshd_config && \
    pip install boto3 && \
    pip install msrest && \
    pip install msrestazure && \
    pip install azure-common && \
    pip install azure-mgmt-commerce && \
    pip install azure-mgmt-compute && \
    pip install azure-mgmt-network && \
    pip install azure-mgmt-resource && \
    pip install azure-mgmt-storage && \
    pip install pyvmomi && \
    chmod +x /entrypoint.sh && \
    mkfifo /var/log/stdout && \
    chmod 0666 /var/log/stdout && \
    rm -rf /var/cache/apk/*

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]
