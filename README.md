# Segundo Trabajo de Evaluación - Laboratorio
## Métodos Computacionales — 2026

### Descripción

El presente trabajo tiene como objetivo implementar y analizar los métodos numéricos de **Gauss-Jordan** e **Interpolación Inversa Lineal**, estudiando sus fundamentos matemáticos, procedimientos y aplicaciones.

Para ello, se desarrolló una aplicación en **GNU Octave** que permite ingresar los datos correspondientes a cada método, ejecutarlos de manera individual y visualizar los resultados obtenidos. La aplicación incorpora una interfaz gráfica que facilita la carga y modificación de los datos, la visualización del procedimiento de resolución y la representación gráfica de los resultados cuando corresponde.

Finalmente, los métodos se aplican a problemas determinados y se analizan los resultados considerando la solución obtenida, el procedimiento realizado y el tiempo de ejecución, permitiendo observar el comportamiento y las características de cada método numérico.

### Estructura del proyecto

El proyecto se organiza en las siguientes carpetas y archivos:

| Archivo / Carpeta | Descripción |
|---|---|
| `main.m` | Punto de entrada de la aplicación. Configura las rutas necesarias e inicia la interfaz gráfica. |
| `interfaz/` | Contiene los archivos de la interfaz gráfica, permite ingresar los datos y coordina la ejecución de los métodos. |
| `metodos/` | Contiene los algoritmos de los métodos numéricos implementados: Gauss-Jordan e Interpolación Inversa Lineal. |
| `graficos/` | Incluye las funciones utilizadas para representar gráficamente los resultados de la interpolación. |

### Requisitos

- Tener instalado [GNU Octave](https://octave.org/).
- Contar con el toolkit gráfico Qt habilitado para la ejecución de la interfaz gráfica.
- Descargar o clonar este repositorio en el equipo.

### Cómo ejecutar la aplicación

1. Descargar o clonar el repositorio.
2. Abrir GNU Octave.
3. Establecer como directorio de trabajo la carpeta raíz del proyecto, donde se encuentra el archivo `main.m`.
4. Ejecutar el archivo `main.m` desde la consola de Octave:

   ```octave
   main
   ```

5. Una vez iniciada la aplicación, se abrirá la interfaz gráfica con los métodos numéricos disponibles.
6. Seleccionar el método que se desea utilizar, revisar o modificar los datos de entrada y ejecutar el procedimiento.

### Integrantes

- Barbero Asselborn, Valentina Nerea
- Rodriguez, Priscila Oriana
