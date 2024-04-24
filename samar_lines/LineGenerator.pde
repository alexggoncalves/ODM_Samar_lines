class LineGenerator {
  PVector position;
  color currentColor;
  float angle;
  float speed;
  
  LineGenerator(float initX, float initY){
    this.position = new PVector(initX,initY);
    this.currentColor = color(255,0,0);
  }
  void move(){
    position.x += cos(angle);
    position.y *= sin(angle);
  }
}
