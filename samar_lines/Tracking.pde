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
    client = server.available();
    if (client !=null) {
      
      String receivedData = client.readStringUntil('\n');
      println(receivedData);
      if (receivedData != null) {
        receivedData.trim();
        receivedData = receivedData.substring(1,receivedData.length()-2);
        parseData(receivedData);
      } 
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
