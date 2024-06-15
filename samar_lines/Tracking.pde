import processing.net.*;

class Tracking {
  Server server;
  Client client;
  boolean isReceivingData;
  ArrayList<Hand> hands = new ArrayList<Hand>(0);

  int captureWidth = 0;
  int captureHeight = 0;
  Tracking(PApplet parent) {
    server = new Server(parent, 50007);
  }
  void receiveData() {
    client = server.available();
    if (client !=null) {
      isReceivingData = true;
      String receivedData = client.readStringUntil('\n');
      if (receivedData != null) {
        parseData(receivedData);
      }
    } else {
      isReceivingData = false;
    }
  }

  void parseData(String data) {

    data.trim();
    data = data.substring(1, data.length()-2);

    String[] values = split(data, ", ");
    captureWidth = int(values[0]);
    captureHeight = int(values[1]);

    int handCount = int(values[2]);

    // Go through all the hand positions received, create hands and update existing ones
    for (int i = 0; i < handCount; i++) {
      float x = float(values[3 + 4*i]);
      float y = float(values[3 + 4*i + 1]);
      PVector position = new PVector(x, y);
      
      float handWidth = float(values[3 + 4*i + 2]);
      float handHeight = float(values[3 + 4*i + 3]);
      float handSize = sqrt(handWidth*handHeight);
      
      boolean createNew = true;

      for (int j = 0; j < hands.size(); j++) {
        if (hands.get(j).distanceTo(position) < 80) {
          createNew = false;
          hands.get(j).setPosition(position);
          hands.get(j).setSize(handSize);
          break;
        }
      }

      if (createNew) {
        hands.add(new Hand(position,handSize));
      }
    }

    checkHandUpdates();
  }

  void checkHandUpdates() {
    ArrayList<Hand> handsToRemove = new ArrayList<Hand>(0);
    // Check recent updates
    for (int i = 0; i< hands.size(); i++) {
      Hand hand = hands.get(i);

      if (hand.onTimeout) {
        if (hand.isItOver()) handsToRemove.add(hand);
      } else if (!hand.updated) {
        hand.startTimeout();
      } else {
        hand.updated = false;
      }
    }

    for (int i = 0; i < handsToRemove.size(); i++) {
      hands.remove(handsToRemove.get(i));
    }
  }

  ArrayList<Hand> getHands() {
    return hands;
  }

  void closeServer() {
    server.stop();
  }
}
