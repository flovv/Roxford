
## first Extension to the Roxford Package ... added various function for image classification and labeling
## https://www.microsoft.com/cognitive-services/

# Computer Vision API
## Describe
##########################################################################
# URL based
#' @title image description
#' @description provide url to image, get a description of the image back
#'
#' @param url to image
#' @param key for the vision api

#' @export
#' @return data frame with image description
#' @examples getDescriptionResponseURL("http://sizlingpeople.com/wp-content/uploads/2015/10/Kim-Kardashian-2015-21.jpg", visionKey)
#'
getDescriptionResponseURL <- function(img.url, key, maxCandidates=3, region="westus"){
  checkAndLoadPackages()
  #.api.cognitive.microsoft.com/vision/v1.0/describe[?maxCandidates]
  #visionURL = "https://westeurope.api.cognitive.microsoft.com/vision/v1.0/analyze?visualFeatures=Categories&details={string}&language=en"
  visionURL = paste0(getBaseURL(region),"vision/v1.0/describe?maxCandidates=",maxCandidates)
  
  
  mybody = list(maxCandidates = maxCandidates, url = img.url)

  visionResponse = POST(
    url = visionURL,
    content_type('application/json'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = key)),
    body = mybody,
    encode = 'json'
  )

  #con <- content(visionResponse)
  checkForError(visionResponse)

  better <- dataframeFromJSON(content(visionResponse))

  return(better)
}

##########################################################################
# path based
#' @title image description
#' @description provide path to image, get a description of the image back
#'
#' @param url to image
#' @param key for the vision api

#' @export
#' @return data frame with image description
#' @examples getDescriptionResponse('out/snap00169.png', visionKey, maxCandidates)
#'
getDescriptionResponse <- function(img.path, key, maxCandidates=3, region="westus"){
  checkAndLoadPackages()

  visionURL = paste0(getBaseURL(region),"vision/v1.0/describe?maxCandidates=",maxCandidates)

  mybody = upload_file(img.path)

  visionResponse = POST(
    url = visionURL,
    content_type('application/json'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = key)),
    body = mybody,
    encode = 'json'
  )

  #con <- content(visionResponse)
  checkForError(visionResponse)

  better <- dataframeFromJSON(content(visionResponse))

  return(better)
}



##########################################################################
# URL based
#' @title image tags
#' @description provide url to image, get a tags/labels back
#'
#' @param url to image
#' @param key for the vision api

#' @export
#' @return data frame with image description
#' @examples getTaggingResponseURL("http://sizlingpeople.com/wp-content/uploads/2015/10/Kim-Kardashian-2015-21.jpg", visionKey)
#'
getTaggingResponseURL <- function(img.url, key, region="westus"){
  checkAndLoadPackages()

  visionURL = paste0(getBaseURL(region),"vision/v1.0/tag")

  mybody = list(url = img.url)

  visionResponse = POST(
    url = visionURL,
    content_type('application/json'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = key)),
    body = mybody,
    encode = 'json'
  )

  checkForError(visionResponse)
  
  #con <- content(visionResponse)
  better <- dataframeFromJSON(content(visionResponse))
  return(better)
}
##########################################################################
#' @title tags images
#' @description provide  image, get a tags/labels back
#'
#' @param image
#' @param key for the vision api

#' @export
#' @return data frame with image description
#' @examples getTaggingResponseURL("out/image.png", visionKey)
#'
getTaggingResponse <- function(img.path, key, region="westus"){
  checkAndLoadPackages()

  visionURL = paste0(getBaseURL(region),"vision/v1.0/tag")

  mybody = upload_file(img.path)

  visionResponse = POST(
    url = visionURL,
    content_type('application/json'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = key)),
    body = mybody,
    encode = 'json'
  )

  checkForError(visionResponse)
  
  #con <- content(visionResponse)
  better <- dataframeFromJSON(content(visionResponse))
  return(better)
}

####################
##########################################################################
#' @title get currently available domain specific models!
#' @description provide visionkey to get available models
#'
#' @param key for the vision api

#' @export
#' @return data frame with domain specific models
#' @examples getDomainModels(visionKey)
#'
###
getDomainModels <- function(key, region="westus"){
  checkAndLoadPackages()
  visionURL = paste0(getBaseURL(region),"vision/v1.0/models")

  visionResponse = GET(
    url = visionURL,
    content_type('application/json'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = key)),
    encode = 'json'
  )

  checkForError(visionResponse)
  
  #con <- content(visionResponse)
  better <- dataframeFromJSON(content(visionResponse))
  return(better)
}


###
##########################################################################
# URL based
#' @title get a model based response back
#' @description provide a specific model (e.g. 'celebrities') and get the classification back
#'
#' @param model see getDomainModels()
#' @param key for the vision api

#' @export
#' @return data frame model specific features
#' @examples getDomainModelResponseURL(img.url, visionKey, model)
#'
###
getDomainModelResponseURL <- function(img.url, key, model="celebrities", region="westus"){
  checkAndLoadPackages()

  visionURL = paste0(getBaseURL(region),"vision/v1.0/models/",model,"/analyze")

  mybody = list(url = img.url)

  visionResponse = POST(
    url = visionURL,
    content_type('application/json'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = key)),
    body = mybody,
    encode = 'json'
  )
  
  checkForError(visionResponse)

  #con <- content(visionResponse)
  better <- dataframeFromJSON(content(visionResponse))
  return(better)
}


#' @title get a model based response back
#' @description provide a specific model (e.g. 'celebrities') and get the classification back
#'
#' @param image path
#' @param key for the vision api
#' @param model see getDomainModels()
#'
#' @export
#' @return data frame model specific features
#' @examples getDomainModelResponseURL("out/image.png", visionKey, model)
#'
###
getDomainModelResponse <- function(img.path, key, model="celebrities",region="westus"){
  checkAndLoadPackages()

  visionURL = paste0(getBaseURL(region),"vision/v1.0/models/",model,"/analyze")

  mybody = upload_file(img.path)

  visionResponse = POST(
    url = visionURL,
    content_type('application/json'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = key)),
    body = mybody,
    encode = 'json'
  )


  checkForError(visionResponse)
  
  #con <- content(visionResponse)
  better <- dataframeFromJSON(content(visionResponse))
  return(better)
}


### create thumbnail
#https://api.projectoxford.ai/vision/v1.0/generateThumbnail[?width][&height][&smartCropping]




