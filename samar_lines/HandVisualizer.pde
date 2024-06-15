class HandVisualizer {
  int w, h;
  int displayW;
  int displayH;
  float frameScale;

  ArrayList<Hand> hands = null;
  PGraphics canvas;
  
  LineGenerator line = null;

  PVector averageHandVector = new PVector(0, 0);

  HandVisualizer(int displayW, int displayH, float frameScale) {
    this.frameScale = frameScale;
    this.displayW = displayW-1;
    this.displayH = displayH;
    this.w = int(displayW * frameScale);
    this.h = int(displayH * frameScale);

    canvas = createGraphics(w, h);
  }

  void drawHandVisualizer(PApplet frame) {
    if (line == null) {
      line = fullCanvas.line;
    }

    canvas = createGraphics(w, h);

    canvas.ellipseMode(CENTER);
    canvas.beginDraw();
    canvas.fill(255, 0, 255, 100);
    canvas.noStroke();
    canvas.pushMatrix();
    canvas.translate(w/2, h/2);
    //canvas.ellipse(0, 0, 8, 8);
    canvas.strokeWeight(4);
    canvas.stroke(255, 255, 255);
    //canvas.line(0, 0, averageHandVector.x, averageHandVector.y);
    canvas.popMatrix();


    canvas.pushMatrix();

    drawHands();
    handleDirectionChange();
    canvas.endDraw();

    frame.image(canvas, 0, 0, frame.width, frame.height);
    canvas.clear();
  }

  void drawHands() {
    hands = tracking.getHands();

    // Draw the shapes for the hands
    if (hands != null) {
      for (int i = 0; i < hands.size(); i++) {
        hands.get(i).drawHand(canvas);
      }
    }
  }

  void handleDirectionChange() {
    averageHandVector = new PVector(0, 0);
    PVector center = new PVector(w / 2, h / 2);

    for (int i = 0; i < hands.size(); i++) {
      PVector handPosition = hands.get(i).mappedPosition.copy();
      PVector handVector = PVector.sub(handPosition, center); // Correctly subtract center from hand position
      averageHandVector.add(handVector);
    }

    if (hands.size() > 0) {
      averageHandVector.div(hands.size());
    }
    
    line.setHandDirectionVector(averageHandVector);
  }
}
