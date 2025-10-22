# Ejercicio de Kubernetes Multicloud (AWS + GCP)

## Objetivo: un repositorio con manifiestos Kubernetes que contenga errores intencionales para que los alumnos detecten, analicen y propongan correcciones. El escenario simula un despliegue multi-cloud (AWS y GCP) donde escala y aparecen problemas reales.

---

## Estructura:

```
tf-meli-mod2/
├─ README.md
├─ k8s/
│  ├─ base/
│  │  ├─ namespace.yml
│  │  ├─ deployment.yml
│  │  ├─ service.yml
│  │  ├─ hpa.yml
│  │  ├─ configmap.yml
│  │  ├─ secrets_plaintext.yml
│  │  └─ poddisruptionbudget.yml
│  ├─ aws/
│  │  ├─ ingress-aws.yml
│  │  │
│  └─ gcp/
│     ├─ ingress-gcp.yml
│     └─ backend-config.yml
└─ incidents/
   └─ incident_playbook.md
```

---

# Contenido de archivos (manifiestos)

> **IMPORTANTE:** estos archivos están diseñados para clase: contienen configuraciones inseguras y malas prácticas **intencionales**. No desplegar en producción.

---

## `k8s/base/deployment.yml`
Problemas intencionales incluidos: imagen con tag `vulnerable-2020` (sin actualizaciones), falta de `readinessProbe` y `livenessProbe` consistentes, *variables de entorno sensibles* definidas directamente en el `spec`, recursos no limitados (sólo requests) y un `imagePullPolicy: Always` forzado con tags inmutables — esto genera pulls frecuentes; además, hay configuración duplicada (dos contenedores con misma app pero diferente envs) para que los alumnos detecten.

---

## `k8s/base/service.yml`
Servicio simple, pero sin selector consistente y con tipo LoadBalancer (genera costos). Además una anotación conflictiva se añade para ambos clouds (para que los alumnos vean providers out-of-band).

---

## `k8s/base/hpa.yml`
HPA mal configurada para que los alumnos detecten: targetCPUUtilizationPercentage muy bajo y `metrics` mal añadidas (api version antigua). Además se menciona horizontalPodAutoscaler en `autoscaling/v1` que carece de métricas actuales.

---

## `k8s/base/configmap.yml`
Contiene configuraciones duplicadas e incompletas. Algunos keys se repiten con valores distintos para que los alumnos detecten conflicto de configuración.

---

## `k8s/base/secrets_plaintext.yml`
**Error intencional crítico:** secrets almacenados como ConfigMap/plaintxt en vez de Secrets, y además en texto plano dentro del repo para el ejercicio.

---

## `k8s/base/poddisruptionbudget.yml`
PDB con minAvailable = 100% (impracticable) para forzar decisiones de disponibilidad durante rolling updates.

---

## `k8s/aws/ingress-aws.yml`
Anotaciones específicas de AWS ALB/ELB colocadas, pero mezcladas con anotaciones de GCP para generar conflicto.

---

## `k8s/gcp/ingress-gcp.yml`
Anotaciones de GCP con backendConfig referenciando un `backend-config` que no existe.

---

## `k8s/gcp/backend-config.yml`
Archivo intencionalmente incompleto (falta `securityPolicy` y health checks mal definidos).

---

# `incidents/incident_playbook.md`
Un playbook para el incidente en el que una nueva imagen produjo incompatibilidades, reinicios y degradación en una zona.

---


# Sugerencias de correcciones (para guía del profesor)
- Migrar credenciales a `Secret` y/o integraciones de Cloud KMS/Secret Manager.
- Añadir `readinessProbe`/`livenessProbe` y health checks en los Ingress/backend.
- Definir `resources.limits` además de `requests` y añadir `LimitRange` si se desea.
- Actualizar imagen base a una Distroless Image de Fury.
- Resolver duplicados en `ConfigMap` y validar JSON con `kubectl apply --dry-run=client` o `kubeconform`.
- Revisar PDB para que `minAvailable` sea razonable (ej. 50% o `maxUnavailable: 1`).
- Usar `imagePullPolicy: IfNotPresent` si se usan tags fijos o usar digests (`sha256:`).

---


