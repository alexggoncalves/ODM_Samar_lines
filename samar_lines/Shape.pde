class Shape {
  PVector position;
  float turnRate = PI/14;
  float initialAngle;
  float angle;
  float turnAmount = 0;
  float totalTurnAmount;

  int radius;
  int ringWidth;
  color shapeColor;

  boolean toDelete = false;

  Shape(PVector position, color shapeColor) {
    this.position = position;
    this.radius = int(random(6,14));
    this.initialAngle = random(0, TWO_PI);
    this.angle = initialAngle;
    this.shapeColor = shapeColor;
    this.totalTurnAmount = floor(random(1, 4)) * HALF_PI;
    this.ringWidth = this.radius;
  }

  void drawShape(PGraphics canvas) {
    if (turnAmount < totalTurnAmount) {
      canvas.beginDraw();
        canvas.pushMatrix();
          canvas.translate(position.x,position.y);
          canvas.rotate(angle);
          canvas.translate(radius,0);
          canvas.rectMode(CENTER);
          canvas.fill(shapeColor);
          canvas.rect(0,0,ringWidth,5,1);
        canvas.popMatrix();
      canvas.endDraw();

      angle += turnRate;
      turnAmount += abs(turnRate);
    } else {
      toDelete = true;
    }
  }
  
  boolean isToDelete(){
   return toDelete; 
  }
}
