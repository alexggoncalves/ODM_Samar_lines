class Canvas {
  PGraphics canvas;
  LocalFrame localFrame;
  LineGenerator line;

  ArrayList<Shape> shapes;
  
  

  Canvas(LocalFrame localFrame, float canvasScale) {
    canvas = createGraphics(int(width * canvasScale), int(height * canvasScale));
    line = new LineGenerator(500, 1000);
    this.localFrame = localFrame;
    shapes = new ArrayList<Shape>();
  }

  void drawCanvas() {
    // Update line
    line.update();

    // Render the line on the canvas
    line.render(canvas);
    
    // Handle shapes
    handleShapes();

    // Draw the canvas
    if (frameCount % 10 == 0) {
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
    int x = round(random(line.position.x - localFrame.w/2,line.position.x + localFrame.w/2));
    int y = round(random(line.position.y - localFrame.h/2,line.position.x + localFrame.h/2));
    
    PVector position = new PVector(x,y);
    Shape s = new Shape(position, line.currentColor, 4,4);
    
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
