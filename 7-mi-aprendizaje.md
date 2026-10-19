# Mi aprendizaje

Estas pruebas permiten pasar de crear un contenedor con `docker run` a controlar los recursos que puede usar. `--memory` limita la RAM, mientras que `--memory-swap` fija el total de RAM y swap. En el ejemplo de 300 MiB y 1 GiB, quedan 724 MiB para swap. La configuración se comprobó con `docker inspect` y con los archivos de cgroup.

En CPU hay dos controles distintos: `--cpus` limita el tiempo de procesamiento y `--cpuset-cpus` elige los procesadores lógicos permitidos. Un healthcheck revisa si responde el servicio. En la prueba de Nginx, quitar el archivo de inicio produjo un error 403 y el estado pasó a `unhealthy`, pero el contenedor siguió encendido. Al restaurar el archivo volvió a `healthy`.

El Dockerfile guarda las instrucciones para construir una imagen. Al cambiar el nombre en la web, Docker reutilizó la instalación de Apache y repitió la copia de archivos. Esto ahorra tiempo cuando solo cambia el contenido de la aplicación. Los repositorios de CentOS 7 se ajustaron a Vault y Apache se ejecutó directamente con `httpd` para que pudiera volver a iniciarse después de detener el contenedor.

Las políticas de reinicio dependen de cómo termina el proceso y de si se detuvo manualmente. `always` volvió a arrancar después de reiniciar Docker y `unless-stopped` permaneció detenido. El comportamiento distinto de `on-failure` en esta versión quedó documentado con los resultados de las dos pruebas. Comprobar lo que ocurre en el equipo permite detectar estas diferencias en lugar de asumir que todos los entornos se comportan igual.
