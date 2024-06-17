class Hand {
  float x,y;
  
  boolean updated;
  boolean onTimeout = false;
  boolean remove = false;
  
  final int timeOutTime = 10;
  int timeOutStart = 0;
  
  float handSize;
  float handSizeMultiplier = 0.1;
  int numPoints = 30;
  
  PVector mappedPosition = new PVector(0,0);
  
  float noiseOffset = 0;
  PVector headingVector = new PVector(0,0);
  
  Hand(PVector position, float size){
    this.x = position.x;
    this.y = position.y;
    this.handSize = size;
    updated = true;
  }
  
  void setPosition(PVector position){
    this.x = position.x;
    this.y = position.y;
    updated = true;
  }
  
  void setSize(float size){
    this.handSize = size;
  }
  
  float distanceTo(PVector position){
    return dist(x,y,position.x,position.y);
  }
  
  PVector mapPosition(float xMin, float xMax, float yMin, float yMax){
     return new PVector(
                 map(x,0,tracking.captureWidth,xMin,xMax),
                 map(y,0,tracking.captureHeight,yMin,yMax)
                 );
  }
  
  void startTimeout(){
    onTimeout = true;
    timeOutStart = millis();
  }
  
  boolean isItOver(){
    if(millis() - timeOutStart > timeOutTime){
      return true;
    } else return false;
  }
  
  PVector getPosition(){
   return new PVector(x,y); 
  }
  
  void drawHand(PGraphics canvas){
    mappedPosition = mapPosition(canvas.width,0,canvas.height,0);
    
    canvas.fill(255,255,255,100);
        
    // Draw blob
    PShape hand = createShape();
    hand.beginShape();
      hand.fill(255,255,255,100);
      float angleStep = TWO_PI / numPoints;
      for (int j = 0; j < numPoints; j++) {
        float angle = j * angleStep;
        float bx = cos(angle) * (handSize*handSizeMultiplier);
        float by = sin(angle) * (handSize*handSizeMultiplier);
    
        // Add some noise to make it look like a blob
        float noiseFactor = map(noise(bx * 0.1 + noiseOffset, by * 0.1 + noiseOffset), 0, 1, 0.5, 1);
        bx *= noiseFactor;
        by *= noiseFactor;
    
        hand.vertex(bx, by);
      }
      hand.endShape(CLOSE);
      canvas.shape(hand,mappedPosition.x,mappedPosition.y);
        
      noiseOffset += 0.03;
  }
}
