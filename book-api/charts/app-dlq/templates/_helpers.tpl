{{- define "app-dlq.fullname" -}}
{{- .Release.Name }}-{{ .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{- define "app-dlq.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "app-dlq.labels" -}}
{{ include "app-dlq.selectorLabels" . }}
{{- end }}