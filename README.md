# Auto-deploy rails chart

Initially forked from GitLab's Auto-deploy Helm Chart, but due to need workers, this fork was created.

Initially sidekiq is implemented.

Delayed job should be a matter of adding the proper commands

## Requirements

- Helm `2.9.0` and above is required in order support `"helm.sh/hook-delete-policy": before-hook-creation` for migrations

## TODO

Implement automatic packaging similar to this blog post:
https://medium.com/containerum/how-to-make-and-share-your-own-helm-package-50ae40f6c221

For gitlab pages:
https://tobiasmaier.info/posts/2018/03/13/hosting-helm-repo-on-gitlab-pages.html

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
| service.commonName            | If present, this will define the ssl certificate common name to be used by CertManager. `service.url` and `service.additionalHosts` will be added as Subject Alternative Names (SANs) | `nil` |
| service.externalPort          |             | `3000`                             |
| service.internalPort          |             | `3000`                             |
| livenessProbe.path            | Path to access on the HTTP server on periodic probe of container liveness. | `/`                                |
| livenessProbe.initialDelaySeconds | # of seconds after the container has started before liveness probes are initiated. | `15`                               |
| livenessProbe.timeoutSeconds  | # of seconds after which the liveness probe times out. | `15`                               |
| readinessProbe.path           | Path to access on the HTTP server on periodic probe of container readiness. | `/`                                |
| readinessProbe.initialDelaySeconds | # of seconds after the container has started before readiness probes are initiated. | `5`                                |
| readinessProbe.timeoutSeconds | # of seconds after which the readiness probe times out. | `3`                                |
| worker.enabled                |             | `true` |
| worker.command                |             | `bundle exec sidekiq` |
| worker.replicaCount           |             | 1 |
| worker.sidekiq_alive.enabled  |             | `true` |
| worker.sidekiq_alive.livenessProbe.path            | Path to access on the HTTP server on periodic probe of container liveness. | `/`                                |
| worker.sidekiq_alive.livenessProbe.initialDelaySeconds | # of seconds after the container has started before liveness probes are initiated. | `15`                               |
| worker.sidekiq_alive.livenessProbe.timeoutSeconds  | # of seconds after which the liveness probe times out. | `15`                               |
| worker.sidekiq_alive.livenessProbe.port  | Port for sidekiq_alive | `7433`                               |
| worker.sidekiq_alive.readinessProbe.path           | Path to access on the HTTP server on periodic probe of container readiness. | `/`                                |
| worker.sidekiq_alive.readinessProbe.initialDelaySeconds | # of seconds after the container has started before readiness probes are initiated. | `5`   |
| worker.sidekiq_alive.readinessProbe.port  | Port for sidekiq_alive | `7433`                               |
| worker.sidekiq_alive.readinessProbe.timeoutSeconds | # of seconds after which the readiness probe times out. | `3`                                |
| postgresql.enabled            |             | `false`                            |
| podDisruptionBudget.enabled   |             | `false`                            |
| podDisruptionBudget.maxUnavailable |             | `1`                            |
| podDisruptionBudget.minAvailable | If present, this variable will configure minAvailable in the PodDisruptionBudget. :warning: if you have `replicaCount: 1` and `podDisruptionBudget.minAvailable: 1` `kubectl drain` will be blocked.              | `nil`                            |
