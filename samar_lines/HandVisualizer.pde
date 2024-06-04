 
class HandVisualizer  {
  int w, h;
  float wScale = 1;
  float hScale = 1;
  
  PVector[] hands = null;
  PGraphics canvas;
  int handRadius = 24;
  
  float noiseOffset = 0; 

  HandVisualizer( int w, int h, float wScale, float hScale) {
    this.w = w;
    this.h = h;
    this.wScale = wScale;
    this.hScale = hScale;
    canvas = createGraphics(w, h);
  }
  
  

  void drawHandVisualizer(PApplet frame) {
    wScale = (float) w/frame.width;
    hScale = (float) h/frame.height;
    canvas = createGraphics(w, h);
    canvas.noSmooth();
    canvas.beginDraw();
      canvas.fill(255,0,255,100);
      canvas.noStroke();
      canvas.ellipse(w/2,h/2,20,20);
      drawHands();
    canvas.endDraw();
   
    frame.image(canvas,0,0,frame.width,frame.height);
    canvas.clear();
    noiseOffset += 0.01;
  }
  
  void drawHands(){
    hands = tracking.getHands();
    
   // Draw the shapes for the hannds
    if(hands != null){
      for(int i = 0; i < hands.length ; i++){
        float mappedX = map(hands[i].x, 0.0, float(tracking.captureWidth), w,0.0);
        float mappedY = map(hands[i].y, 0.0,float(tracking.captureHeight),h,0.0);
        canvas.fill(255,255,255,100);
        //canvas.ellipse(mappedX,mappedY,handRadius,handRadius);
        
        // Draw blob
        int numPoints = 30;  // Number of points around the blob
        PShape hand = createShape();
        
        hand.beginShape();
        hand.fill(255,255,255,100);
        float angleStep = TWO_PI / numPoints;
        for (int j = 0; j < numPoints; j++) {
          float angle = j * angleStep;
          float bx = cos(angle) * handRadius;
          float by = sin(angle) * handRadius;
    
          // Add some noise to make it look like a blob
          float noiseFactor = map(noise(bx * 0.1 + noiseOffset, by * 0.1 + noiseOffset), 0, 1, 0.5, 1);
          bx *= noiseFactor;
          by *= noiseFactor;
    
          hand.vertex(bx, by);
        }
        hand.endShape(CLOSE);
        canvas.shape(hand,mappedX,mappedY);
      }
    }
  }
}
