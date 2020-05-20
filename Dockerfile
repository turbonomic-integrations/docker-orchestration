ARG flavor=alpine

FROM turbointegrations/base:0.1-$flavor

RUN pip install boto3 && \
    pip install msrest && \
    pip install msrestazure && \
    pip install azure-common && \
    pip install azure-mgmt-commerce && \
    pip install azure-mgmt-compute && \
    pip install azure-mgmt-network && \
    pip install azure-mgmt-resource && \
    pip install azure-mgmt-storage && \
    pip install pyvmomi
