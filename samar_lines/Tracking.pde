import processing.net.*;

class Tracking{
  Server server;
  Client client;
  boolean isReceivingData;
  PVector[] hands = null;

  int captureWidth = 0;
  int captureHeight = 0;
  Tracking(PApplet parent){
     server = new Server(parent, 50007); 
  }
  
  void receiveData(){ 
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
  void updateHandPositions(PVector[] receivedHands){
    
    if(receivedHands != null){
         
    }
  }
  
  void parseData(String data){
    
    data.trim();
    data = data.substring(1,data.length()-2);
    
    String[] values = split(data,", ");
    captureWidth = int(values[0]);
    captureHeight = int(values[1]);
    
    
    int handCount = int(values[2]);
    PVector[] receivedHands = new PVector[handCount];
    
    for(int i = 0; i<handCount; i++) {
      float x = float(values[3 + i*2]);
      float y = float(values[3 + i*2 + 1]);
      
      receivedHands[i] = new PVector(x,y);
    }
      hands = receivedHands.clone();
  }
  
  PVector[] getHands(){
    return hands;
  }
  
  void closeServer() {
    server.stop();
  }
}
