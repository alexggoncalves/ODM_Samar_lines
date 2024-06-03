import processing.net.*;

class Tracking{
  Server server;
  Client client;
  boolean isConnected;
  PVector[] hands = null;

  int captureWidth = 0;
  int captureHeight = 0;
  Tracking(PApplet parent){
     server = new Server(parent, 50007); 
  }
  
  void receiveData(){ 
    client = server.available();
    if (client !=null) {
      String receivedData = client.readStringUntil('\n');
      if (receivedData != null) {
        parseData(receivedData);
      } 
    }
  }
  
  void parseData(String data){
    data.trim();
    data = data.substring(1,data.length()-2);
    
    String[] values = split(data,", ");
    captureWidth = int(values[0]);
    captureHeight = int(values[1]);
    hands = null;
    int handCount = int(values[2]);
    if(handCount > 0){
      hands = new PVector[handCount];
    }
    
    for(int i = 0; i<handCount; i++) {
      float x = float(values[3 + i*2]);
      float y = float(values[3 + i*2 + 1]);
      float mappedX = map(x, 0.0, float(captureWidth), float(localFrame.w)/localFrame.wScale,0.0);
      float mappedY = map(y, 0.0,float(captureHeight),float(localFrame.h)/localFrame.hScale,0.0);
      hands[i] = new PVector(mappedX,mappedY);
    }
  }
  
  PVector[] getHands(){
    return hands;
  }
  
  void closeServer() {
    server.stop();
  }
}
