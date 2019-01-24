# GitLab's Auto-deploy Helm Chart

## Requirements

- Helm `2.9.0` and above is required in order support `"helm.sh/hook-delete-policy": before-hook-creation` for migrations

## Configuration

| Parameter                     | Description | Default                            |
| ---                           | ---         | ---                                |
| replicaCount                  |             | `1`                                |
| image.repository              |             | `gitlab.example.com/group/project` |
| image.tag                     |             | `stable`                           |
| image.pullPolicy              |             | `Always`                           |
| image.secrets                 |             | `[name: gitlab-registry]`          |
| application.track             |             | `stable`                           |
| application.tier              |             | `web`                              |
| application.migrateCommand    | If present, this variable will run as a shell command within an application Container as a Helm pre-upgrade Hook. Intended to run migration commands. | `nil` |
| application.initializeCommand | If present, this variable will run as shall command within an application Container as a Helm post-install Hook. Intended to run database initialization commands. | `nil` |
| application.secretName        | Pass in the name of a Secret which the deployment will [load all key-value pairs from the Secret as environment variables](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#configure-all-key-value-pairs-in-a-configmap-as-container-environment-variables) in the application container. | `nil` |
| application.secretChecksum    | Pass in the checksum of the secrets referenced by `application.secretName`. | `nil` |
| service.enabled               |             | `true`                             |
| service.name                  |             | `web`                              |
| service.type                  |             | `ClusterIP`                        |
| service.url                   |             | `http://my.host.com/`              |
| service.additionalHosts       | If present, this list will add additional hostnames to the server configuration. | `nil` |
| service.externalPort          |             | `5000`                             |
| service.internalPort          |             | `5000`                             |
| postgresql.enabled            |             | `true`                             |
| podDisruptionBudget.enabled   |             | `false`                            |
| podDisruptionBudget.maxUnavailable |             | `1`                            |
| podDisruptionBudget.minAvailable | If present, this variable will configure minAvailable in the PodDisruptionBudget. :warning: if you have `replicaCount: 1` and `podDisruptionBudget.minAvailable: 1` `kubectl drain` will be blocked.              | `nil`                            |
