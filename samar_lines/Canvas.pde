class Canvas {
  PGraphics canvas;
  LocalFrame localFrame;
  LineGenerator line;

  ArrayList<Shape> shapes;
  
  Canvas(LocalFrame localFrame, float canvasScale) {
    canvasScale = canvasScale * (float(baseWidth)/float(width));
    canvas = createGraphics(int(width * canvasScale), int(height * canvasScale));
    line = new LineGenerator(round(random(width/4, width-width/4)), round(random(height/5, height-height/5)));
    this.localFrame = localFrame;
    shapes = new ArrayList<Shape>();
    canvas.smooth(8);
    
  }

  void drawCanvas() {
    // Update line
    line.update();

    // Render the line on the canvas
    line.render(canvas);
    
    // Handle shapes
    handleShapes();

    // Draw the canvas
    if (frameCount % 1 == 0) {
      background(canvasBackground);
      image(canvas,0,0,width,height);
    }

    // Send canvas to the secondary applet -> LocalFrame
    localFrame.setFrame(canvas, line.position);
  }

  int getWidth() {
    return canvas.width;
  }
  int getHeight() {
    return canvas.height;
  }

  void dispose() {
    this.dispose();
  }
  
  void addShape(){
    int x = round(random(line.position.x - (0.9*localFrame.w/2),line.position.x + (0.9*localFrame.w/2)));
    int y = round(random(line.position.y - (0.9*localFrame.h/2),line.position.y + (0.9*localFrame.h/2)));
    
    PVector position = new PVector(x,y);
    Shape s = new Shape(position, line.currentColor);
    
    shapes.add(s);
  }
  
  void handleShapes(){
   for(int i = 0; i < shapes.size(); i++){
     shapes.get(i).drawShape(canvas);  
   }
   
   for(int i = shapes.size() - 1; i >= 0; i--){
    if(shapes.get(i).toDelete) shapes.remove(i); 
   }
  }
   
}
