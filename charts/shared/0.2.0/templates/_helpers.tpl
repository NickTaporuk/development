{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "shared.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "shared.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "shared.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "shared.labels" -}}
app.kubernetes.io/name: {{ include "shared.name" . }}
helm.sh/chart: {{ include "shared.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "charts.autoscaler.role" -}}
{{- printf "%s-autoscaler-role"  .Values.global.cluster.name | quote -}}
{{- end -}}

{{- define "charts.certmanager.role" -}}
{{- printf "%s-certmanager-role"  .Values.global.cluster.name | quote -}}
{{- end -}}

{{- define "charts.externalDNS.role" -}}
{{- printf "%s-externalDNS-role"  .Values.global.cluster.name | quote -}}
{{- end -}}

{{- define "charts.externalSecrets.role" -}}
{{- printf "%s-secrets-role"  .Values.global.cluster.name | quote -}}
{{- end -}}

{{- define "charts.fluxcloud.github" -}}
{{= if .Values.global.repo.name -}}
{{- printf "https://github.com/%s/%s" .Values.global.github.account .Values.global.repo.name | quote -}}
{{- else -}}
{{- printf "https://github.com/%s/cluster-%s" .Values.global.github.account .Values.global.cluster.name | quote -}}
{{- end -}}
{{- end -}}

{{- define "charts.fluxcloud.slack.channel" -}}
{{- printf "#flux-%s" .Values.global.cluster.name | quote -}}
{{- end -}}