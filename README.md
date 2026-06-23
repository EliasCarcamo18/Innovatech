# Innovatech Chile - Despliegue DevOps en AWS EKS

## Descripción del proyecto

Este proyecto corresponde a la **Evaluación Parcial N°3** de la asignatura **Introducción a Herramientas DevOps (ISY1101)**.

El objetivo fue implementar una solución DevOps para **Innovatech Chile**, utilizando contenedores Docker, Amazon ECR, Amazon EKS y GitHub Actions.

La solución permite desplegar una aplicación compuesta por:

* Frontend React/Vite para gestión de órdenes de compra y despachos.
* Backend de ventas desarrollado con Spring Boot.
* Backend de despachos desarrollado con Spring Boot.
* Base de datos MySQL.
* Pipeline CI/CD automatizado desde GitHub hacia AWS EKS.

---

## Arquitectura implementada

La arquitectura final utiliza **Amazon EKS** como plataforma de orquestación de contenedores.

| Componente           | Tecnología           | Descripción                                              |
| -------------------- | -------------------- | -------------------------------------------------------- |
| Frontend             | React + Vite + Nginx | Interfaz web pública para consultar ventas y despachos   |
| Backend Ventas       | Spring Boot          | Microservicio encargado de gestionar órdenes de compra   |
| Backend Despachos    | Spring Boot          | Microservicio encargado de gestionar órdenes de despacho |
| Base de datos        | MySQL                | Persistencia de datos de ventas y despachos              |
| Contenedores         | Docker               | Empaquetado de cada servicio                             |
| Registro de imágenes | Amazon ECR           | Almacenamiento de imágenes Docker                        |
| Orquestación         | Amazon EKS           | Ejecución de los servicios en Kubernetes                 |
| CI/CD                | GitHub Actions       | Automatización build, push y deploy                      |
| Balanceo             | AWS Load Balancer    | Exposición pública del frontend                          |
| Autoscaling          | Kubernetes HPA       | Escalamiento horizontal de pods                          |

---

## Estructura del repositorio

```txt
Innovatech/
├── .github/
│   └── workflows/
│       └── deploy-eks.yml
│
├── backend-ventas/
│   ├── Dockerfile
│   ├── pom.xml
│   └── src/
│
├── backend-despachos/
│   ├── Dockerfile
│   ├── pom.xml
│   └── src/
│
├── db/
│   ├── Dockerfile
│   └── init.sql
│
├── frontend/
│   └── front_despacho/
│       ├── Dockerfile
│       ├── default.conf
│       ├── package.json
│       ├── vite.config.js
│       └── src/
│
└── k8s/
    ├── namespace.yaml
    ├── mysql-secret.yaml
    ├── mysql-deployment.yaml
    ├── mysql-service.yaml
    ├── ventas-deployment.yaml
    ├── ventas-service.yaml
    ├── ventas-hpa.yaml
    ├── despachos-deployment.yaml
    ├── despachos-service.yaml
    ├── despachos-hpa.yaml
    ├── frontend-deployment.yaml
    ├── frontend-service.yaml
    └── frontend-hpa.yaml
```

---

## Servicios desplegados en EKS

Los servicios desplegados dentro del clúster son:

| Servicio             | Tipo         | Descripción          |
| -------------------- | ------------ | -------------------- |
| innovatech-db        | ClusterIP    | Base de datos MySQL  |
| innovatech-ventas    | ClusterIP    | Backend de ventas    |
| innovatech-despachos | ClusterIP    | Backend de despachos |
| innovatech-frontend  | LoadBalancer | Frontend público     |

Estado final validado en el clúster:

```txt
innovatech-db          1/1 Running
innovatech-despachos   1/1 Running
innovatech-frontend    1/1 Running
innovatech-ventas      1/1 Running
```

URL pública del frontend:

```txt
http://k8s-innovate-innovate-b5ffe5a5ec-3788952c455928a7.elb.us-east-1.amazonaws.com
```

---

## Comunicación entre servicios

El frontend se comunica con los microservicios mediante rutas gestionadas por Nginx.

Archivo principal:

`frontend/front_despacho/default.conf`

Rutas utilizadas:

| Ruta pública        | Servicio interno            |
| ------------------- | --------------------------- |
| `/api/v1/ventas`    | `innovatech-ventas:8080`    |
| `/api/v1/despachos` | `innovatech-despachos:8080` |

Esto permite que el usuario acceda al frontend desde una URL pública, mientras que los backends permanecen internos dentro del clúster.

---

## Base de datos

La base de datos utilizada es **MySQL**.

Base creada:

`innovatech_db`

Tablas principales:

| Tabla    | Descripción                  |
| -------- | ---------------------------- |
| venta    | Registra órdenes de compra   |
| despacho | Registra órdenes de despacho |

El archivo `db/init.sql` contiene la estructura inicial de la base de datos y datos de prueba para validar el funcionamiento del sistema.

La contraseña root de MySQL se gestiona mediante un Secret de Kubernetes:

`k8s/mysql-secret.yaml`

---

## Amazon ECR

Las imágenes Docker se almacenan en **Amazon Elastic Container Registry (ECR)**.

Repositorios utilizados:

* `innovatech-frontend`
* `innovatech-ventas`
* `innovatech-despachos`
* `innovatech-db`

Tag utilizado para las imágenes:

`eks-v1`

---

## Pipeline CI/CD

El pipeline se encuentra en:

`.github/workflows/deploy-eks.yml`

El flujo automatizado realiza las siguientes acciones:

1. Descarga el código desde GitHub.
2. Configura credenciales de AWS Academy mediante GitHub Secrets.
3. Instala `kubectl`.
4. Inicia sesión en Amazon ECR.
5. Crea los repositorios ECR si no existen.
6. Construye las imágenes Docker.
7. Publica las imágenes en Amazon ECR.
8. Conecta `kubectl` al clúster EKS.
9. Aplica los manifiestos Kubernetes.
10. Reinicia los deployments.
11. Valida pods, servicios, HPA y deployments.

Flujo implementado:

```txt
build → push → deploy
```

Tiempo aproximado del pipeline exitoso:

`4 minutos 11 segundos`

---

## GitHub Secrets utilizados

Para evitar exponer credenciales, se configuraron los siguientes secretos en GitHub Actions:

| Secret                | Uso                                  |
| --------------------- | ------------------------------------ |
| AWS_ACCESS_KEY_ID     | Access Key temporal de AWS Academy   |
| AWS_SECRET_ACCESS_KEY | Secret Key temporal de AWS Academy   |
| AWS_SESSION_TOKEN     | Token temporal de sesión AWS Academy |

Además, Kubernetes utiliza un Secret para la contraseña de MySQL:

`MYSQL_ROOT_PASSWORD`

---

## Autoscaling

Se configuró **Horizontal Pod Autoscaler (HPA)** para los servicios principales.

| Servicio  | Min Pods | Max Pods | Métrica |
| --------- | -------: | -------: | ------- |
| Frontend  |        1 |        6 | CPU 60% |
| Ventas    |        1 |        6 | CPU 70% |
| Despachos |        1 |        6 | CPU 70% |

HPA configurados:

* `innovatech-frontend-hpa`
* `innovatech-ventas-hpa`
* `innovatech-despachos-hpa`

En el entorno AWS Academy, las métricas pueden aparecer como `<unknown>` debido a limitaciones del laboratorio o del servidor de métricas. Sin embargo, los manifiestos HPA se encuentran creados y asociados correctamente a los deployments.

---

## Networking y Load Balancer

El frontend se expone públicamente mediante un servicio Kubernetes de tipo `LoadBalancer`.

Configuración de acceso:

| Tipo | Puerto | Origen    |
| ---- | -----: | --------- |
| HTTP |     80 | 0.0.0.0/0 |

También se corrigió el Target Group para que el destino del frontend quedara en estado saludable.

Estado final del Target Group:

```txt
Healthy: 1
Unhealthy: 0
Unused: 0
```

---

## Validación funcional

Se validó que todos los servicios quedaran ejecutándose correctamente en el clúster.

Resultado final:

```txt
innovatech-db          1/1 Running
innovatech-despachos   1/1 Running
innovatech-frontend    1/1 Running
innovatech-ventas      1/1 Running
```

También se validó que el frontend cargara correctamente desde la URL pública y mostrara información de órdenes de compra y despachos.

Endpoints utilizados por el frontend:

* `/api/v1/ventas`
* `/api/v1/despachos`

---

## Problemas encontrados y soluciones aplicadas

### 1. Credenciales AWS Academy expiradas

Durante la implementación, algunas ejecuciones fallaron por credenciales temporales vencidas o bloqueadas por AWS Academy.

**Solución aplicada:**

* Reiniciar el laboratorio AWS Academy.
* Actualizar los GitHub Secrets:

  * `AWS_ACCESS_KEY_ID`
  * `AWS_SECRET_ACCESS_KEY`
  * `AWS_SESSION_TOKEN`

---

### 2. Frontend en estado 0/1

El frontend inicialmente quedaba en estado `CrashLoopBackOff`.

**Causa detectada:**

```txt
host not found in upstream "tienda-backend"
```

**Solución aplicada:**

Se corrigió el archivo `default.conf`, reemplazando la referencia antigua `tienda-backend` por los servicios reales:

* `innovatech-ventas`
* `innovatech-despachos`

---

### 3. Load Balancer con Target Group en estado Unused

El Target Group aparecía con el destino en estado `Unused`, por lo que la URL pública no respondía.

**Solución aplicada:**

* Se revisaron subredes y Availability Zones.
* Se configuró correctamente la subnet pública correspondiente.
* Se logró que el Target Group quedara en estado saludable.

---

### 4. Workflow YAML inválido

Al modificar el pipeline, GitHub Actions mostró errores de sintaxis en el archivo YAML.

**Solución aplicada:**

* Se corrigió la indentación.
* Se reescribió el workflow completo.
* Se validó que el archivo comenzara correctamente con `name: CI/CD Innovatech EKS`.

---

### 5. Frontend real no estaba siendo construido

El pipeline inicialmente construía la carpeta `./frontend`, pero el frontend real estaba dentro de:

`./frontend/front_despacho`

**Solución aplicada:**

Se modificó el workflow para construir el frontend real con el siguiente comando:

```bash
docker build -t $ECR_FRONTEND ./frontend/front_despacho
```

---

## Comandos útiles

Construir frontend real localmente:

```bash
docker build -t innovatech-frontend ./frontend/front_despacho
```

Construir backend ventas:

```bash
docker build -t innovatech-ventas ./backend-ventas
```

Construir backend despachos:

```bash
docker build -t innovatech-despachos ./backend-despachos
```

Construir base de datos:

```bash
docker build -t innovatech-db ./db
```

Verificar pods:

```bash
kubectl get pods -n innovatech -o wide
```

Verificar servicios:

```bash
kubectl get svc -n innovatech
```

Verificar HPA:

```bash
kubectl get hpa -n innovatech
```

---

## Conclusión

El proyecto implementa una solución DevOps completa para Innovatech Chile, utilizando Docker, Amazon ECR, Amazon EKS y GitHub Actions.

La arquitectura permite automatizar el despliegue del frontend, los microservicios backend y la base de datos, manteniendo comunicación interna entre servicios y exposición pública controlada mediante Load Balancer.

El pipeline CI/CD permite liberar nuevas versiones automáticamente después de cada commit en la rama `deploy`, cumpliendo con el flujo:

```txt
build → push → deploy
```

Finalmente, se logró validar el funcionamiento del clúster, la ejecución de los pods, el acceso público al frontend, la comunicación Frontend → Backend y la configuración de autoscaling mediante HPA.
