Despliegue tienda-perritos en EKS (namespace 'tienda')

1) Configurar kubectl contra tu cluster:
   aws eks update-kubeconfig --region us-east-1 --name <NOMBRE_TU_CLUSTER>

2) Aplicar namespace:
   kubectl apply -f namespace.yaml

3) Aplicar recursos de base de datos:
   kubectl apply -f mysql-secret.yaml
   kubectl apply -f mysql-deployment.yaml
   kubectl apply -f mysql-service.yaml

4) Aplicar backend:
   kubectl apply -f backend-deployment.yaml
   kubectl apply -f backend-service.yaml

5) Aplicar frontend:
   kubectl apply -f frontend-deployment.yaml
   kubectl apply -f frontend-service.yaml

6) Verificar:
   kubectl get pods -n tienda
   kubectl get svc tienda-frontend -n tienda

Copias el EXTERNAL-IP (DNS del ELB) → lo abres en el navegador→ deberías ver la página de Tienda de Perritos ������

Nota: Si te da error, y sale el pod con estado Pending (valida correctamente la configuración de la Actividad 1 – paso 4).




Proyecto Innovatech Chile - Despliegue en EKS

Orden de despliegue:

1. namespace.yaml
2. mysql-secret.yaml
3. mysql-deployment.yaml
4. mysql-service.yaml
5. ventas-deployment.yaml
6. ventas-service.yaml
7. despachos-deployment.yaml
8. despachos-service.yaml
9. frontend-deployment.yaml
10. frontend-service.yaml
11. ventas-hpa.yaml
12. despachos-hpa.yaml
13. frontend-hpa.yaml

Servicios:
- innovatech-frontend: público mediante LoadBalancer.
- innovatech-ventas: interno mediante ClusterIP.
- innovatech-despachos: interno mediante ClusterIP.
- innovatech-db: interno mediante ClusterIP.

