class Canvas {
  PGraphics canvas;
  LocalFrame localFrame;
  LineGenerator line;
  
  Canvas(int w, int h, LocalFrame localFrame){
   canvas = createGraphics(w,h); 
   line = new LineGenerator(1000,1000);
   this.localFrame = localFrame;
  }
  
  void drawCanvas(){
    // Update line 
    line.update();
    
    canvas.beginDraw();
      line.render(canvas);
    canvas.endDraw();
    image(canvas,0,0,width,height);
    
    localFrame.setFrame(canvas,line.position);
    
    // Draw square around the window
    noFill();
    stroke(0,0,0);
    rect(0,0,width,height);
  }
  
  void dispose(){
    this.dispose();
  }

}
