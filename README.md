# mcs13ed-honeypot-iot

Proyecto para TFM del Master de Ciberseguridad que consiste en el diseño y despliegue de un Honeypot enfocado en IoT

## Tabla de Contenidos

- [Uso](#uso)
- [Licencia](#licencia)
- [Créditos](#créditos)


## Uso
El proyecto dispone del directorio [cowrie](cowrie/) donde se encuentra la configuración de Cowrie, base de datos de usuarios y contraseñas, archivo [pickle](cowrie/share/cowrie/custom-fs.pickle) con un filesystem personalziado para simular un router, y archvios del directorio /etc y /proc personalizados. Tambien se dispone de la configuración para Kibana, Logstash y Filebeat en el directorio [elk](elk/config/).

Se puede hacer uso del script [setup-elk.sh](setup-elk.sh) para realizar una instalación y configuración automatizada de ELK.

```bash
sudo ./setup-elk.sh
```

## Licencia
GNU GENERAL PUBLIC LICENSE. [License](LICENSE)

## Créditos

**Nombre**: Daniel Castellón

**Email**: casmordan[arroba]gmail[punto]com
