final PVector up = new PVector(0, -1);
final PVector right = new PVector(1, 0);
final PVector down = new PVector(0, 1);
final PVector left = new PVector(-1, 0);

class LineGenerator {
  PVector position;
  float speed = 3;
  float turnRate = 0.2f;

  PVector currentDirection;
  PVector lastDirection;

  int turnRadius = 10;
  boolean isTurning = false;
  PVector turnPivotPoint = new PVector(0, 0);
  String rotationDirection = "";
  float rotationAmount = 0;
  float currenRelativeRotation;
  float initialAngle = 0;

  color currentColor;

  LineGenerator(float initX, float initY) {
    position = new PVector(initX, initY);
    currentColor = color(255, 0, 0);
    currentDirection = right;
    lastDirection = right;
  }

  void update() {
    if (tracking.isConnected) {
      tracking.receiveData();
      //-------------------------------------------------
      // set direction based on the position of the hands!!
      //-------------------------------------------------
    } else {
      handleManualDirectionChange();
    }

    // Check for change in direction and set turn parameters
    handleTurns();

    if (isTurning) {
      // Update the relative rotation based on the direction of the rotation
      if(rotationDirection == "clockwise"){
        currenRelativeRotation -= turnRate;
      } else {
        currenRelativeRotation += turnRate;
      }
      // Update the position based on the turn
      position.x = turnPivotPoint.x + turnRadius * cos(initialAngle + currenRelativeRotation);
      position.y = turnPivotPoint.y + turnRadius * sin(initialAngle + currenRelativeRotation);

      // If the curve has rotated enough stop the turn
      if (abs(currenRelativeRotation) >= abs(rotationAmount)) {
        isTurning = false;
        currenRelativeRotation = 0; // Reset for next turn
      }
    } else {
      // Move in a straight line
      position.x += currentDirection.x * speed;
      position.y += currentDirection.y * speed;
    }
    currentColor = color(red(currentColor)-0.01,0,0);
    lastDirection = currentDirection;
  }

  void render(PGraphics canvas) {
    canvas.fill(currentColor);
    canvas.noStroke();
    canvas.ellipse(position.x, position.y, 10, 10);
  }

  void handleTurns() {
    // If the direction changes and the line is not currently turning, start the turn
    if (lastDirection != currentDirection && !isTurning) {
      currenRelativeRotation = 0;
      isTurning = true;

      float crossProduct = lastDirection.x * currentDirection.y - lastDirection.y * currentDirection.x;
      PVector turnPivotVector = new PVector(0, 0);
      
      if (crossProduct > 0) {
        rotationDirection = "counterclockwise";
        rotationAmount = PI / 2;
        turnPivotVector = new PVector(-lastDirection.y, lastDirection.x); // 90 degree left turn
      } else if (crossProduct < 0) {
        rotationDirection = "clockwise";
        rotationAmount = PI / 2;
        turnPivotVector = new PVector(lastDirection.y, -lastDirection.x); // 90 degree right turn
      } else if (crossProduct == 0) {
        rotationAmount = PI;
        // Choose rotation direction randomly and decide the offset vector based on it
        rotationDirection = "clockwise";
        turnPivotVector = new PVector(lastDirection.y, -lastDirection.x); // 90 degree right turn
      }

      // Calculate the pivot point
      turnPivotVector = PVector.mult(turnPivotVector, turnRadius);
      turnPivotPoint = PVector.add(position, turnPivotVector);

      // Calculate the initial angle relative to the pivot point
      PVector V = PVector.sub(position, turnPivotPoint);
      initialAngle = atan2(V.y, V.x); // Correctly calculate the initial angle
    }
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
