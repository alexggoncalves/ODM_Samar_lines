class HandVisualizer {
  int w, h;
  int displayW;
  int displayH;
  float frameScale;

  ArrayList<Hand> hands = null;
  PGraphics visualizer;

  LineGenerator line = null;

  PVector averageHandVector = new PVector(0, 0);
  float influenceRadius = 0.2;

  HandVisualizer(int displayW, int displayH, float frameScale) {
    this.frameScale = frameScale;
    this.displayW = displayW - 1;
    this.displayH = displayH;
    this.w = int(displayW * frameScale);
    this.h = int(displayH * frameScale);

    visualizer = createGraphics(w, h);
  }

  void drawHandVisualizer(PApplet frame) {
    if (line == null) {
      line = fullCanvas.line;
    }

    visualizer.beginDraw();
      visualizer.clear();
      visualizer.background(255, 0, 0, 0);
      drawHands();
      drawHandInfluence();
    visualizer.endDraw();

    frame.image(visualizer, 0, 0, frame.width, frame.height);
    handleDirectionChange();
  }

  void drawHands() {
    hands = tracking.getHands();

    // Draw the shapes for the hands
    if (hands != null) {
      for (int i = 0; i < hands.size(); i++) {
        hands.get(i).drawHand(visualizer);
      }
    }
  }

  void drawHandInfluence() {
  int numPoints = 180; 
  float angleStep = TWO_PI / numPoints;
  float radius = line.lineRadius; 
  
  PShape circle = createShape();
  circle.beginShape();
  circle.fill(255, 255, 255, 100 * localFrame.currentTransitionValue);
  
  ArrayList<Hand> currentHands = new ArrayList<>(hands);
  
  for (int j = 0; j < numPoints; j++) {
    float angle = j * angleStep;

    float radiusIncrement = 0;
    for(Hand hand : currentHands){
      float handAngle = hand.headingVector.heading();
      
      float angleDifference = abs(handAngle - angle);
      angleDifference = angleDifference % TWO_PI;
      angleDifference = (angleDifference + TWO_PI) % TWO_PI;
      angleDifference = min(angleDifference, TWO_PI - angleDifference);

      float influenceRadius = radians(80);
      
      float pullStrength = min(abs(mag(hand.headingVector.x,hand.headingVector.y)),w/2);
      pullStrength /= float(w/2);

      // Add to radius increment based on proximity of hand angle to current angle being drawn
      if (angleDifference < influenceRadius) {
        float incrementFactor = map(pow(angleDifference,1), 0,influenceRadius, 10, 0);
        radiusIncrement += incrementFactor * pullStrength;
      }
    }
    
    // Calculate the position for the current vertex
    float bx = (radius + radiusIncrement-1) * cos(angle);
    float by = (radius + radiusIncrement-1) * sin(angle);
    circle.vertex(bx, by);
  }
  circle.endShape(CLOSE);
  
  // Draw the hand influence visualizer
  visualizer.shape(circle, w / 2, h / 2);
  
  // Draw a circle on top to cover center of circle or not
  visualizer.noStroke();
  visualizer.fill(red(line.currentColor)*localFrame.currentTransitionValue,green(line.currentColor)*localFrame.currentTransitionValue,blue(line.currentColor)*localFrame.currentTransitionValue);
  //visualizer.ellipse(w/2,h/2,line.lineRadius * 2,line.lineRadius * 2);
}

  void handleDirectionChange() {
    averageHandVector = new PVector(0, 0);
    PVector center = new PVector(w / 2, h / 2);

    for (int i = 0; i < hands.size(); i++) {
      PVector handPosition = hands.get(i).mappedPosition.copy();
      PVector handVector = PVector.sub(handPosition, center);
      averageHandVector.add(handVector);
      hands.get(i).headingVector = handVector;
    }

    if (hands.size() > 0) {
      averageHandVector.div(hands.size());
    }

    line.setHandDirectionVector(averageHandVector);
  }
}
