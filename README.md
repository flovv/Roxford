# Roxford
R Package for Image Recogntion using the Project Oxford API

See the the R/shiny [demo](https://flovv.shinyapps.io/image-shiny)


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

### Image obejct recognition 
```
visionkey = '' # different key
getVisionResponse("out/snap00169.png", visionkey)

getVisionResponseURL("http://sizlingpeople.com/wp-content/uploads/2015/10/Kim-Kardashian-2015-21.jpg", visionkey)

```


