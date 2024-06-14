class Canvas {
  PGraphics canvas;
  LocalFrame localFrame;
  LineGenerator line;
  
  ArrayList<Shape> shapes;
  
  Canvas(LocalFrame localFrame, float canvasScale){
   canvas = createGraphics(int(width* canvasScale),int(height *canvasScale)); 
   line = new LineGenerator(500,1000);
   this.localFrame = localFrame;
  }
  
  void drawCanvas(){
    // Update line 
    line.update();
    
    // Render the line on the canvas
    line.render(canvas);
    
    // Draw the canvas
    if(frameCount % 3 == 0){
      image(canvas,0,0,width,height);
    }

    // Send canvas to the secondary applet -> LocalFrame
    localFrame.setFrame(canvas,line.position);
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
