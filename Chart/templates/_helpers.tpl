{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "opennebula.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "opennebula.sunstone.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}-sunstone
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "opennebula.fullname" -}}
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
{{- define "opennebula.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "opennebula.labels" -}}
app.kubernetes.io/name: {{ include "opennebula.name" . }}
helm.sh/chart: {{ include "opennebula.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create a default fully qualified client name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "opennebula.oned.fullname" -}}
{{ template "opennebula.fullname" . }}-oned
{{- end -}}
{{/*
Create a default fully qualified for sunstone
*/}}
{{- define "opennebula.sunstone.fullname" -}}
{{ template "opennebula.fullname" . }}-sunstone
{{- end -}}
{{/*
Create a default fully qualified for mysql
*/}}
{{- define "opennebula.mysql.fullname" -}}
{{- printf "%s-%s" .Release.Name "mysql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{/*
Create a default fully qualified for scheduler
*/}}
{{- define "opennebula.sched.fullname" -}}
{{ template "opennebula.fullname" . }}-sched
{{- end -}}
{{/*
Create a default fully qualified for memcached
*/}}
{{- define "opennebula.memcached.fullname" -}}
{{ template "opennebula.fullname" . }}-memcached
{{- end -}}
{{/*
Create a default fully qualified for node
*/}}
{{- define "opennebula.node.fullname" -}}
{{ template "opennebula.fullname" . }}-node
{{- end -}}
{{/*
Create a default fully qualified for node
*/}}
{{- define "opennebula.flow.fullname" -}}
{{ template "opennebula.fullname" . }}-oneflow
{{- end -}}
