{{/*
Expand the name of the chart.
*/}}
{{- define "custom-postgres.name" -}}
{{- .Chart.Name -}}
{{- end }}

{{/*
Create a fully qualified name.
*/}}
{{- define "custom-postgres.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}