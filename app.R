library(shiny)
library(tidyverse)
library(ggplot2)

uah <- read.delim("/Users/rayhwang/Desktop/INFO201/ps6-webapp/UAH-lower-troposphere-long.csv.bz2")

ui <- fluidPage(
  
  titlePanel("UAH dataset"),
  
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      tabsetPanel(
        tabPanel("General Info", textOutput("info")),
        tabPanel("Plot", plotOutput("scatterplot")),
        tabPanel("Table", tableOutput("table"))
      )
    )
  )
)

server <- function(input, output) {
  
  output$scatterplot <- renderPlot({
    
  })
  
  output$table <- renderTable({
    
  })
}


shinyApp(ui = ui, server = server)

