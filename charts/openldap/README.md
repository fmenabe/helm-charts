# OpenLDAP Helm chart

[OpenLDAP](https://openldap.org/) is the open-source solution for LDAP (Lightweight Directory Access Protocol). It is a protocol used to store and retrieve data from a hierarchical directory structure such as in databases.

## TL;DR

```
helm repo add fmenabe https://charts.fmenabe.me/chartrepo/library
helm install openldap fmenabe/openldap
```

## Usage

| Name | Description | Value |
| ---- | ----------- | ----- |
| `replicaCount` | Number of replicas | *1* |
| `image.repository` | Docker image to use | *bitnami/openldap* |
| `image.pullPolicy` | Image pull policy | *IfNotPresent* |
| `image.tag` | Image tag. Overrides the image tag whose default is the chart `appVersion` |  |
| `imagePullSecrets` | Image pull secrets | *[]* |
| `nameOverride` | String to partially override `common.names.fullname` template (will maintain the release name) | |
| `fullnameOverride` | String to fully override `common.names.fullname` template with a string | |
| `serviceAccount.create` | Specifies whether a service account should be created | *true* |
| `serviceAccount.annotations` | Annotations to add to the service account | *true* |
| `serviceAccount.name` | The name of the service account to use.  If not set and create is true, a name is generated using the fullname template | |
| `podAnnotations` | Additional annotations for pods | *{}* |
| `podSecurityContext` | Defines privilege and access control settings for the Pod | *{}* |
| `securityContext` | Defines privilege and access control settings for the container | *{}* |
| `service.type` | Kubernetes Service type | *ClusterIP* |
| `service.port` | OpenLDAP service port | *1389* |
| `resources.limits` | The resources limits for pods | *{}* |
| `resources.requests` | The resources requests for pods | *{}* |
| `autoscaling.enabled` | | *false* |
| `autoscaling.minReplicas` | | *1* |
| `autoscaling.maxReplicas` | | *100* |
| `autoscaling.targetCPUUtilizationPercentage` | | *80* |
| `autoscaling.targetMemoryUtilizationPercentage` | | *80* |
| `nodeSelector` | Node labels for pods assignemnt | *{}* |
| `tolerations` | Tolerations for pods assignment | *[]* |
| `affinity` | Affinity for pods assigment | *{}* |
| `openldap.root` | LDAP baseDN (or suffix) of the LDAP tree | *dc=example,dc=org* |
| `openldap.admin.username` | LDAP database admin user | *admin* |
| `openldap.admin.password` | LDAP database admin password | *adminpassword* |
| `openldap.configAdmin.enabled` | Whether to create a configuration admin user | *false* |
| `openldap.configAdmin.username` | LDAP configuration admin user | *admin* |
| `openldap.configAdmin.password` | LDAP configuration admin password | *configpassword* |
| `openldap.userDC` | DC for the users' organizational unit | *users* |
| `openldap.extraSchemas.enabled` | Whether to add the schemas specified in `openldap.extraSchemas.schemas` | *true* |
| `openldap.extraSchemas.schemas` | Extra schemas to add, among OpenLDAP's distributed schemas | *[cosine, inetorgperson, nis]* |
| `openldap.customLdifDir` | Location of a directory that contains LDIF files that should be used to bootstrap the database. Only files ending in .ldif will be used. | */ldifs* |
| `openldap.customLdifConfigMaps` | Config maps that will be used to populate `openldap.customLdifDir` directory | *[]* |
| `openldap.customSchemaFile` | Location of a custom internal schema file that could not be added as custom ldif file (i.e. containing some structuralObjectClass) | */schemas/custom.ldif* |
| `openldap.customSchemaDir` | Location of a directory containing custom internal schema files that could not be added as custom ldif files (i.e. containing some structuralObjectClass). This can be used in addition to or instead of `openldap.customSchemaFile` (above) to add multiple schema files | */schemas* |
| `openldap.customSchemaConfigMaps` | Config maps that will populate *custom.ldif* or addiotional structural ldifs | *[]* |
| `openldap.ulimitNoFiles` | Maximum number of open file descriptors | *1024* |
| `openldap.allowAnonBinding` | Allow anonymous bindings to the LDAP server | *true* |
| `openldap.logLevel` | Set the loglevel for the OpenLDAP server (see https://www.openldap.org/doc/admin25/slapdconfig.html for possible values) | *256* |
