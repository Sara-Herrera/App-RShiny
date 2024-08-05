# Cargar librería necesaria
library(dplyr)
library(lubridate)

# Leer el temporal RDS y transformarlo a df
datos <- readRDS("rv_re.rds")
datos<-as.data.frame(datos)

# Transformar la columna fecha_hora para obtener solo la fecha
datos_transformados <- datos %>%
  mutate(fecha = as.Date(ymd_hm(fecha_hora)))

datos_transformados <- datos_transformados %>%
  select(
    fecha,
    temperatura_max_c,
    temperatura_min_c,
    rafaga_viento_kmh,
    humedad
  ) %>%
  rename(
    temperatura_max = temperatura_max_c,
    temperatura_min = temperatura_min_c,
    velocidad_media_viento_kmh = rafaga_viento_kmh,
    humedad_media = humedad
  )

# Exportar el dataframe a un nuevo archivo temporal RDS
saveRDS(datos_transformados, "saveRDS.rds")
