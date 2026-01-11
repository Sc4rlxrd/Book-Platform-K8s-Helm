{{- define "prometheus.fullname" -}}
{{- .Release.Name }}-{{ .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{- define "prometheus.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "prometheus.labels" -}}
{{ include "prometheus.selectorLabels" . }}
{{- end }}