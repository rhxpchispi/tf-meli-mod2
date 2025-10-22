# Incidente: regresión por cambio en imagen base

**Síntomas:** contenedores reiniciándose (CrashLoopBackOff) en la zona `us-east-1a`. Métricas muestran latencias crecientes y errores 500.

**Hipótesis iniciales:**
- La nueva imagen base contiene una dependencia con versiones incompatibles.
- Variables de entorno faltantes o renombradas (migración de config) causan fallo en arranque.
- Cambios en librerías nativas (libc, OpenSSL) rompen compatibilidad.

**Pasos sugeridos:**
1. Hacer `kubectl rollout undo deployment/melibot -n melibot` para restaurar la versión anterior.
2. Poner la imagen problemática en `ImagePullPolicy: IfNotPresent` temporalmente para evitar pulls.
3. Escalar réplicas manualmente en la zona afectada: `kubectl scale deployment/melibot --replicas=0 -n melibot` y volver a 3 tras rollback controlado.
4. Marcar la imagen afectada y bloquear deploys en pipelines.

**Acciones posteriores al rollback:**
- Añadir `readinessProbe` y `livenessProbe` (checks HTTP/port).
- Implementar Distroless Image de Fury, transparentar el SBOM y firma de imágenes.
- Utilizar las diferentes mini imagenes para stages de pipelines (dev images).
- Migrar secrets a `kubectl create secret generic` o integraciones con KMS/Secret Manager.
- Usar `imagePullPolicy` consistente con tags semánticos.

**Decisiones de riesgo temporal aceptables:**
- Mantener una versión anterior de la imagen hasta completar tests.
- Permitir escalado manual para recuperar disponibilidad.