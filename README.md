# Kafka on Kubernetes

Repository consists of:

- Kafka all-in-one docker-compose script (based on [cp-all-in-one](https://github.com/confluentinc/cp-all-in-one/blob/5.5.1-post/cp-all-in-one/docker-compose.yml))

- Kafka all-in-one helm charts (based on [cp-helm-charts](https://github.com/confluentinc/cp-helm-charts))

- Kafka helm charts for AWS MSK (based on [cp-helm-charts](https://github.com/confluentinc/cp-helm-charts))

---

## Deployment

### Docker-Compose

Docker-Compose is a local dev environment. Including a `postgres` module
to generate testing data in the docker-compose network.

`./data-mock.py` is an example script to generate demo data for testing.

### Kubernetes / all-in-one

Kubernetes charts is in `./helm/kafka`, which is based on [cp-helm-charts](https://github.com/confluentinc/cp-helm-charts).

It can easily setup by `helm`:

```sh
cd helm

kubectl create ns kafka
helm install -f kafka/values-dev.yaml -n kafka kafka kafka

# patching existing helm
helm upgrade -f kafka/values-dev.yaml -n kafka kafka kafka
```

### Kubernetes / MSK or Production

For production deployment on MSK, we should dump the
`values-dev.yaml` to `values-prod.yaml` for another set of configurations.

```sh
cd helm

kubectl create ns kafka
helm install -f kafka/values-prod.yaml -n kafka kafka kafka

# patching existing helm
helm upgrade -f kafka/values-prod.yaml -n kafka kafka kafka
```

## Misc

### Helm Chart

Here is the Kafka stack components and the sub-chart templates for
corresponding kubernetes components:

| Component | Templates | Description |
| --------- | --------- | ----------- |
| Kafdrop   | `charts/kafdrop` | Minimal UI for kafka brokers |
| Kafka Connect | `charts/kafka-connect` | Kafka connect distributed server |
| Kafka Connect UI | `charts/kafka-connect-ui` | Minimal UI for kafka-connect |
| Kafka Rest | `charts/kafka-rest` | Kafka Rest Proxy, good for frontend development ? |
| Schema Registry | `charts/schema-registry` | Metadata server, good-to-have |
| Schema Registry UI | `charts/schema-regsitry-ui` | Minimal UI for schema registry, buggy in k8s setup tho |
| Brokers   | `charts/kafka-broker` | For all-in-one setup |
| Zookeeper | `charts/zookeeper`| For all-in-one setup |

### JMX / Prometheus

Confluent Kafka components enable Java Management Extensions (JMX) for monitoring.
By enabling `${component}.prometheus.jmx.enabled`, components in kubernetes open
port for exporting application metrics.

One can easily setup Prometheus monitoring in kubernetes with
[Prometheus Operator](https://github.com/prometheus-community/helm-charts).
