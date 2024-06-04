 
class HandVisualizer  {
  int w, h;
  float wScale = 1;
  float hScale = 1;
  
  ArrayList<Hand> hands = null;
  PGraphics canvas;

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
