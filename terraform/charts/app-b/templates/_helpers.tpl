{{- define "app-b.name" -}}
{{- .Chart.Name -}}
{{- end -}}

{{- define "app-b.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}