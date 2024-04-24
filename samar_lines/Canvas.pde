class Canvas {
  PGraphics pg;
  LineGenerator line;
  
  Canvas(int w, int h){
   pg = createGraphics(w,h); 
   line = new LineGenerator(w/2,h/2);
   
  }
  
  void drawCanvas(){
    line.move();
    pg.beginDraw();
    pg.fill(255,0,0);
    pg.noStroke();
    pg.rect(line.position.x,line.position.y,10,5);
    
    pg.endDraw();
    
    image(pg,line.position.x - pg.width/2 ,line.position.y - pg.height/2);
    
    noFill();
    stroke(0,0,0);  
    rect(line.position.x - pg.width/2, line.position.y - pg.height/2,pg.width,pg.height);
  }
}
