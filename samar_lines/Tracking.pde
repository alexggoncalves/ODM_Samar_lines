import processing.net.*;

class Tracking{
  Server server;
  Client client;
  boolean isConnected;
  ArrayList<PVector> hands = new ArrayList<PVector>();
  ArrayList<PVector> faces = new ArrayList<PVector>();;
  
  
  int captureWidth = 0;
  int captureHeight = 0;
  Tracking(PApplet parent){
     server = new Server(parent, 50007); 
  }
  
  void receiveData(){ 
    if(client != null && !isConnected){
      client = server.available();
    }
    
    if (client !=null) {
      isConnected = true;
      String receivedData = client.readStringUntil('\n');
      if (receivedData != null) {
        receivedData.trim();
        receivedData = receivedData.substring(1,receivedData.length()-2);
        parseData(receivedData);
      } 
    } else {
      isConnected = false;
    }
  }
  
  void parseData(String data){
    println(data);
    
    // hands.add()
    // faces.add()
  }
  
  void closeServer() {
    server.stop();
  }
}
