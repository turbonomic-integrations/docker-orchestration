# Turbonomic Integrations Orchestration Docker Image
This is a base docker image for orchestration (custom action scripts) solutions created by the Turbonomic Integration team, and deployed in a Turbo 7 Kubernetes environment.

# Contents
* Python 3.8
* Public Python Modules
  * vmtconnect
  * vmtplan
  * umsg
  * dateutils
  * pyyaml
  * boto3
  * msrest
  * msrestazure
  * azure-common
  * azure-mgmt-commerce
  * azure-mgmt-compute
  * azure-mgmt-network
  * azure-mgmt-resource
  * azure-mgmt-storage
  * pyvmomi

# Usage
When deployed with the necessary [prerequisites](#prerequisites), this image will add itself as an orchestration target to the Turbonomic instance in the same Kubernetes cluster and namespace.

## Default Manifest and Script
The target will refer to an action script manifest found at `/actionscripts/manifest.json` within the image. The image ships with a simple manifest which defines a replace action script for VIRTUAL_MACHINE RIGHT_SIZE actions, which will take no action, but will dump the environment variables and SDK Probe JSON to the log output of the container.

If the default script is used, you can access the log output (after executing a VIRTUAL_MACHINE RIGHT_SIZE action, via properly configured policy) with this command;
```
$ kubectl logs $(kubectl get pods -l app=actionscripts -n turbointegrations -o name) -n turbointegrations`
```

## Custom Manifest and Script(s)
By mounting a custom manifest file to `/actionscripts/manifest.json`, and custom python scripts which require only the [included modules](#contents) from the image to any path referenced by the manifest, this can be used stand-alone to execute custom action scripts.

# Prerequisites

This requires the following prerequisites.
* A Kubernetes namespace named `turbointegrations`
* SSH Daemon Host Key (public and private)
  * This is used to uniquely identify the SSH "host", in this case, the single running pod in Kubernetes which hosts this integration.
* SSH User Authorized Key (public and private)
  * This is used to uniquely identify the SSH "user" which is authorized to connect to the SSH Daemon.
* Turbonomic API Service Account Username & Password

If your Kubernetes cluster does not already have a `turbointegrations` namespace, you may create it with;
```
$ kubectl create namespace turbointegrations
```

To generate a host key and user key the following commands can be used
(ProTip: Do *NOT* set a passphrase for the keys.);
```
$ ssh-keygen -t rsa -f ./hostkey -C "actionscripts hostkey"
$ ssh-keygen -t rsa -f ./turboauthorizedkey -C "actionscripts turbo user key"
```

Once you have both sets of keys, and the credentials for a Turbonomic API Service Account (assumed to be administrator:administrator here), these can all be securely stored in Kubernetes with this command;
```
$ kubectl create secret generic actionscriptkeys -n turbointegrations \
--from-file=hostkey --from-file=hostkey.pub \
--from-file=turboauthorizedkey --from-file=turboauthorizedkey.pub \
--from-literal=turbouser=administrator --from-literal=turbopass=administrator
$ kubectl label secret actionscriptkeys -n turbointegrations \
environment=prod \
team=turbointegrations \
app=actionscripts
```

# Deployment
Assuming you've met the [prerequisites](#prerequisites) you can deploy the solution in a Kubernetes using the included `deployment.yml`

`$ kubectl apply -f deployment.yml`
