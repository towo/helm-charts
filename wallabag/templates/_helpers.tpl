{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "wallabag.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "wallabag.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "wallabag.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "wallabag.labels" -}}
helm.sh/chart: {{ include "wallabag.chart" . }}
{{ include "wallabag.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "wallabag.selectorLabels" -}}
app.kubernetes.io/name: {{ include "wallabag.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "wallabag.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "wallabag.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "db.servicename" -}}
{{- if .Values.wallabag.database.builtIn.postgresql.enabled -}}
{{- printf "%s-postgresql" .Release.Name -}}
{{- else if .Values.wallabag.database.builtIn.mariadb.enabled -}}
{{- printf "%s-mariadb" .Release.Name -}}
{{- else -}}
{{- $parts := split ":" .Values.gitea.config.database.HOST -}}
{{- printf "%s %s" $parts._0 $parts._1 -}}
{{- end -}}
{{- end -}}

{{- define "db.port" -}}
{{- if .Values.wallabag.database.builtIn.postgresql.enabled -}}
{{ .Values.postgresql.global.postgresql.servicePort }}
{{- else if .Values.wallabag.database.builtIn.mariadb.enabled -}}
{{ .Values.mariadb.primary.service.port }}
{{- else -}}
{{- end -}}
{{- end -}}

{{- define "postgresql.dns" -}}
{{- printf "%s-postgresql.%s.svc.%s:%g" .Release.Name .Release.Namespace .Values.clusterDomain .Values.postgresql.global.postgresql.servicePort -}}
{{- end -}}
{{- define "mysql.dns" -}}
{{- printf "%s-mysql.%s.svc.%s:%g" .Release.Name .Release.Namespace .Values.clusterDomain .Values.mysql.service.port | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- define "mariadb.dns" -}}
{{- printf "%s-mariadb.%s.svc.%s:%g" .Release.Name .Release.Namespace .Values.clusterDomain .Values.mariadb.primary.service.port | trunc 63 | trimSuffix "-" -}}
{{- end -}}
