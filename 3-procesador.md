# Limitar uso de procesador
Limitar la cantidad de núcleos de CPU:
```
--cpus=<número de núcleos>
```

Asignar núcleos de CPU específicos:
```
--cpuset-cpus=<lista de núcleos>
```

**¿Como saber el numero de procesadores virtuales que tiene una máquina?**
En PowerShell se puede ver con estos comandos

```powershell
(Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors
docker info --format '{{.NCPU}}'
```

Los dos devolvieron `16` en esta PC. Son procesadores lógicos y el equipo tiene 8 núcleos físicos. El comando de Docker muestra cuántos están disponibles para su motor Linux.

## Ejemplos
_Puedes copiar y ejecutar directamente cada uno de los comandos_

Limitar el uso de CPU a 1.5 núcleos
```
docker run -d --name p2-cpu-15 --cpus="1.5" nginx:alpine
```

Restringir el contenedor para que use los núcleos de CPU 0 a 2:
```
docker run -d --name p2-cpu-02 --cpuset-cpus="0-2" nginx:alpine
```

Restringir el contenedor para que use los núcleos de CPU 1 y 3:
```
docker run -d --name p2-cpu-13 --cpuset-cpus="1,3" nginx:alpine
```

### Comprobación

```powershell
docker inspect p2-cpu-15 --format '{{.HostConfig.NanoCpus}}'
docker exec p2-cpu-15 cat /sys/fs/cgroup/cpu.max
docker exec p2-cpu-02 cat /sys/fs/cgroup/cpuset.cpus.effective
docker exec p2-cpu-13 cat /sys/fs/cgroup/cpuset.cpus.effective
```

| Contenedor | Resultado | Qué limita |
| --- | --- | --- |
| `p2-cpu-15` | `1500000000` NanoCPUs; `cpu.max` igual a `150000 100000` | Tiempo de CPU equivalente a 1.5 procesadores |
| `p2-cpu-02` | `0-2` | Puede usar los procesadores lógicos 0, 1 y 2 |
| `p2-cpu-13` | `1,3` | Puede usar los procesadores lógicos 1 y 3 |

Con `--cpus` se limita el tiempo de CPU que puede usar el contenedor. Con `--cpuset-cpus` se elige en cuáles procesadores puede trabajar. Se revisaron esos límites sin hacer una prueba de estrés.
