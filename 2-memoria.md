# Limitar uso de memoria
Definir la cantidad máxima de memoria RAM que el contenedor puede utilizar a un valor en cierta unidad, en donde m para megabytes, g para gigabytes, etc.
Si configuras esta opción, el valor mínimo permitido es 6m (6 megabytes).
_Se puede usar --memory o -m_
```
--memory=<valor><unidad>
```
La opción --memory-swap se usar para definir la cantidad total de memoria que un contenedor puede utilizar, es decir se incluye tanto la memoria RAM como la memoria swap
```
--memory=<valor><unidad> --memory-swap=<valorUnidad>
```
Por lo tanto, la memoria swap máxima disponible para el contenedor se calcula como:

Memoria swap máxima = *memory-swap − memory

**Considerar:** el parámetro --memory-swap siempre se utiliza en conjunto con --memory para definir un límite total de memoria que incluye tanto la memoria RAM como la memoria swap. Al establecer solo --memory-swap sin --memory, Docker no tiene un punto de referencia para calcular la memoria swap máxima, lo que causará un error.

### Ejemplos
Limitar la memoria RAM que el contenedor puede utilizar a 10 megabytes
```
docker run -d --name p2-memoria-10 --memory=10m nginx:alpine
```

Limitar la memoria RAM que el contenedor puede utilizar a 300 megabytes y que el límite total de memoria y memoria swap combinados que el contenedor puede utilizar sea 1 gigabyte
```
docker run -d --name p2-memoria-300 --memory=300m --memory-swap=1g nginx:alpine
```
**¿Cuántos megabytes de memoria swap puede utilizar el contenedor creado anteriormente?**
Puede usar hasta 724 MiB de swap: `1g = 1024 MiB`, por lo tanto `1024 - 300 = 724 MiB`. Docker interpreta estos sufijos como múltiplos de 1024. El límite de RAM es 300 MiB y el total de RAM más swap es 1024 MiB; la disponibilidad real también depende del host.

Se verificó la configuración con:

```powershell
docker inspect p2-memoria-300 --format '{{.HostConfig.Memory}} {{.HostConfig.MemorySwap}}'
docker exec p2-memoria-300 cat /sys/fs/cgroup/memory.max /sys/fs/cgroup/memory.swap.max
```

`inspect` devolvió `314572800 1073741824` bytes. Los límites de cgroup fueron `314572800` para RAM y `759169024` para swap, que corresponden a 300 MiB y 724 MiB.

El contenedor de 10 MiB también arrancó: `Memory=10485760` y `OOMKilled=false`. Se usaron nombres distintos para poder conservar las dos pruebas.

Referencia: [límites de memoria de Docker](https://docs.docker.com/engine/containers/resource_constraints/).
