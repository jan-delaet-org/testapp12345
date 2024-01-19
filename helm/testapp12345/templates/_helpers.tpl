{{/*
Expand the name of the chart.
*/}}
{{- define "app.name" -}}
{{- required "A value for the 'applicationName' property is required." .Values.applicationName | trunc 63 | trimSuffix "-" | quote }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "app.labels" -}}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
helm.sh/chart: {{ .Chart.Name | quote }}
helm.sh/chart-version: {{ .Chart.Version | quote }}
helm.sh/release-name: {{ .Release.Name | quote }}
helm.sh/revision: {{ .Release.Revision | quote }}
helm.sh/release-date: {{ (now | date "2006-01-02") | quote }}
helm.sh/release-time: {{ (now | date "15-04-05") | quote }}
{{ include "app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app.name" . }}
app.kubernetes.io/instance: {{ include "app.name" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- .Values.serviceAccount.name | default (include "app.name" .) }}
{{- else }}
{{- .Values.serviceAccount.name | default "default" }}
{{- end }}
{{- end }}
