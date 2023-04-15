{{/*
Expand the name of the chart.
*/}}
{{- define "micro-auth.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "micro-auth.fullname" -}}
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
{{- define "micro-auth.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "micro-auth.labels" -}}
helm.sh/chart: {{ include "micro-auth.chart" . }}
{{ include "micro-auth.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "micro-auth.selectorLabels" -}}
app.kubernetes.io/name: {{ include "micro-auth.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Prometheus metrics annotations
*/}}
{{- define "micro-auth.annotations" -}}
{{- if .Values.metric.enabled }}
prometheus.io/scrape: "true"
prometheus.io/path: {{ .Values.metric.path | quote }}
prometheus.io/port: {{ .Values.metric.port | quote }}
{{- end }}
{{- if .Values.dapr.enabled }}
dapr.io/enabled: {{ .Values.dapr.enabled | quote }}
dapr.io/app-id: {{ .Values.dapr.appId | quote }}
dapr.io/app-port: {{ .Values.service.http | quote }}
{{- end }}
{{- range $key, $val := .Values.podAnnotations }}
{{ $key }}: {{ $val | quote }}
{{- end }}
{{- end }}
