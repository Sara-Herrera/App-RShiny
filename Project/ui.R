# APLICACIÓN RSHINY
#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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
library(RColorBrewer)


dashboardPage(skin='green',
              dashboardHeader(title='Dashboard Test'),
              
              dashboardSidebar(
                width = 270,
                sidebarMenu(
                  menuItem('BIENVENIDA', tabName = 'welcome'),
                  menuItem('COMPARAR DATOS', tabName = 'cmpTab', icon = icon('code-compare')),
                  menuItem('TRANSFORMAR DATOS', tabName = 'trnsTab', icon = icon('table')),
                  menuItem('VISUALIZAR DATOS', tabName = 'visTab', icon = icon('bar-chart')),
                  menuItem('ANALIZAR DATOS', icon=icon('pie-chart'), tabName = 'estabInuseTab',
                           menuSubItem('#TODO1', tabName = 'TODO1Tab'),
                           menuSubItem('#TODO2', tabName = 'TODO2Tab'),
                           menuSubItem('#TODO3', tabName = 'TODO3Tab')
                  ),
                  htmlOutput(outputId = 'logo')
                )
              ),
              
              dashboardBody(
                tags$style(HTML("
                  .box.box-solid.box-primary>.box-header {
                    color:#fff;
                    background:#7b78a8
                                      }
                  .box.box-solid.box-primary{
                  border-bottom-color:#7b78a8;
                  border-left-color:#7b78a8;
                  border-right-color:#7b78a8;
                  border-top-color:#7b78a8;
                  }
                  .table-container {
                    overflow-x: auto;  /* Desplazamiento horizontal */
                    width: 100%;  
                  }
                  .dataTables_wrapper {
                    width: 100%;
                  }
                ")),
                tabItems(
                  tabItem(
                    tabName = 'welcome',
                    fluidRow(
                      column(12,
                         helpText(
                           div(HTML("Texto para añadir el disclaimer"))
                         )
                      )
                    )
                  ),
                  tabItem(
                    tabName = 'cmpTab',
                    column(
                      offset=0.5,
                      width = 7, 
                      fluidRow(
                        width = 5, 
                        fileInput('cmpLoad1', 'Selecciona el archivo de datos climatológicos (Origen X)', accept=c('.csv')),
                        helpText(
                          div(HTML("Solo admite los archivos <em>nombreArchivo.csv</em> generados por la estación meteorológica X."))
                        ),
                        br(),
                        fileInput('cmpLoad2', 'Selecciona el archivo de datos climatológicos (Origen Y)', accept=c('.csv')),
                        helpText(
                          div(HTML("Solo admite los archivos <em>nombreArchivo.csv</em> generados por la estación meteorológica Y."))
                        )
                      ),
                      br(), br(), br(), br(),
                      box(
                        width = 5, 
                        status = 'primary',
                        solidHeader = TRUE,
                        column(
                          offset=1,
                          width = 5, 
                          actionButton(inputId = 'cmpButton', label = 'Realizar comparación',icon = icon('play'))
                        )
                      )
                    )
                  ),
                  tabItem(
                    tabName = 'trnsTab',
                    column(
                      offset=0.5,
                      width = 4,
                      fluidRow(
                        fileInput('trnsLoad', 'Elige el archivo', accept=c('csv')),
                        helpText(
                          'Solo admite archivos csv.'
                        ),
                        br()
                      ),
                      box(
                        width = 15, 
                        status = 'primary',
                        title = 'Transformación', 
                        solidHeader = TRUE,
                        selectInput(inputId = 'trnsType',
                                    width = "70%",
                                    label = 'Origen de los datos a transformar',
                                    choices = c('Origen_1', 'Origen_2', 'Origen_3')
                        ),
                        column(
                          width = 6, 
                          fluidRow(column(3, actionButton(inputId = 'trnsButton', label = 'Transformar datos',icon = icon('play'))))
                        ),
                        column(
                          width = 6, 
                          fluidRow(column(3, downloadButton(outputId = 'trnsDownload','Descargar archivo'))) 
                        )
                      ),
                      fluidRow(
                        column(12,
                               htmlOutput(outputId = 'mensajeTrns')
                        )
                      )
                    ),
                    column(
                      width = 8,
                      h4('Previsualización de los datos'), 
                      div(class = "table-container",
                          DT::dataTableOutput('trnsLoadPreviewTable')
                      )
                    )
                  ),
                  tabItem(
                    tabName = 'visTab',
                    column(
                      offset=0.5,
                      width = 4, 
                      helpText(
                        div(HTML("Solo admite el dataset 'iris' manipulado en formato .csv."))
                      ),
                      fileInput('visLoad', 'Selecciona el archivo', accept=c('.csv')),
                      fluidRow(
                        column(
                          width = 12,
                          htmlOutput(outputId = 'mensajeVis')
                        )
                      ),
                      br(),
                      fluidRow(
                        column(
                          width = 3,
                          actionButton(inputId = 'visGenerarButton', label = 'Generar gráfico',icon = icon('play'))                          
                        )
                      ),
                      br(), br(), br(),
                      tabBox(
                        width = 10,
                        tabPanel(
                          'Ejes',
                          textInput(inputId = "visPlotTitle",
                                    label = "Título del gráfico",
                                    width = "70%",
                                    placeholder = "Introduce el título"
                          ),
                          radioButtons(inputId = 'visEjesType',
                                       label = 'Ejes: ',
                                       choices = c('Longitud Sépalo vs Anchura Sépalo',
                                                   'Longitud Pétalo vs Longitud Sépalo',
                                                   'Anchura Pétalo vs Anchura Sépalo')
                          )
                        ),
                        tabPanel(
                          "Color & Puntos",
                          sliderInput(inputId = 'visPlotSize',
                                      label = 'Tamaño de punto: ',
                                      value = 1.0,
                                      min = 0.5, max = 2.5,
                                      step = 0.1
                          ),
                          selectInput(inputId = 'visPlotSelec',
                                      label = 'Colorear por',
                                      choices = c('Ninguna', 'Species', 'Petal.Length.Classification', 'Sepal.Length.Classification', 'Area.Classification'))
                        ),
                        tabPanel(
                          'Filtrado',
                          selectInput(inputId = 'visFltrSelec',
                                      label = 'Filtrar por',
                                      choices = c('Ninguna', 'Species', 'Petal.Length.Classification', 'Sepal.Length.Classification', 'Area.Classification')),
                          selectInput(inputId = 'visFltrCrit',
                                      label = 'Seleccionar',
                                      choices = '<NONE>',
                                      multiple = TRUE,
                                      selected = ''),
                          fluidRow(
                            column(
                              offset = 1,
                              width = 5, 
                              actionButton(inputId = 'visFltrButton', label = 'Filtrar',icon = icon('filter'))
                            ),
                            column(
                              width = 5, 
                              actionButton(inputId = 'visFltrResetButton', label = 'Reset',icon = icon('refresh'))
                            )
                          )
                        ),
                        tabPanel(
                          'Comparar',
                          selectInput(inputId = 'visPlotTypeAgrup',
                                      label = 'Variable para comparar',
                                      width = "70%",
                                      choices = c('Ninguna', 'Species', 'Petal.Length.Classification', 'Sepal.Length.Classification', 'Area.Classification'),
                                      selected = 'Ninguna'
                          )
                        )
                      )
                    ),
                    column(
                      width = 8, 
                      box(
                        width = 12,
                        title = strong('Scatterplot'),
                        uiOutput(outputId = 'visSctrLayout'),
                        fluidRow(
                          column(
                            width = 6,
                            sliderInput(inputId = 'visSctrHeight',
                                        label = 'Plot Height',
                                        min = 200, max = 800, 
                                        step = 50, value = 500)
                          ),
                          column(
                            width = 6,
                            sliderInput(inputId = 'visSctrWidth',
                                        label = 'Plot Width',
                                        min = 300, max = 1000, 
                                        step = 50, value = 500)
                          )
                        )
                      )
                    )
                  ),
                  
                  tabItem(
                    tabName = 'TODO1Tab',
                    column(
                      br(), # añadido salto de línea
                      offset=0.5,
                      width = 5, 
                      fluidRow(
                        width = 3, 
                        fileInput('#TODO1Load', 'Elige el archivo', accept=c('.xlsx', '.xls')),
                        helpText(
                          'Solo admite archivos ___ (.xlsx).'
                        )
                      ),
                      br(), br(), br(),
                      box(
                        width = 8, 
                        status = 'primary',
                        title = 'Información', 
                        solidHeader = TRUE,
                        fluidRow(
                          column(
                            width = 12,
                            textInput(inputId = "#TODO1Variable1",
                                      label = "Variable 1",
                                      width = "70%",
                                      placeholder = "Introduce el dato"
                            ),
                            textInput(inputId = "#TODO1Variable2",
                                      label = "Variable 2",
                                      width = "70%",
                                      placeholder = "Introduce el dato"
                            )
                          ),
                          column(
                            width = 3, 
                            fluidRow(
                              column(5, actionButton(inputId = '#TODO1Button', label = 'Realizar análisis',icon = icon('play')))
                            )
                          )
                        )
                      )
                    )
                  ),
                  tabItem(
                    tabName = 'TODO2Tab'
                  ),
                  tabItem(
                    tabName = 'TODO3Tab'
                  )
                )
              )

)
