# Políticas de reinicio

## Para esta parte de la práctica
1. Usa el archivo Dockerfile que se encuentra en cada carpeta con el nombre de la política de reinicio para crear una imagen. Analiza las instrucciones de cada Dockerfile 
2. Usa la imagen para ejecutar un contenedor agregando la política respectiva y observar lo que sucede verificando el cumplimiento de la política de reinicio

### no
No reinicia el contenedor bajo ninguna razón. Esta es la política por default
```
docker build -t practica2-no:1.0 ./no
docker run -d --name reinicio-no practica2-no:1.0
```

El Dockerfile solo usa `FROM centos:8`. El comando heredado es `/bin/bash`; sin terminal interactiva ni una tarea pendiente, termina con código 0. Se observó `exited` y `RestartCount=0`.

### always
Reinicia siempre el contenedor si se detiene. Si se detiene manualmente, sólo se reiniciará cuando se reinicie el demonio Docker o cuando se reinicie manualmente el propio contenedor
```
docker build -t practica2-always:1.0 ./always
docker run -d --name reinicio-always --restart always practica2-always:1.0
```

`inicio.sh` imprime un mensaje, espera 6 segundos y termina con `exit 1`. Docker lo volvió a ejecutar. En una de las consultas llevaba 6 reinicios.

### unless-stopped

Reinicia el contenedor cuando termina su proceso, incluso con código 0. Si se detiene manualmente, permanece detenido después de reiniciar Docker.
```
docker build -t practica2-unless-stopped:1.0 ./unless-stopped
docker run -d --name reinicio-unless-stopped --restart unless-stopped practica2-unless-stopped:1.0
```

Este script espera 6 segundos y termina con código 0. También se repitió: en una consulta llevaba 4 reinicios. Esto permite distinguirlo de `on-failure`, que depende de un código de error.

### on-failure
Se reinicia únicamente cuando hay una falla en la ejecución del código que se manifiesta con un código diferente de 0. No se reinicia si el contenedor se detiene manualmente.

```
docker build -t practica2-on-failure:1.0 ./on-failure
docker run -d --name reinicio-on-failure --restart on-failure practica2-on-failure:1.0
```

Este script termina con `exit 1` después de 6 segundos. Se observó que volvía a ejecutarse; en una consulta llevaba 2 reinicios.

También se comprobó una salida correcta con la misma imagen:

```powershell
docker run -d --name reinicio-on-failure-exito --restart on-failure practica2-on-failure:1.0 /bin/bash -c 'sleep 11; exit 0'
```

Después de terminar quedó en `exited`, con salida 0 y sin reinicios.

### Verificar las políticas y los reinicios

Los comandos se ejecutan desde `C:\Users\USER\Desktop\Practicas-Docker\practica2`.

```powershell
docker ps -a
docker inspect reinicio-always --format '{{.HostConfig.RestartPolicy.Name}} {{.RestartCount}} {{.State.Status}}'
docker logs reinicio-always
```

Los scripts se guardaron con finales de línea LF. En Windows, usar CRLF puede hacer que Linux interprete el intérprete de `#!/bin/bash` como una ruta incorrecta. El archivo `.gitattributes` conserva LF para los archivos `.sh`.

### Prueba al detener los contenedores y reiniciar Docker

Se detuvieron manualmente los tres contenedores con reinicio automático y luego se ejecutó `docker desktop restart`. Los servicios de las otras partes se detuvieron antes y se iniciaron al terminar para conservar sus datos.

| Política | Antes de reiniciar Docker | Después de reiniciarlo en esta PC |
| --- | --- | --- |
| `no` | Detenido, salida 0 | Siguió detenido |
| `always` | Detenido manualmente | Volvió a arrancar |
| `unless-stopped` | Detenido manualmente | Siguió detenido |
| `on-failure` | Detenido manualmente, salida 137 | Volvió a arrancar |

En la segunda prueba se inició cada contenedor y se detuvo con `docker stop -t 2` antes de reiniciar Docker. `on-failure` volvió a arrancar en las dos pruebas con Docker Desktop 4.95.0 y Engine 29.8.2. Este resultado difiere de la [documentación de Docker](https://docs.docker.com/engine/containers/start-containers-automatically/), que indica que `on-failure` no reinicia por el arranque del demonio. Se conserva el resultado observado; no se debe depender de esta política como mecanismo de arranque automático.

Al terminar se detuvieron los contenedores de estas cuatro pruebas para evitar que los scripts siguieran reiniciándose. Las imágenes y los contenedores quedaron disponibles para repetir los ejercicios.

Los estados consultados se guardaron en [evidencias/resultados.json](evidencias/resultados.json).
