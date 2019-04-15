---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
---
This helm chart is written to deploy rails apps using Helm.
<br>It's a fork of the [AutoDevops chart from gitlab](https://gitlab.com/charts/auto-deploy-app)
<br>
<br>

## Features

* Pod for main application
* Pod for worker
* Postgres database can be provisioned if needed.
<br>
<br>

## Options:
See [readme](readme.html)
<br>
<br>

## Latest release info

{% for entry in site.data.index['entries']['auto-deploy-rails'] %}

Version: {{entry.version}}

Download package: [{{entry.urls[0]}}]()

Created: {{entry.created | date_to_long_string}} {{entry.created | date: "%H:%M" }}

{% endfor %}

<br>
## Usage with helm

### With gitlab

In your CI env variables, or in your modified ```.gitlab-ci.yml``` set the following:

Set ```AUTO_DEVOPS_CHART_REPOSITORY``` to https://khalilgharbaoui.gitlab.io/auto-deploy-rails
Set ```AUTO_DEVOPS_CHART``` to auto-deploy-rails
<br>
<br>

### Manual Usage

Add the repo

```helm repo add auto-deploy-rails https://khalilgharbaoui.gitlab.io/auto-deploy-rails/```

Copy [```values.yaml```](https://gitlab.com/khalilgharbaoui/auto-deploy-rails/blob/master/values.yaml) from the repository and modify to fit your app.
