# Cargar librerías necesarias
library(dplyr)

# Leer el temporal RDS y transformarlo a df
datos <- readRDS("rv_re.rds")
datos<-as.data.frame(datos)

# Crear un vector para mapear las direcciones del viento a sus siglas
direccion_viento_map <- c(
  "Norte" = "N",
  "Sur" = "S",
  "Este" = "E",
  "Oeste" = "W",
  "Noreste" = "NE",  
  "Noroeste" = "NW",
  "Sureste" = "SE",
  "Suroeste" = "SW"
)

# Reemplazar las direcciones del viento en texto por sus siglas
datos_transformados <- datos %>%
  mutate(direccion_viento = recode(direccion_viento, !!!direccion_viento_map))

# Seleccionar las columnas necesarias
datos_transformados <- datos_transformados %>%
  select(
    fecha,
    temperatura_max_c,
    temperatura_min_c,
    velocidad_viento_kmh,
    humedad_relativa
  ) %>%
  rename(
    temperatura_max = temperatura_max_c,
    temperatura_min = temperatura_min_c,
    velocidad_media_viento_kmh = velocidad_viento_kmh,
    humedad_media = humedad_relativa
  )

# Exportar el dataframe a un nuevo archivo temporal RDS
saveRDS(datos_transformados, "saveRDS.rds")
