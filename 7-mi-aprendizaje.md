# Mi aprendizaje

Además de crear el contenedor con `docker run`, se puede decidir cuánta memoria y CPU puede usar. `--memory` limita la RAM y `--memory-swap` incluye la RAM más la swap. En el ejemplo de 300 MiB y 1 GiB quedan 724 MiB para swap. Los valores se revisaron con `docker inspect` y con los archivos de cgroup.

En CPU, `--cpus` limita el tiempo de procesamiento y `--cpuset-cpus` permite elegir cuáles procesadores puede usar. El healthcheck revisa si el servicio responde. Al quitar el archivo de inicio de Nginx apareció un error 403 y el estado cambió a `unhealthy`, aunque el contenedor seguía encendido. Al devolver el archivo volvió a `healthy`.

El Dockerfile guarda las instrucciones para crear la imagen. Al cambiar el nombre en la web, Docker usó la instalación de Apache que ya tenía y solo repitió la copia de archivos. Eso evita instalar los paquetes cada vez que cambia la página. Hubo que usar Vault para los repositorios de CentOS 7 e iniciar Apache directamente con `httpd` para que pudiera arrancar otra vez después de detenerlo.

Las políticas de reinicio dependen de cómo termina el proceso y de si se detuvo manualmente. `always` volvió a arrancar después de reiniciar Docker y `unless-stopped` siguió detenido. En esta versión `on-failure` también volvió a arrancar, algo distinto de lo que dice la documentación. Se dejó anotado porque pasó en las dos pruebas.
