{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kafdrop.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kafdrop.fullname" -}}
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
{{- define "kafdrop.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified kafka headless name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kafdrop.kafka-broker-headless.fullname" -}}
{{- $name := "kafka-broker-headless" -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Form the Kafka URL. If Kafka is installed as part of this chart, use k8s service discovery,
else use user-provided URL
*/}}
{{- define "kafdrop.kafka.bootstrapServers" -}}
{{- if .Values.kafka.bootstrapServers -}}
{{- .Values.kafka.bootstrapServers -}}
{{- else -}}
{{- printf "PLAINTEXT://%s:9092" (include "kafdrop.kafka-broker-headless.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified schema registry name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kafdrop.schema-registry.fullname" -}}
{{- $name := default "schema-registry" (index .Values "schema-registry" "nameOverride") -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "kafdrop.schema-registry.service-name" -}}
{{- if (index .Values "schema-registry" "url") -}}
{{- printf "%s" (index .Values "schema-registry" "url") -}}
{{- else -}}
{{- printf "http://%s:8081" (include "kafdrop.schema-registry.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified connect name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kafdrop.kafka-connect.fullname" -}}
{{- $name := default "kafka-connect" (index .Values "kafka-connect" "nameOverride") -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "kafdrop.kafka-connect.service-name" -}}
{{- if (index .Values "kafka-connect" "url") -}}
{{- printf "%s" (index .Values "kafka-connect" "url") -}}
{{- else -}}
{{- printf "http://%s:8083" (include "kafdrop.kafka-connect.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified zookeeper name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kafdrop.zookeeper.fullname" -}}
{{- $name := default "zookeeper" (index .Values "zookeeper" "nameOverride") -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Form the Zookeeper URL. If zookeeper is installed as part of this chart, use k8s service discovery,
else use user-provided URL
*/}}
{{- define "kafdrop.zookeeper.service-name" }}
{{- if (index .Values "zookeeper" "enabled") -}}
{{- $clientPort := default 2181 (index .Values "zookeeper" "clientPort") | int -}}
{{- printf "%s:%d" (include "kafdrop.zookeeper.fullname" .) $clientPort }}
{{- else -}}
{{- $zookeeperConnect := printf "%s" (index .Values "zookeeper" "url") }}
{{- $zookeeperConnectOverride := (index .Values "configurationOverrides" "zookeeper.connect") }}
{{- default $zookeeperConnect $zookeeperConnectOverride }}
{{- end -}}
{{- end -}}