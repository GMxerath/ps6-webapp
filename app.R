library(shiny)
library(dplyr)
library(readr)
library(ggplot2)

uah <- read_delim("/Users/rayhwang/Desktop/INFO201/ps6-webapp/UAH-lower-troposphere-long.csv.bz2")

ui <- fluidPage(
  
  titlePanel("UAH dataset"),
  
  tabsetPanel(
    tabPanel("General Info",
             h1("This is a UAH dataset app."),
             p("This dataset shows the temperature of Earth's lower troposphere 
               by year(",
               em("1978 through 2023"),
               "), month, and regions."),
             p("In the ", 
              strong("plot"),
              "tab, it shows a plot shows a overall trend of temperature change."),
             p("you can select a year range that you want to see.
              Also, you can select different regions and different types of plot."),
             p("In the ",
               strong("table"),
                "tab, you can select a year range that you want to see.
                Also, you can select different regions and different types of plot."),
    ),
    tabPanel("Plot",
             sidebarPanel(
               sliderInput("year_range", "Year Range:", 
                           min = min(uah$year), max = max(uah$year),
                           value = c(min(uah$year), max(uah$year))),
               selectInput("region", "Region:", 
                           choices = unique(uah$region),
                           selected = "globe"),
               radioButtons("plot_type", "Plot type:", 
                            choices = c("Scatterplot", "Line Graph", "Bar Graph"),
                            selected = "Scatterplot")
             ),
             mainPanel(plotOutput("scatterplot"))
    ),
    tabPanel("Table",
             sidebarPanel(),
             mainPanel(tableOutput("table"))
    )
  )
)

server <- function(input, output) {
  
  data_filtered <- reactive({
    uah %>%
      filter(year >= input$year_range[1], year <= input$year_range[2],
             region == input$region) %>%
      group_by(year) %>%
      summarize(mean_temp = mean(temp))
  })
  
  output$scatterplot <- renderPlot({
    if (input$plot_type == "Scatterplot") {
      data_filtered() %>% 
      ggplot(aes(x = year, y = mean_temp)) +
        geom_point() +
        labs(title = paste0("Average Temperature by Year and Region (", input$region, ")"), 
            x = "Year", 
            y = "Average Temperature (°C)")
    } else if (input$plot_type == "Line Graph") {
      data_filtered() %>% 
        ggplot(aes(x = year, y = mean_temp)) +
        geom_line() +
        labs(title = paste0("Average Temperature by Year and Region (", input$region, ")"), 
             x = "Year", 
             y = "Average Temperature (°C)")
    } else {
      data_filtered() %>% 
        ggplot(aes(x = year, y = mean_temp)) +
        geom_col() +
        labs(title = paste0("Average Temperature by Year and Region (", input$region, ")"), 
             x = "Year", 
             y = "Average Temperature (°C)")
    }
  })
  
  output$table <- renderTable({
    
  })
}


shinyApp(ui = ui, server = server)

