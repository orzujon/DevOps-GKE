{{- define "app-a.name" -}}
{{- .Chart.Name -}}
{{- end -}}

{{- define "app-a.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}