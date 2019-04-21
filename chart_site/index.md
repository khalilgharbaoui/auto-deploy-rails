---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
---
This helm chart is written to deploy rails apps with optional workers using Helm.
<br>It's a fork of the [AutoDevops chart from gitlab](https://gitlab.com/gitlab-org/charts/auto-deploy-app)
<br>It supports Sidekiq and Redis (disabled by default)
<br>And more...

## Features

* Pod for main application.
* Pod for sidekiq worker.
* Redis can be provisioned.
* PostgreSQL database can be provisioned.
<br>

## Options:
See [readme](readme.html)
<br>

## Latest release info

{% for entry in site.data.index['entries']['auto-deploy-rails'] %}

Version: {{entry.version}}

Download package: [{{entry.urls[0]}}]()

Created: {{entry.created | date_to_long_string}} {{entry.created | date: "%H:%M" }}

{% endfor %}

<br>
## Usage with helm
See [readme](readme.html)

### With gitlab

In your CI env variables, or in your modified ```.gitlab-ci.yml``` set the following:

Set ```AUTO_DEVOPS_CHART_REPOSITORY``` to `https://khalilgharbaoui.gitlab.io/auto-deploy-rails`
Set ```AUTO_DEVOPS_CHART``` to `gitlab/auto-deploy-rails`
<br>
<br>
See [readme](readme.html)

### Manual Usage

Add the repo

```helm repo add auto-deploy-rails https://khalilgharbaoui.gitlab.io/auto-deploy-rails/```

Copy [```values.yaml```](https://gitlab.com/khalilgharbaoui/auto-deploy-rails/blob/master/values.yaml) from the repository and modify to fit your app.
See [readme](readme.html) for more information.
