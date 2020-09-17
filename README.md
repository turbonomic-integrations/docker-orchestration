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

The target will refer to an action script manifest found at `/actionscripts/manifest.json` within the image. The image ships with a simple manifest which defines a replace action script for VIRTUAL_MACHINE RIGHT_SIZE actions, which will take no action.

By mounting a custom manifest file to `/actionscripts/manifest.json` and referencing python scripts which require only the [included modules](#contents) from the image, this can be used stand-alone to execute custom action scripts.

# Prerequisites

* Host Key
* Authorized Key
* Kubernetes secret containing;
  * Both keys
  * A username and password of a Turbonomic OpsMgr user with permissions to add targets

```
$ ssh-keygen -t rsa -f ./hostkey -C "actionscripts hostkey"
$ ssh-keygen -t rsa -f ./turboauthorizedkey -C "actionscripts turbo user key"
$ kubectl create secret generic --from-file=hostkey --from-file=hostkey.pub --from-file=turboauthorizedkey --from-file=turboauthorizedkey.pub --from-literal=turbouser=administrator --from-literal=turbopass=administrator actionscriptkeys
```

# Deployment
Assuming you've met the [prerequisites](#prerequisites) you can deploy the solution in a Kubernetes using the included `deployment.yml`

`$ kubectl apply -f deployment.yml`
