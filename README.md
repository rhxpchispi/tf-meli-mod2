# Terraform Chatbot Lab

## Objetivo: proveer una infraestructura en AWS y GCP para que los alumnos identifiquen errores y malas prácticas.

El código está pensado como **material de entrenamiento**, no para uso real.
Todas las configuraciones son *válidas sintácticamente* y pueden ejecutarse con `terraform plan`
sin conectarse a los proveedores.

---

## Estructura:

- **AWS:** VPC, EKS, IAM Role/Policy, Security Group, VPN hacia GCP.  
- **GCP:** Red, Firewall, VPN Gateway, Túnel VPN hacia AWS.  
- **Ambientes:** `envs/dev.tfvars`, `envs/test.tfvars`, `envs/prod.tfvars`.

---

## Cómo usar:

1. `terraform init`
2. `terraform plan -var-file=envs/dev.tfvars`
3. `También podés usar test.tfvars o prod.tfvars`

**Notas**:

- El lab contiene reglas de firewall/SG muy permisivas.
- Hay una política IAM con `Action = "*"`, `Resource = "*"`

---

## Explicación rápida de las “fallas intencionales”:

Estas configuraciones fueron creadas a propósito para que los alumnos las identifiquen y propongan mejoras:

1. **Security Groups y Firewalls abiertos a todo**

- aws_security_group.open_sg y google_compute_firewall.allow_all permiten todo (0.0.0.0/0).
- Deben restringirse a los puertos y rangos necesarios.

2. **Política IAM con permisos totales (* en Action y Resource)**

- Política AllowEverythingPolicy con Action="*" y Resource="*"
- Muy peligrosa, deben limitarse las acciones.

3. **Shared secret**

- VPN usa clave débil "supersecret".
- Detectar y reemplazar por variable sensible.

4. **Recursos con nombres genéricos (allow-all, dummy-eks)**

- Recomendación: usar convención clara por ambiente.

5. **Tags y nombres inconsistentes**

- Algunos recursos no siguen un estándar uniforme.