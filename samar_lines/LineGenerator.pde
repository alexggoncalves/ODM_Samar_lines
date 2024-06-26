class LineGenerator {
  // Movement
  boolean isMoving = true;
  PVector position;
  float speedMultiplier;
  float speed = 2;
  float lineRadius = 7;
  float turnRate = PI/14;
  float turnRadius = lineRadius + 4;
  
  long lastFrame = millis();

  // Directions
  final PVector up = new PVector(0, -1);
  final PVector right = new PVector(1, 0);
  final PVector down = new PVector(0, 1);
  final PVector left = new PVector(-1, 0);
  PVector currentDirection;
  PVector lastDirection;

  // Turns
  boolean isTurning = false;
  PVector turnPivotPoint = new PVector(0, 0);
  String rotationDirection = "";
  float rotationAmount = 0;
  float currentRelativeRotation;
  float initialAngle = 0;

  // Colors
  color currentColor;
  ColorPicker colorPicker;

  PVector handDirectionVector = new PVector(0, 0);

  LineGenerator(float initX, float initY) {
    position = new PVector(initX, initY);
    currentColor = color(255, 0, 0);
    currentDirection = right;
    lastDirection = right;
    colorPicker = new ColorPicker("resources/gradient.png");
  }

  void update() {
    tracking.receiveData();
    handleManualDirectionChange();
    handleHandDirectionChange();
    
    long thisFrame = millis();

    // Check for change in direction and set turn parameters
    handleTurns();
    if (isTurning) {
      // Update the relative rotation based on the direction of the rotation
      if (rotationDirection == "clockwise") {
        currentRelativeRotation -= turnRate;
      } else {
        currentRelativeRotation += turnRate;
      }

      // If the curve has rotated enough stop the turn
      if (abs(currentRelativeRotation) >= abs(rotationAmount)) {
        isTurning = false;
        if (rotationDirection == "clockwise") {
          currentRelativeRotation = - rotationAmount;
        } else {
          currentRelativeRotation = rotationAmount;
        }
      }

      // Update the position based on the turn
      position.x = turnPivotPoint.x + turnRadius * cos(initialAngle + currentRelativeRotation);
      position.y = turnPivotPoint.y + turnRadius * sin(initialAngle + currentRelativeRotation);
    } else {
      // Move in a straight line
      position.x += round(currentDirection.x * speed * speedMultiplier);
      position.y += round(currentDirection.y * speed * speedMultiplier);

      checkBoundaries();
    }

    // Set color
    colorPicker.update();
    currentColor = colorPicker.getCurrentColor();

    lastDirection = currentDirection;
    lastFrame = thisFrame;
  }

  void render(PGraphics canvas) {
    canvas.beginDraw();
      canvas.blendMode(REPLACE);
      canvas.fill(currentColor);
      canvas.noStroke();
      canvas.ellipseMode(CENTER);
    
      canvas.ellipse(position.x, position.y, lineRadius*2, lineRadius*2);
    canvas.endDraw();
  }

  void checkBoundaries() {
    // Check horizontal boundaries
    if (position.x - lineRadius > fullCanvas.getWidth()) {
      position.x = - lineRadius;
    } else if (position.x + lineRadius < 0) {
      position.x = fullCanvas.getWidth() + lineRadius;
    }
    // Check vertical boundaries
    if (position.y - lineRadius > fullCanvas.getHeight()) {
      position.y = - lineRadius;
    } else if (position.y + lineRadius < 0) {
      position.y = fullCanvas.getHeight() + lineRadius;
    }
  }
  
  void setSpeedMultiplier(float speedMultiplier){
    this.speedMultiplier = speedMultiplier;
  }


  void handleTurns() {
    // If the direction changes and the line is not currently turning, start the turn
    if (lastDirection != currentDirection && !isTurning) {
      currentRelativeRotation = 0;
      isTurning = true;

      float crossProduct = lastDirection.x * currentDirection.y - lastDirection.y * currentDirection.x;
      PVector turnPivotVector = new PVector(0, 0);

      if (crossProduct > 0) {
        rotationDirection = "counterclockwise";
        rotationAmount = HALF_PI;
        turnPivotVector = new PVector(-lastDirection.y, lastDirection.x); // 90 degree left turn
      } else if (crossProduct < 0) {
        rotationDirection = "clockwise";
        rotationAmount = HALF_PI;
        turnPivotVector = new PVector(lastDirection.y, -lastDirection.x); // 90 degree right turn
      } else if (crossProduct == 0) {
        rotationAmount = PI;
        float diceRoll = random(1);
        // If the change in direction is an angle of 180 degrees choose random direction to turn to
        if (diceRoll < 0.5) {
          rotationDirection = "clockwise";
          turnPivotVector = new PVector(lastDirection.y, -lastDirection.x);  // 180 degree right turn
        } else {
          rotationDirection = "counterclockwise";
          turnPivotVector = new PVector(-lastDirection.y, lastDirection.x); // 180 degree left turn
        }
      }

      // Calculate the pivot point
      turnPivotVector = PVector.mult(turnPivotVector, turnRadius);
      turnPivotPoint = PVector.add(position, turnPivotVector);

      // Calculate the initial angle relative to the pivot point
      PVector temp = PVector.sub(position, turnPivotPoint);
      initialAngle = atan2(temp.y, temp.x); // Correctly calculate the initial angle
    }
  }

  void handleHandDirectionChange() {
    if (tracking.hands.size()>0) {
      PVector temp = handDirectionVector.copy().rotate(QUARTER_PI);

      int angle = floor((temp.heading() + PI)/TWO_PI * 4);

      PVector newDirection;
      switch(angle) {
      case 0:
        newDirection = left;
        break;
      case 1:
        newDirection = up;
        break;
      case 2:
        newDirection = right;
        break;
      case 3:
        newDirection = down;
        break;
      default:
        newDirection = currentDirection;
        break;
      }

      if (newDirection != currentDirection && !isTurning) {
        currentDirection = newDirection;
      }
    }
  }

  void setHandDirectionVector(PVector direction) {
    this.handDirectionVector = direction.copy();
  }
  
  boolean isMoving(){
   return isMoving; 
  }

  void handleManualDirectionChange() {
    if (keyPressed && !isTurning) {
      if (key == 'w') {
        currentDirection = up;
      }
      if (key == 's') {
        currentDirection = down;
      }
      if (key == 'd') {
        currentDirection = right;
      }
      if (key == 'a') {
        currentDirection = left;
      }
    }
  }
}
