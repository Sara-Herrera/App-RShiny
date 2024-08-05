# Cargar librería necesaria
library(dplyr)

# Leer el temporal RDS y transformarlo a df
datos <- readRDS("rv_re.rds")
datos<-as.data.frame(datos)

# Convertir de Fahrenheit a Celsius
fahrenheit_a_celsius <- function(fahrenheit) {
  (fahrenheit - 32) * 5 / 9
}

# Convertir las temperaturas y seleccionar las columnas necesarias
datos_transformados <- datos %>%
  mutate(
    temperatura_max = fahrenheit_a_celsius(temp_max_f),
    temperatura_min = fahrenheit_a_celsius(temp_min_f)
  ) %>%
  select(
    fecha,
    temperatura_max,
    temperatura_min,
    viento_vel_media_kmh,
    humedad_prom
  )  %>%
  rename(
    velocidad_media_viento_kmh = viento_vel_media_kmh,
    humedad_media = humedad_prom
  )

# Exportar el dataframe a un nuevo archivo temporal RDS
saveRDS(datos_transformados, "saveRDS.rds")
