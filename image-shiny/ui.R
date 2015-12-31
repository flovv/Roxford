
require(shiny)


shinyUI(pageWithSidebar(
  headerPanel(title = 'Image Classification using Project Oxford',
              windowTitle = 'Image Classification using Project Oxford'),
  
  sidebarPanel(
    includeCSS('boot.css'),
    tabsetPanel(
      id = "tabs",
 #    tabPanel("Upload Image",
 #              fileInput('file1', 'Upload a PNG / JPEG File:')),
      tabPanel(
        "Use URL Input",
        textInput("url", "Image URL:", "http://i.telegraph.co.uk/multimedia/archive/01899/shriver-Schwarzene_1899483b.jpg"),
        helpText("press Classify to call the API, change the URL first if you want to classify another image."),
        actionButton("goButton", "Classify")
      )
    )
  ),
  
  mainPanel(
    h3("Image"),
    hr(),

     uiOutput("image"),
    hr(),
    
    h3("Face recognition/classification"),
    tags$hr(),
    tableOutput("res")
    
  )
))
