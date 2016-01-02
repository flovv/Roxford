
require(shiny)

require(plyr)
require(httr)
require(rjson)

###################### private KEYS, need to be added

visionKey = ''
faceKEY = ''
emotionKey = ''
videoKey = ""

############################################ helper!
dataframeFromJSON <- function(l) {
  l1 <- lapply(l, function(x) {
    x[sapply(x, is.null)] <- NA
    unlist(x)
  })
  keys <- unique(unlist(lapply(l1, names)))
  l2 <- lapply(l1, '[', keys)
  l3 <- lapply(l2, setNames, keys)
  res <- data.frame(do.call(rbind, l3))
  return(res)
}

################################################

#### URL based!
############################################################
getFaceResponseURL <- function(img.url, key){
  
  faceURL = "https://api.projectoxford.ai/face/v1.0/detect?returnFaceId=true&returnFaceAttributes=age,gender,smile,facialHair,headPose"
  
  mybody = list(url = img.url)
  
  faceResponse = POST(
    url = faceURL, 
    content_type('application/json'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = key)),
    body = mybody,
    encode = 'json'
  )
  
  con <- content(faceResponse)[[1]]
  #df <- data.frame(t(unlist(con$faceAttributes)))
  df <- dataframeFromJSON(content(faceResponse))
  # better <- dataframeFromJSON(content(faceResponse))
   cn <- c("faceId","faceAttributes.smile", "faceAttributes.gender", "faceAttributes.age", "faceAttributes.facialHair.moustache", "faceAttributes.facialHair.beard", "faceAttributes.facialHair.sideburns")
  # better[,cn]
  
  return(df[,cn]) 
}
##########################################################################  
getVisionResponseURL <- function(img.url, key){
  
  visionURL = "https://api.projectoxford.ai/vision/v1/analyses?visualFeatures=all"
  
  mybody = list(url = img.url)
  
  visionResponse = POST(
    url = visionURL, 
    content_type('application/json'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = key)),
    body = mybody,
    encode = 'json'
  )
  
  con <- content(visionResponse)
  
  df <- data.frame(t(unlist(con$categories)))
  df2 <- data.frame(t(unlist(con$color)))
  
  better <- dataframeFromJSON(content(visionResponse))
  
  return(cbind(df,df2))
}
########################################################################## 
getEmotionResponseURL <- function(img.url, key){
  
  emotionURL = "https://api.projectoxford.ai/emotion/v1.0/recognize"
  
  mybody = list(url = img.url)
  
  emotionResponse = POST(
    url = emotionURL, 
    content_type('application/json'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = key)),
    body = mybody,
    encode = 'json'
  )
  
  df <- dataframeFromJSON(content(emotionResponse))
  
  return(df)
}

########################################################################## ########################################################################## 
########################################################################## 

baseURL <- "http://i.telegraph.co.uk/multimedia/archive/01899/shriver-Schwarzene_1899483b.jpg"
df <- read.csv2("base.csv")
df <- df[,  c("faceId","faceAttributes.smile", "faceAttributes.gender", "faceAttributes.age", "faceAttributes.facialHair.moustache", "faceAttributes.facialHair.beard", "faceAttributes.facialHair.sideburns")]

shinyServer(function(input, output) {
  
  ntext <- eventReactive(input$goButton, {
    print(input$url)
    if (input$url == "http://") {
      baseURL
    } else {
      baseURL <<- input$url 
    }
  })
  
  getURL <- reactive({
    if (input$url == "http://") {
      baseURL
    } else {
      input$url
    }
  })


  output$image <- renderUI({
    url <- getURL()
    HTML(paste0('<img src="', url ,'" /> '))
  })
  
  ##########################################
  v <- reactiveValues(doPlot = FALSE)
  
  observeEvent(input$goButton, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v$doPlot <- input$goButton
  })
  
  output$res <- renderTable({

    if (v$doPlot == FALSE) return()
    
    #print("go!")
    isolate({
      
     getFaceResponseURL(getURL(), faceKEY)
    
    })
    
  })
  
})
