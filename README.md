# Roxford
R Package for Image Recogntion using the Microsoft's Cognitive Services API.
Microsoft's Cognitive Services were previously named "Project Oxford" 

See the the R/shiny [demo](https://flovv.shinyapps.io/image-shiny)

and [blog post](http://flovv.github.io/Image-Recognition/)

## Install
```
#install.packages("devtools")
require(devtools)
install_github("flovv/Roxford")
```

## Get API Keys
* Visit [www.projectoxford.ai/](https://www.projectoxford.ai/)
* sign in
* go to account settings --> my subscriptions

![Subsciptions page](https://raw.githubusercontent.com/flovv/Roxford/master/oxford.jpg)

## Usage
Every API (Face, Emotion, Vision, Video, ...) has a seperate API key. Hence, to use different functions you need to provide the "correct" key.

### Face detection & facial features
```
require(Roxford)
facekey = ''   #look it up on your subscription site

## using local images
getFaceResponse("out/snap00169.png", facekey)

## or providing a url to a remote local image
getFaceResponseURL("http://sizlingpeople.com/wp-content/uploads/2015/10/Kim-Kardashian-2015-21.jpg", facekey)

```

### Emotion detection
```
emotionkey = '' # different key
getEmotionResponse("out/snap00169.png", emotionkey)

getEmotionResponseURL("http://sizlingpeople.com/wp-content/uploads/2015/10/Kim-Kardashian-2015-21.jpg", emotionKey)
```

### Object recognition/classification 
```
visionkey = '' # different key
getVisionResponse("out/snap00169.png", visionkey)

getVisionResponseURL("http://sizlingpeople.com/wp-content/uploads/2015/10/Kim-Kardashian-2015-21.jpg", visionkey)

```

### Image labeling, tagging and description
```
visionkey = '' # different key
getDescriptionResponseURL("http://sizlingpeople.com/wp-content/uploads/2015/10/Kim-Kardashian-2015-21.jpg", visionkey)

getTaggingResponseURL("http://sizlingpeople.com/wp-content/uploads/2015/10/Kim-Kardashian-2015-21.jpg", visionkey)

getTaggingResponseURL("http://sizlingpeople.com/wp-content/uploads/2015/10/Kim-Kardashian-2015-21.jpg", visionkey)

## can  be used to classify with domain specific models provided by Microsoft.
# run  getDomainModels(visionkey) first to get a list with available models
getDomainModelResponseURL("http://sizlingpeople.com/wp-content/uploads/2015/10/Kim-Kardashian-2015-21.jpg", visionkey, 'celebreties')
```

There are always to function to access one API endpoint.
xyzURL(url,...) to provide a url as a string and just xyz(localImage,...) to provide a string to a local image.


