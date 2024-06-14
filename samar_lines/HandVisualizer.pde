 
class HandVisualizer  {
  int w, h;
  int displayW;
  int displayH;
  float frameScale; 
  
  ArrayList<Hand> hands = null;
  PGraphics canvas;

  HandVisualizer(int displayW, int displayH,  float frameScale) {
    this.frameScale = frameScale;
    this.displayW = displayW-1;
    this.displayH = displayH;
    this.w = int(displayW * frameScale);
    this.h = int(displayH * frameScale);
    
    canvas = createGraphics(w, h);
    //canvas.noSmooth();
  }
  
  void drawHandVisualizer(PApplet frame) {
    canvas = createGraphics(w, h);
    
    canvas.ellipseMode(CENTER);
    canvas.beginDraw();
      canvas.fill(255,0,255,100);
      canvas.noStroke();
      canvas.pushMatrix();
      canvas.translate(w/2,h/2);
      canvas.ellipse(0,0,16,16);
      canvas.popMatrix();
      
      
      drawHands();
    canvas.endDraw();
   
    frame.image(canvas,0,0,frame.width,frame.height);
    canvas.clear();
    
  }
  
  void drawHands(){
    hands = tracking.getHands();
    
   // Draw the shapes for the hands
    if(hands != null){
      for(int i = 0; i < hands.size() ; i++){
        hands.get(i).drawHand(canvas);
      }
    }
  }
}
