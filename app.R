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
             p("You can select a year range that you want to see.
              Also, you can select different regions and different types of plot."),
             p("In the ",
               strong("table"),
                "tab, you can select a year and month you only want to see."),
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
             mainPanel(plotOutput("scatterplot"),
                       textOutput("plot_text"))
    ),
    tabPanel("Table",
             sidebarPanel(
               sliderInput("year", "Year",
                           min = min(uah$year), max = max(uah$year),
                           value = mean(uah$year)),
               selectInput("month", "Month", unique(uah$month))
             ),
             mainPanel(
               dataTableOutput("table"),
               textOutput("table_text"))
    )
  )
)

server <- function(input, output) {
  
  plot_filtered <- reactive({
    uah %>%
      filter(year >= input$year_range[1], year <= input$year_range[2],
             region == input$region) %>%
      group_by(year) %>%
      summarize(mean_temp = mean(temp))
  })
  
  output$scatterplot <- renderPlot({
    if (input$plot_type == "Scatterplot") {
      plot_filtered() %>% 
      ggplot(aes(x = year, y = mean_temp)) +
        geom_point() +
        labs(title = paste0("Average Temperature by Year and Region (", input$region, ")"), 
            x = "Year", 
            y = "Average Temperature (°C)")
    } else if (input$plot_type == "Line Graph") {
      plot_filtered() %>% 
        ggplot(aes(x = year, y = mean_temp)) +
        geom_line() +
        labs(title = paste0("Average Temperature by Year and Region (", input$region, ")"), 
             x = "Year", 
             y = "Average Temperature (°C)")
    } else {
      plot_filtered() %>% 
        ggplot(aes(x = year, y = mean_temp)) +
        geom_col() +
        labs(title = paste0("Average Temperature by Year and Region (", input$region, ")"), 
             x = "Year", 
             y = "Average Temperature (°C)")
    }
  })
  
  table_filtered <- reactive({
    uah %>%
      filter(year == input$year, month == input$month)
  })
  
  output$table <- renderDataTable({
    table_filtered()
  })
  
  output$plot_text <- renderText({
    paste("Selected subset contains", nrow(plot_filtered()), "observations")
  })
  
  output$table_text <- renderText({
    paste("Selected subset contains", nrow(table_filtered()), "observations")
  })
}

shinyApp(ui = ui, server = server)
