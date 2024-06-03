class Canvas {
  PGraphics canvas;
  LocalFrame localFrame;
  LineGenerator line;
  
  Canvas(int w, int h, LocalFrame localFrame){
   canvas = createGraphics(w,h); 
   line = new LineGenerator(500,1000);
   this.localFrame = localFrame;
  }
  
  void drawCanvas(){
    // Update line 
    line.update();
    
    // Render the line on the canvas
    line.render(canvas);
    
    // Draw the canvas
    image(canvas,0,0,width,height);
    
    // Send canvas to the secondary applet -> LocalFrame
    localFrame.setFrame(canvas,line.position);
    
    // Draw square around the window
    //noFill();
    //stroke(0,0,0);
    //rect(line.position.x,line.position.y,width/canvasScale,height/canvasScale);
  }
  
  int getWidth(){
    return canvas.width;
  }
  int getHeight(){
    return canvas.height;
  }
  
  void dispose(){
    this.dispose();
  }

}
