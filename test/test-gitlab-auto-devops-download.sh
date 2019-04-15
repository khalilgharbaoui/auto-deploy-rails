#!/bin/bash
AUTO_DEVOPS_CHART=auto-deploy-rails/auto-deploy-rails
AUTO_DEVOPS_CHART_REPOSITORY=https://khalilgharbaoui.gitlab.io/auto-deploy-rails
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

download_chart
helm repo list
helm repo remove auto-deploy-rails
cat chart/Chart.yaml
rm -rf chart
