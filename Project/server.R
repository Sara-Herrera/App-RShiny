# APLICACIÓN RSHINY
#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(readxl)
library(DT)
library(tools)
library(xlsx)
library(ggplot2)
library(plotly)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  # reactive storage variable
  rv <- reactiveValues()
  
  # Variables globales
  rv$fileName <- NULL
  rv$re <- NULL
  rv$datos <- NULL # Se corresponden a los datos cargados con el browser1 de la pestaña 'Visualización'
  rv$dataOrig <- NULL # Backup de los datos para el filtrado
  rv$x <- NULL
  rv$y <- NULL
  rv$typeAgrup <- NULL
  rv$fileVisLoaded = FALSE
  
  # Borrar temp files al inicializar por si existieran en la carpeta de un run anterior
  if (file.exists('rv_re.rds')) {
    file.remove('rv_re.rds')
  }
  if (file.exists('saveRDS.rds')) {
    file.remove('saveRDS.rds')
  }
  
  # Función para resetear los valores de las variables globales
  resetGlobals <- function() {
    rv$fileName <- NULL
    rv$re <- NULL
    rv$datos <- NULL
    rv$dataOrig <- NULL
    rv$x <- NULL
    rv$y <- NULL
    rv$typeAgrup <- NULL
  }
  
  
  ########################################
  # BIENVENIDA
  ########################################  
  
  output$logo <- renderUI(HTML(paste(
    br(), br(), br(), br(),
    a(img(src = 'logo.jpg', 
          width = 75, 
          height = 75,
          style = 'display:block; margin-left: auto; margin-right: auto;'),
      href = 'https://www.linkedin.com/in/sara-herrera-phd-5500711ab/'
    ),
    HTML('<center>'),
    a(strong("Link"),
      href = 'https://www.linkedin.com/in/sara-herrera-phd-5500711ab/'),
    HTML('</center>')
  )))
  
  
  ########################################
  # COMPARAR DATOS TAB
  ########################################
  
  # TODO: Establecer el script de comparación. Incluirlo en la carpeta de la app.
  

  
  
  ########################################
  # TRANSFORMACIÓN DATOS TAB
  ########################################
  
  # Método para cargar archivo a través de navegador (botón). 
  observeEvent(input$trnsLoad, {
    
    resetGlobals()
    
    # COMPROBACIÓN PREVIA: Si ha habido un análisis previo y existen el archivo rv_re se elimina antes de procesar el nuevo por si hubiera fallo
    # en el script y al no generarse los nuevos se cruzarían los datos.
    if (file.exists('rv_re.rds')) {
      file.remove('rv_re.rds')
    }
    
    # Se generan el archivo temporal de resultados.
    if(is.null(input$trnsLoad$datapath)) {
      return(NULL)
    } else {
      rv$fileName <- tools::file_path_sans_ext(input$trnsLoad$name)
      re <- read.csv(input$trnsLoad$datapath)
      rv$re <- re
      saveRDS(re, "rv_re.rds")
    }
  })
  
  # Método para la previsualización de datos (automático)
  output$trnsLoadPreviewTable <- DT::renderDataTable({
    if (is.null(rv$re)) {
      return(NULL)
    } else {
      datatable(rv$re)
    }
  })
  
  # Método para realizar la transformación (botón)
  observeEvent(input$trnsButton, {
    
    if (file.exists('saveRDS.rds')) {
      file.remove('saveRDS.rds')
    }
    
    #Ejecutar script según lo seleccionado en el cmb
    if(input$trnsType == 'Origen_1') {
      system2("Rscript", args = c("script_transformacion_origen1.R"))
    }
    else if(input$trnsType == 'Origen_2') {
      system2("Rscript", args = c("script_transformacion_origen2.R"))
    }
    else if(input$trnsType == 'Origen_3') {
      system2("Rscript", args = c("script_transformacion_origen3.R"))
    }
    
    # Si input$trnsLoad$datapath contiene el archivo 'saveRDS.rds' es que se ha ejecutado correctamente el script y se ha generado el archivo transformado.
    output$mensajeTrns <- renderUI({
      if(!file.exists("saveRDS.rds")){
        div(class = "error-message", "Error en el procesado de datos.")
      }else{
        div(class = "error-message", "Archivo transformado correctamente.")
      }
    })
  })
  
  # Método para descargar el archivo transformado y guardar a través de navegador (botón)
  output$trnsDownload <- downloadHandler(
    
    # Sugerencia de nombre
    filename = function() {
      if (!is.null(rv$fileName)) {
        user_filename <- paste0(rv$fileName, '_TRANSFORMADO.xlsx')
        return(user_filename)
      }
    },
    content = function(file) {
      if (!file.exists("saveRDS.rds")) {
        output$mensajeTrns <- renderUI({
          div(class = "error-message", "Error en el exportado de datos.")
        })
      } else {
        fileR <- readRDS("saveRDS.rds")
        xlsx::write.xlsx(fileR, file, row.names = FALSE)
        file.remove('rv_re.rds')
        file.remove('saveRDS.rds')
        output$mensajeTrns <- renderUI({
          div(class = "success-message", "Archivo exportado correctamente.")
        })
      }
    }
  )
  
  
  
  
  
  ########################################
  # VISUALIZACIÓN DATOS TAB
  ########################################
  
  
  # Botón cargar archivo 1
  observeEvent(input$visLoad, {
    
    if(is.null(input$visLoad$datapath)) {
      return(NULL)
      rv$fileLoaded <- FALSE
    } else {
      rv$datos <- read.csv(input$visLoad$datapath)
      rv$dataOrig <- rv$datos
      rv$fileVisLoaded <- TRUE
    }
    
  })

  
  output$mensajeVis <- renderUI({
    if(rv$fileVisLoaded){
      div(class = "error-message", "Archivo cargado correctamente. ")
    } else if (!is.null(input$visLoad$datapath)){
      div(class = "error-message", "Error cargando el archivo de datos.")
    }
  })
  
  
  # Botón generar gráfico
  observeEvent(input$visGenerarButton, {
    output$visSctrLayout <- renderUI({
      plotlyOutput('scatterPlot',
                   height = input$visSctrHeight,
                   width = input$visSctrWidth)
    })
  })
  
  
  #### ---- PESTAÑA EJES ---- ####
  
  # Radio button group de selección de los ejes del gráfico
  observeEvent(input$visEjesType, {
    if(input$visEjesType == 'Longitud Sépalo vs Anchura Sépalo'){
      rv$x <- 'Sepal.Length'
      rv$y <- 'Sepal.Width'
    }
    else if(input$visEjesType == 'Longitud Pétalo vs Longitud Sépalo'){
      rv$x <- 'Petal.Length'
      rv$y <- 'Sepal.Length'       
    }
    else if(input$visEjesType == 'Anchura Pétalo vs Anchura Sépalo'){
      rv$x <- 'Petal.Width'
      rv$y <- 'Sepal.Width'       
    }
  })

  #### ---- PESTAÑA FILTRADO ---- ####
  
  # Botón 'Reset' para eliminar los filtros creados
  observeEvent(input$visFltrResetButton, {
    # Volver a cargar conjunto de datos total
    rv$datos <- rv$dataOrig
    # Resetear variable seleccionada
    updateSelectInput(session, 'visFltrSelec', selected = 'Ninguna')
    # Resetear grupo de datos seleccionado
    updateSelectInput(session, 'visFltrCrit', choices = '<NONE>')
    
  })
  
  observeEvent(input$visFltrSelec, {
    updateSelectInput(session, 'visFltrCrit',
                      choices = rv$datos[[input$visFltrSelec]]
    )
  })
  
  # Botón 'Filtrar'
  observeEvent(input$visFltrButton, {
    
    if(!is.null(input$visFltrCrit)){
      x <- rv$datos[[input$visFltrSelec]] %in% input$visFltrCrit
      # Subset de las filas del df según el vector que contiene valores TRUE/FALSE
      # IMPORTANTE: Si se seleccionan unos valores y luego se eliminan ya no existen en el df general, hay que resetear
      rv$datos <- rv$datos[x,]
      # Se actualizan las posibles opciones de criterio con la selección anterior así ya no se puede seleccionar lo que no se ha incluido previamente
      updateSelectInput(session, 'visFltrCrit',
                        choices = rv$datos[[input$visFltrSelec]]
      )
    }
  }) 
  
  # Función genérica para generar el Scatterplot
  output$scatterPlot <- renderPlotly({
    # Check if data is available
    if (is.null(rv$datos) || is.null(rv$x) || is.null(rv$y)) {
      return(NULL)
    }
    
    # Set colores según niveles de variable. En tipaje son fijos.
    if(input$visPlotSelec == 'Species'){
      colScale <- scale_colour_manual(
        name = "escalaColores",
        values = c("setosa" = "blue", "versicolor" = "orange", "virginica" = "green")
      )
    }else{
      myColors <- brewer.pal(9,"Set1")
      names(myColors) <- levels(rv$datos[[input$visPlotSelec]])
      colScale <- scale_colour_manual(name = "escalaColores",values = myColors)
    }
    
    
    plt <- ggplot(rv$datos, aes_string(x = rv$x, y = rv$y)) + #, text = "paste0('SampleId: ', `Sample Name`)"
      labs(title = input$visPlotTitle) +
      theme(plot.title = element_text(hjust = 0.5)) +
      geom_point(aes(colour = rv$datos[[input$visPlotSelec]], shape = rv$datos[[input$visPlotTypeAgrup]]), size = input$visPlotSize) +
      scale_shape_manual(values=c(16, 3, 8, 6, 0, 5))
    
    plt <- plt + colScale
    
    pltly <- ggplotly(plt,
                      height = input$visSctrHeight,
                      width = input$visSctrWidth)
    
    return(pltly)
  })

})
