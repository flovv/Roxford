
############# Mircosoft Image recognition API - LIB!

##########################################################

################################################################

###################### private KEYS

visionKey = ''
faceKEY = ''
emotionKey = ''
videoKey = ""

############################################################
#' @title helper function to load required packages
#' @description Thanks to http://stackoverflow.com/questions/4090169/elegant-way-to-check-for-missing-packages-and-install-them
#'
#' @param non

#' @return non

checkAndLoadPackages <- function(){
  list.of.packages <- c("plyr", "httr", "rjson")
  new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)) install.packages(new.packages)
  
  require(plyr)
  require(httr)
  require(rjson)
}


############################################################
#' @title helper function fto parse the json results to data frames 
#' @description  Microsoft  API returns (well-)structured JSON, this function parses it into data frames
#'
#' @param json text

#' @return data frame from json



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

################## OCR recognition! ##################
#' @title OCR recognition function
#' @description upload image, get text back!
#'
#' @param path to local image
#' @param key to vision api 
#' @param language settings default is DE
#' @export
#' @return data frame of text blocks
#' @examples getOCRResponse("out/snap00169.png", visionKey)

getOCRResponse <- function(img.path, visionKey, language="de"){
  ##de  en
  checkAndLoadPackages()
  faceURL = paste0("https://api.projectoxford.ai/vision/v1/ocr?detectOrientation=true&language=",language)
  
  mybody = upload_file(img.path)
  
  ocrResponse = POST(
    url = faceURL, 
    content_type('application/octet-stream'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = visionKey)),
    body = mybody,
    encode = 'multipart'
  )
  
  con <- content(ocrResponse)
  regions <- con$regions

  asFrame <- do.call("rbind.fill", lapply(regions[[1]]$lines, as.data.frame))
  return(asFrame)
}

#df <- getOCRResponse("out/snap00169.png", visionKey)

############################################################
#' @title get face attributes, age, gender, faceid
#' @description upload image, get text back!
#'
#' @param path to local image
#' @param key for the face api 

#' @export
#' @return data frame with face attributes, age, gender, faceid
#' @examples getFaceResponse("out/snap00169.png", facekey)
#' 
getFaceResponse <- function(img.path, key){
  checkAndLoadPackages()
  faceURL = "https://api.projectoxford.ai/face/v1.0/detect?returnFaceId=true&returnFaceAttributes=age,gender,smile,facialHair,headPose"
  
  mybody = upload_file(img.path)
  
  faceResponse = POST(
    url = faceURL, 
    content_type('application/octet-stream'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = key)),
    body = mybody,
    encode = 'multipart'
  )
  
 # con <- content(faceResponse)[[1]]
#  df <- data.frame(t(unlist(con$faceAttributes)))
  
  better <- dataframeFromJSON(content(faceResponse))
  # cn <- c("faceAttributes.smile", "faceAttributes.gender", "faceAttributes.age", "faceAttributes.facialHair.moustache", "faceAttributes.facialHair.beard", "faceAttributes.facialHair.sideburns")
  df <-   better
  
  return(df) 
}
## URL based!
############################################################
#' @title get face attributes, age, gender, faceid
#' @description url to image, get text back!
#'
#' @param url to image
#' @param key for the face api 

#' @export
#' @return data frame with face attributes, age, gender, faceid
#' @examples getFaceResponseURL("http://sizlingpeople.com/wp-content/uploads/2015/10/Kim-Kardashian-2015-21.jpg", facekey)
#' 
getFaceResponseURL <- function(img.url, key){
  checkAndLoadPackages()
  faceURL = "https://api.projectoxford.ai/face/v1.0/detect?returnFaceId=true&returnFaceAttributes=age,gender,smile,facialHair,headPose"
  
  mybody = list(url = img.url)
  
  faceResponse = POST(
    url = faceURL, 
    content_type('application/json'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = key)),
    body = mybody,
    encode = 'json'
  )
  
  #con <- content(faceResponse)[[1]]
  df <- dataframeFromJSON(content(faceResponse))

  return(df) 
}
##########################################################################  
############################################################
#' @title image recognition and object identification 
#' @description upload image, a description of the image back
#'
#' @param path to local image
#' @param key for the vision api 

#' @export
#' @return data frame with image attributes
#' @examples getVisionResponse("out/snap00169.png", facekey)
#'
getVisionResponse <- function(img.path, key){
  checkAndLoadPackages()
  visionURL = "https://api.projectoxford.ai/vision/v1/analyses?visualFeatures=all"
  
  mybody = upload_file(img.path)
  
  visionResponse = POST(
    url = visionURL, 
    content_type('application/octet-stream'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = key)),
    body = mybody,
    encode = 'multipart'
  )
  
  con <- content(visionResponse)
  
 # df <- data.frame(t(unlist(con$categories)))
 # df2 <- data.frame(t(unlist(con$color)))
  
  better <- dataframeFromJSON(content(visionResponse))
  
  return(cbind(df,df2))
}

########################################################################## 
# URL based
#' @title image recognition and object identification 
#' @description provide url to image, a description of the image back
#'
#' @param url to image
#' @param key for the vision api 

#' @export
#' @return data frame with image attributes
#' @examples getVisionResponseURL("http://sizlingpeople.com/wp-content/uploads/2015/10/Kim-Kardashian-2015-21.jpg", facekey)
#'
getVisionResponseURL <- function(img.url, key){
  checkAndLoadPackages()
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
#########################################################################
############################################################
#' @title emotion detection in images with human faces
#' @description upload image, get emotion scores back for each face.
#'
#' @param path to local image
#' @param key for the emotion api  

#' @export
#' @return data frame with emotion scores
#' @examples getEmotionResponse("out/snap00169.png", emotionkey)
#'
getEmotionResponse <- function(img.path, key){
  checkAndLoadPackages()
  emotionURL = "https://api.projectoxford.ai/emotion/v1.0/recognize"
  
  mybody = upload_file(img.path)
  
  emotionResponse = POST(
    url = emotionURL, 
    content_type('application/octet-stream'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = key)),
    body = mybody,
    encode = 'multipart'
  )
  
  df <- dataframeFromJSON(content(emotionResponse))
  
  return(df)
}
## URL based!
##########################################################################
#' @title emotion detection in images with a human faces
#' @description provide an url to an image, get emotion scores back for each face.
#'
#' @param url to image
#' @param key for the emotion api  

#' @export
#' @return data frame with emotion scores
#' @examples getEmotionResponseURL("http://sizlingpeople.com/wp-content/uploads/2015/10/Kim-Kardashian-2015-21.jpg", emotionKey)
#'
getEmotionResponseURL <- function(img.url, key){
  checkAndLoadPackages()
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
####################################################################################


####################################################################################
## video Detect!
#' @title helper function for the video API
#' @description  the Video API needs two calls, one to upload the video, a second to get the results after processing, this is the second call.
#'
#' @param path to local video
#' @param key for the video api 

#' @export
#' @return data frame with video results
#' @examples getVideoResponse("video.mp4", videoKey)
#'
getVideoResultResponse <- function(operationURL, key){
  checkAndLoadPackages()
  second <- GET(
    url=operationURL,
    content_type('application/json'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = key)),
    encode = 'json'
  )
  
  return(content(second))
}

####################################################################################
############ video detect!

#' @title main call to video API
#' @description  might take a while
#'
#' @param path to local video
#' @param key for the video api 

#' @export
#' @return data frame with video results
#' @examples getVideoResponse("video.mp4", videoKey)
#'
getVideoResponse <- function(video.path, key){
  checkAndLoadPackages()
  videoURL = "https://api.projectoxford.ai/video/v1.0/trackface"
  
  mybody = upload_file(video.path)
  
  videoResponse = POST(
    url = videoURL, 
    content_type('application/octet-stream'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = key)),
    body = mybody,
    encode = 'multipart'
  )
  
  operationURL <- videoResponse$headers$`operation-location`
  ### second call!
 
  while(con$status == "Running"){
    print("Waiting for a result ... ")
    Sys.sleep(4)
    con <- getVideoResultResponse(operationURL, key)
    
  }
  
  o <- fromJSON(con$processingResult, method='C')
  return(o)
}

### works!
#ooo <- getVideoResponse("05_2015_Deka_15_ASS_DBA_UPDATE.mp4", videoKey)
####################################################################################
#' @title main call to video motion API
#' @description  might take a while
#'
#' @param path to local video
#' @param key for the video api 

#' @export
#' @return data frame with video motion results
#' @examples getVideoMotion("video.mp4", videoKey)
#'
getVideoMotion <- function(video.path, key){
  checkAndLoadPackages()
  videoMotionURL = "https://api.projectoxford.ai/video/v1.0/detectmotion"
  
  mybody = upload_file(video.path)
  
  motionResponse = POST(
    url = videoMotionURL, 
    content_type('application/octet-stream'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = videoKey)),
    body = mybody,
    encode = 'multipart'
  )
  
  operationURL <- motionResponse$headers$`operation-location`
  
  while(con$status == "Running"){
    print("Waiting for a result ... ")
    Sys.sleep(4)
    con <- getVideoResultResponse(operationURL, key)
    
  }
  
  o <- fromJSON(con$processingResult, method='C')
  return(o)
}

###########################################################################




