# App-RShiny

Esta aplicación proporciona diversas funcionalidades para la manipulación y visualización de datos.

1. Pestaña Comparar
   
Permite la comparación de dos conjuntos de datos. **Esta funcionalidad aún no está operativa y está pendiente de finalización**.

3. Pestaña Transformación
   
Se han creado tres supuestos orígenes de datos meteorológicos. Esta funcionalidad permite la modificación y transformación de cada uno de ellos, generando un archivo común para todos.
Se han cargado tres ejemplos de archivos de datos:
- `ejemplo_transformacion_origen1.csv`: Transforma la variable **dirección del viento** de texto a siglas.
- `ejemplo_transformacion_origen2.csv`: Transforma la variable **fecha** de formato fecha-hora a únicamente fecha.
- `ejemplo_transformacion_origen3.csv`: Transforma las variables de **temperaturas** (máxima y mínima) de grados Fahrenheit a grados Celsius.
- 
3. Pestaña Visualización

Se ha creado el archivo `iris_data_modif.csv` a partir del dataset iris, incluyendo nuevas variables generadas (*"Sepal.Length.Classification", "Petal.Length.Classification", "Area", "Area.Classification"*).
Esta funcionalidad permite la visualización de los datos en un scatterplot, permitiendo modificar de forma dinámica las variables de los ejes, colores y tamaños de los componentes del gráfico, así como aplicar determinados filtros.

4. Pestaña Análisis
   
Permite realizar el análisis de diferentes tipos de datos, pudiendo ampliar el combobox según sea necesario y añadiendo las variables requeridas. **Esta funcionalidad aún no está operativa y está pendiente de finalización**.
