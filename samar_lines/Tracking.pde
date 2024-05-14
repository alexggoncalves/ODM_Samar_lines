import processing.net.*;

class Tracking{
  Server server;
  
  ArrayList<PVector> hands = new ArrayList<PVector>();
  ArrayList<PVector> faces = new ArrayList<PVector>();;
  
  Tracking(PApplet parent){
     server = new Server(parent, 50007); 
  }
  
  void receiveData(){ 
    Client client = server.available();
    if (client !=null) {
      String receivedData = client.readString();
      if (receivedData != null) {
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
