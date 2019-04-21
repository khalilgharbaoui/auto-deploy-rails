# Auto-deploy Rails helm chart

Forked from GitLab's Auto-deploy Helm Chart Initially.

Added support for `Rails`, `Sidekiq`, `Redis` and `PostgreSQL`.
(sidekiq and redis are disabled by default see configuration below!)
## Requirements

- Helm `2.9.0` and above is required in order support `"helm.sh/hook-delete-policy": before-hook-creation` for migrations

## Usage with helm in Gitlab.
Example:
```
echo "1️Deploying first release with database initialization..."
      helm upgrade --install \
        --wait \
        --set replicaCount="$replicas" \
        --set releaseOverride="$CI_ENVIRONMENT_SLUG" \
        --set service.enabled="$service_enabled" \
        --set service.commonName="$CI_COMMIT_REF_SLUG-preview.$KUBE_INGRESS_BASE_DOMAIN" \
        --set service.url="$CI_ENVIRONMENT_URL" \
        --set service.additionalHosts="$additional_hosts" \
        --set image.repository="$CI_APPLICATION_REPOSITORY" \
        --set image.tag="$CI_APPLICATION_TAG" \
        --set image.pullPolicy=IfNotPresent \
        --set image.secrets[0].name="$secret_name" \
        --set redis.enabled="true" \
        --set redis.cluster.enabled="false" \
        --set redis.usePassword="false" \
        --set redis.persistence.enabled=false \
        --set postgresql.enabled="$postgres_enabled" \
        --set postgresql.nameOverride="postgres" \
        --set postgresql.postgresUser="$POSTGRES_USER" \
        --set postgresql.postgresPassword="$POSTGRES_PASSWORD" \
        --set postgresql.postgresDatabase="$POSTGRES_DB" \
        --set postgresql.imageTag="$POSTGRES_VERSION" \
        --set application.track="$track" \
        --set application.database_url="$DATABASE_URL" \
        --set application.redis_url="$REDIS_URL" \
        --set application.secretName="$APPLICATION_SECRET_NAME" \
        --set application.secretChecksum="$APPLICATION_SECRET_CHECKSUM" \
        --set application.initializeCommand="$DB_INITIALIZE" \
        --set worker.enabled="true" \
        --namespace="$CI_COMMIT_REF_NAME-$KUBE_NAMESPACE" \
        "$name" \
        chart/

      echo "2️Deploying second release...(running migrations)"
      helm upgrade --reuse-values \
        --wait \
        --set application.initializeCommand="" \
        --set application.migrateCommand="$DB_MIGRATE" \
        --namespace="$CI_COMMIT_REF_NAME-$KUBE_NAMESPACE" \
        "$name" \
        chart/
```
### With gitlab

In your CI env variables, or in your modified ```.gitlab-ci.yml``` set the following:

Set ```AUTO_DEVOPS_CHART_REPOSITORY``` to https://khalilgharbaoui.gitlab.io/auto-deploy-rails
Set ```AUTO_DEVOPS_CHART``` to gitlab/auto-deploy-rails

*Note:* due to a bug in the .gitlab-ci.yml, you need to use gitlab/auto-deploy-rails instead of auto-deploy-rails/auto-deploy-rails,
even if the latter makes sense looking at the repo. This will conflict if you are using gitlab charts on the same helm instance. As
you are unlikely to use gitlab charts during deployment, it should work. If you use gitlab charts as well, look at the solution below.

You can also opt to change download_chart in gitlab-ci.yml to the following:

```
function download_chart() {
  if [[ ! -d chart ]]; then
    auto_chart=${AUTO_DEVOPS_CHART:-gitlab/auto-deploy-app}
    auto_chart_base=$(dirname $auto_chart)
    auto_chart_name=$(basename $auto_chart)
    auto_chart_name=${auto_chart_name%.tgz}
    auto_chart_name=${auto_chart_name%.tar.gz}
  else
    auto_chart="chart"
    auto_chart_name="chart"
  fi

  helm init --client-only
  helm repo add $auto_chart_base ${AUTO_DEVOPS_CHART_REPOSITORY:-https://charts.gitlab.io}
  if [[ ! -d "$auto_chart" ]]; then
    helm fetch ${auto_chart} --untar
  fi
  if [ "$auto_chart_name" != "chart" ]; then
    mv ${auto_chart_name} chart
  fi

  helm dependency update chart/
  helm dependency build chart/
}
```

### Manual Usage

Add the repo

```helm repo add auto-deploy-rails https://khalilgharbaoui.gitlab.io/auto-deploy-rails/```

Copy [```values.yaml```](https://gitlab.com/khalilgharbaoui/auto-deploy-rails/blob/master/values.yaml) from the repository and modify to fit your app.

## Configuration

| Parameter                     | Description | Default                            |
| ---                           | ---         | ---                                |
| replicaCount                  |             | `1`                                |
| image.repository              |             | `gitlab.example.com/group/project` |
| image.tag                     |             | `stable`                           |
| image.pullPolicy              |             | `Always`                           |
| image.secrets                 |             | `[name: gitlab-registry]`          |
| podAnnotations                | Pod annotations | `{}`                           |
| application.track             |             | `stable`                           |
| application.tier              |             | `web`                              |
| application.migrateCommand    | If present, this variable will run as a shell command within an application Container as a Helm pre-upgrade Hook. Intended to run migration commands. | `nil` |
| application.initializeCommand | If present, this variable will run as shall command within an application Container as a Helm post-install Hook. Intended to run database initialization commands. | `nil` |
| application.secretName        | Pass in the name of a Secret which the deployment will [load all key-value pairs from the Secret as environment variables](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#configure-all-key-value-pairs-in-a-configmap-as-container-environment-variables) in the application container. | `nil` |
| application.secretChecksum    | Pass in the checksum of the secrets referenced by `application.secretName`. | `nil` |
| gitlab.env                    | GitLab environment. | `nil` |
| gitlab.app                    | GitLab project slug. | `nil` |
| service.enabled               |             | `true`                             |
| service.annotations           | Service annotations | `{}`                       |
| service.name                  |             | `web`                              |
| service.type                  |             | `ClusterIP`                        |
| service.url                   |             | `http://my.host.com/`              |
| service.additionalHosts       | If present, this list will add additional hostnames to the server configuration. | `nil` |
| service.commonName            | If present, this will define the ssl certificate common name to be used by CertManager. `service.url` and `service.additionalHosts` will be added as Subject Alternative Names (SANs) | `nil` |
| service.externalPort          |             | `5000`                             |
| service.internalPort          |             | `5000`                             |
| ingress.tls.enabled           | If true, enables SSL | `true`                    |
| ingress.tls.secretName        | Name of the secret used to terminate SSL traffic | `""` |
| ingress.annotations           | Ingress annotations | `{kubernetes.io/tls-acme: "true", kubernetes.io/ingress.class: "nginx"}` |
| livenessProbe.path            | Path to access on the HTTP server on periodic probe of container liveness. | `/`                                |
| livenessProbe.scheme          | Scheme to access the HTTP server (HTTP or HTTPS). | `HTTP`                                |
| livenessProbe.initialDelaySeconds | # of seconds after the container has started before liveness probes are initiated. | `15`                               |
| livenessProbe.timeoutSeconds  | # of seconds after which the liveness probe times out. | `15`                               |
| readinessProbe.path           | Path to access on the HTTP server on periodic probe of container readiness. | `/`                                |
| readinessProbe.scheme         | Scheme to access the HTTP server (HTTP or HTTPS). | `HTTP`                                |
| readinessProbe.initialDelaySeconds | # of seconds after the container has started before readiness probes are initiated. | `5`                                |
| readinessProbe.timeoutSeconds | # of seconds after which the readiness probe times out. | `3`                                |
| postgresql.enabled            |             | `true`                             |
| redis.enabled                 |             | `true`                            |
| redis.usePassword             |             | `false`                            |
| redis.cluster.enable          |             | `false`                            |
| worker.enabled                |             | `true` |
| worker.command                |             | `['/bin/sh']`|
| worker.args                   | If present, this variable will override the entrypoint and run as shall command within an the worker Container. Intended to start the worker. | `'bundle exec sidekiq'` |
| worker.replicaCount           |             | 1 |
| worker.sidekiq_alive.enabled  | `sidekiq_alive` provides liveness probe for Sidekiq in Kubernetes deployments and is disabled is by default using it requires you have the gem: https://github.com/arturictus/sidekiq_alive | `false` |
| worker.sidekiq_alive.livenessProbe.path            | Path to access on the HTTP server on periodic probe of container liveness. | `/`                                |
| worker.sidekiq_alive.livenessProbe.initialDelaySeconds | # of seconds after the container has started before liveness probes are initiated. | `15`                               |
| worker.sidekiq_alive.livenessProbe.timeoutSeconds  | # of seconds after which the liveness probe times out. | `15`                               |
| worker.sidekiq_alive.livenessProbe.port  | Port for sidekiq_alive | `7433`                               |
| worker.sidekiq_alive.readinessProbe.path           | Path to access on the HTTP server on periodic probe of container readiness. | `/`                                |
| worker.sidekiq_alive.readinessProbe.initialDelaySeconds | # of seconds after the container has started before readiness probes are initiated. | `5`   |
| worker.sidekiq_alive.readinessProbe.port  | Port for sidekiq_alive | `7433`                               |
| worker.sidekiq_alive.readinessProbe.timeoutSeconds | # of seconds after which the readiness probe times out. | `3`                                |
| podDisruptionBudget.enabled   |             | `false`                            |
| podDisruptionBudget.maxUnavailable |             | `1`                            |
| podDisruptionBudget.minAvailable | If present, this variable will configure minAvailable in the PodDisruptionBudget. :warning: if you have `replicaCount: 1` and `podDisruptionBudget.minAvailable: 1` `kubectl drain` will be blocked.              | `nil`                            |

Static site generated with Jekyll. See chart_site folder for details
