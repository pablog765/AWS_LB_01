# AWS_LB_01
Testing Terraform Deployment Load Balancer and two Instances EC2

# Despliegue de Instancias EC2 y Load Balancer con Terraform en AWS

Este proyecto de Terraform automatiza el despliegue de dos instancias EC2 con un servidor web simple detrás de un Application Load Balancer (ALB).

## Requisitos

* **Terraform**: Asegúrate de tener Terraform instalado en tu sistema.
* **Credenciales de AWS**: Debes tener las credenciales de un usuario de AWS con permisos para crear recursos como VPC, subredes, EC2, y Load Balancer.

## Configuración

1.  **Clona este repositorio:**
    ```bash
    git clone [https://github.com/tu_usuario/tu_repositorio.git](https://github.com/tu_usuario/tu_repositorio.git)
    cd tu_repositorio
    ```

2.  **Configura tus credenciales de AWS:**
    No incluyas tus credenciales directamente en los archivos del repositorio. Utiliza variables de entorno o el archivo de credenciales de AWS (`~/.aws/credentials`).

    ```bash
    # Ejemplo con variables de entorno (no necesario si usas el archivo de credenciales)
    export AWS_ACCESS_KEY_ID="tu_access_key_id"
    export AWS_SECRET_ACCESS_KEY="tu_secret_access_key"
    ```

3.  **Inicializa Terraform:**
    ```bash
    terraform init
    ```

4.  **Verifica el plan de despliegue:**
    ```bash
    terraform plan
    ```

5.  **Aplica los cambios:**
    ```bash
    terraform apply
    ```
    Confirma con `yes` cuando te lo pida.

## Limpiar los Recursos

Para evitar costos, puedes destruir todos los recursos creados con Terraform:

```bash
terraform destroy
