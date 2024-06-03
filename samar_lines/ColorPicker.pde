class ColorPicker {
  PImage gradient;
  
  boolean isInTransition;
  float transitionRate = 0.002;
  float gradientPosition = 0; // from 0 to 1
  int colorAmount = 5;
  float gradientStep;
  
  float transitionProgress = 0;
  int randomTimeInterval;
  int lastTransition;
  int minTimeInterval = 2000;
  int maxTimeInterval = 10000;
  
  ColorPicker(String gradientSrc){
    gradient = loadImage(gradientSrc);
    gradient.loadPixels();
    
    // Set transition variables
    isInTransition = false;
    lastTransition = millis();
    randomTimeInterval = getRandomTimeInterval();
    
    gradientStep = (gradient.width/colorAmount)/((float)gradient.width);
  }
  
  void update(){
    if(millis() - lastTransition >= randomTimeInterval){
     isInTransition = true;
     
     lastTransition = millis();
     randomTimeInterval = getRandomTimeInterval();
    }
    
    if(isInTransition){
      gradientPosition += transitionRate;
      if(gradientPosition >= 1) gradientPosition = 0;
      
      transitionProgress += transitionRate;
      
      if(transitionProgress >= gradientStep){
        isInTransition = false;
        transitionProgress = 0;
      }
    }
    
    drawDebug();
  }
  
  void drawDebug(){
    image(gradient,0,0);
    fill(0,0,0);
    rectMode(CENTER);
    rect(gradientPosition * gradient.width,50,10,20);
    rectMode(CORNERS);
  }
  
  color getCurrentColor(){
   return gradient.get(floor(gradient.width * gradientPosition),0);
  }
  
  int getRandomTimeInterval() {
    return int(random(minTimeInterval,maxTimeInterval));
  }
  
  void dispose(){
    this.dispose();
  }
}
