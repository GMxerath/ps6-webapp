library(shiny)
library(ggplot2)

# Define UI for application
ui <- fluidPage(
  
  # Application title
  titlePanel("mtcars dataset"),
  
  # Sidebar with options
  sidebarLayout(
    sidebarPanel(
      selectInput("x_var", "X Variable", choices = colnames(mtcars)),
      selectInput("y_var", "Y Variable", choices = colnames(mtcars)),
      selectInput("plot_type", "Plot Type", choices = c("scatter", "line"))
    ),
    
    # Show a plot and table on different tabs
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", plotOutput("scatterplot")),
        tabPanel("Table", tableOutput("table"))
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Render scatterplot
  output$scatterplot <- renderPlot({
    ggplot(data = mtcars, aes_string(x = input$x_var, y = input$y_var)) +
      geom_point() +
      ggtitle(input$plot_type)
  })
  
  # Render table
  output$table <- renderTable({
    mtcars[, c(input$x_var, input$y_var)]
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
