# Load required libraries
library(shiny)
library(ggplot2)
library(dplyr)

# Define UI
ui <- fluidPage(
    
    # App title
    titlePanel("Scatter Plot App"),
    
    # Sidebar with file input and input selectors
    sidebarLayout(
        sidebarPanel(
            # File input
            fileInput("file", "Select CSV file"),
            
            # Selectors for x-axis, y-axis, and color
            selectInput("x", "X-axis", choices = ""),
            selectInput("y", "Y-axis", choices = ""),
            selectInput("color", "Color", choices = ""),
            
            # Sliders for min and max values of inputs and color intensity
            sliderInput("xmin", "X-axis Min", min = 0, max = 1, value = 0 , step = 0.01),
            sliderInput("xmax", "X-axis Max", min = 0, max = 10, value = 10, step = 0.5),
            sliderInput("ymin", "Y-axis Min", min = 0, max = 1, value = 0 , step = 0.01),
            sliderInput("ymax", "Y-axis Max", min = 0, max = 10, value = 10 , step = 0.5),
            sliderInput("colorIntensity", "Color Intensity", min = 0, max = 1, value = 0.5, step = 0.01),
            sliderInput("colormin", "Color Min", min = 0, max = 1, value = 0 , step = 0.01),
            sliderInput("colormax", "Color Max", min = 0, max = 10, value = 10 , step = 0.5)
        ),
        
        # Main panel with scatter plot
        mainPanel(
            plotOutput("plot")
        )
    )
)

# Define server
server <- function(input, output, session) {
    
    # Read CSV file and store in data frame
    data <- reactive({
        req(input$file)
        read.csv(input$file$datapath)
    })
    
    # Update selector choices based on data frame headers
    observe({
        updateSelectInput(session, "x", choices = colnames(data()))
        updateSelectInput(session, "y", choices = colnames(data()))
        updateSelectInput(session, "color", choices = c("", colnames(data())))
    })
    
    # Filter data based on user inputs
    filteredData <- reactive({
        req(input$x, input$y, input$color)
        data() %>%
            filter(!!sym(input$x) >= input$xmin,
                   !!sym(input$x) <= input$xmax,
                   !!sym(input$y) >= input$ymin,
                   !!sym(input$y) <= input$ymax,
                   !!sym(input$color) >= input$colormin,
                   !!sym(input$color) <= input$colormax)
    })
    
    # Generate scatter plot
    output$plot <- renderPlot({
        req(input$x, input$y, input$color)
        
        ggplot(filteredData(), aes_string(x = input$x, y = input$y, color = input$color)) +
            geom_point(size = 2, alpha = input$colorIntensity) +
            #geom_vline(xintercept = round(median( input$x), 0), linetype = "dashed") +
            #geom_hline (yintercept = round(median(input$y), 0), linetype = "dashed") +
            scale_color_gradient2(midpoint = 1.25, low = "blue", mid = "white",
                                  high = "red", space = "Lab" ) + theme_bw()
    })
}

# Run app
shinyApp(ui, server)
