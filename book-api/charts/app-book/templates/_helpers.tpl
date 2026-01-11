{{- define "app-book.fullname" -}}
{{- .Release.Name }}-{{ .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{- define "app-book.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "app-book.labels" -}}
{{ include "app-book.selectorLabels" . }}
{{- end }}