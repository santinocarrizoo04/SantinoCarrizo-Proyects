## Links útiles

Enunciado: 
https://docs.google.com/document/d/1-AqFTroovEMcA1BfC2rriB5jsLE6SUa4mbcAox1rPec/edit

Pruebas: 
https://docs.google.com/document/d/1XsBsJynoN5A9PTsTEaZsj0q3zsEtcnLgdAHOQ4f_4-g/edit

## Deploy del TP

Para poder hacer el deploy del TP y ejecutar el proyecto, es necesario tener clonado el siguiente repositorio:

```bash
git clone https://github.com/sisoputnfrba/so-deploy.git
cd so-deploy
```

Luego es necesario hacer el deploy del proyecto y asignar las variables por configuracion (IP's de los módulos y PATH's)

```bash
./deploy.sh -r=release -p=utils -p=kernel -p=cpu -p=memoria -p=entradasalida "tp-2024-1c-ChatGPT-CarreanOS"
./configure.sh IP_XXX 192.168.x.xxx
./configure.sh PATH_XXXX /xxx/xxx
```

Por ultimo ejecutar los módulos, pasandole el path de la configuracion, en el siguiente orden: 

1. Memoria
2. CPU
3. Kernel
4. Interfaces

[so-commons-library]: https://github.com/sisoputnfrba/so-commons-library
[so-deploy]: https://github.com/sisoputnfrba/so-deploy


