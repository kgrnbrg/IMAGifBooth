import gifAnimation.*;           
//PFont font;
import processing.video.*;
import processing.serial.*;
Capture video;

Serial myPort;
int inChar;
int prevTime = 0;
boolean counting = false;
int count = 4;

PGraphics canvas;
Gif currentGif;


void setup() {  
  size(1200, 480); //p2D is just for the example ascii filter
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600);
  println(Capture.list()); 
  frame.setBackground(new java.awt.Color(0, 0, 0));

  currentGif = null;


  canvas = createGraphics(640, 480);

  println(Capture.list()); //to detect cameras
  // video = new Capture( this, width, height, "Logitech Camera"); // for webcam
  video = new Capture(this, 640, 480); //for iSight
  video.start();
}

void captureEvent(Capture myCapture) {
  video.read();
}

void draw() {

  canvas.beginDraw();


  //image(video, 0, 0);
  canvas.pushMatrix();
  canvas.scale(-1, 1); //mirrors the video
  canvas.image(video, -video.width, 0);
  canvas.popMatrix();
  canvas.endDraw();
  image(canvas, 0, 0);
  fill(255, 0, 0);
  
  if (currentGif != null) {
    image(currentGif, 640, 0);
  }
  
  gifBooth();

  if ( myPort.available() > 0) {
    inChar = myPort.read();
  }
  if (inChar == '1') {
    counting = true;
    /*
    StartMakingGif(); //when key is released, start making gif happens, takingGif becomes true, and filter is selected
     globalFrameCount=0;
     takingGif=true;
     */
    inChar = 0; //clears input buffer to prevent multiple triggers
  }
  countDown();
} 



void countDown() {
  int now = millis();
  int timeDiff = now - prevTime;
  if (counting && count >= 0) {
    if (timeDiff > 1000) {
      count--;
      prevTime = now;
      if (count == 0) { 
        counting = false;
        StartMakingGif(); //when key is released, start making gif happens, takingGif becomes true, and filter is selected
        globalFrameCount=0;
        takingGif=true;
        count = 4;
      }
    }
  }
  if (counting == false && takingGif == false) {
    textSize(50);
    strokeWeight(1);
    text("Press Button", width/2-125, height/2-25);
    textSize(30);
    text("to record GIF", width/2-75, height/2+25);
  }
  if (timeDiff > 0 && timeDiff < 500) {
    if (count <= 3 && count > 0) {
      textSize(125);
      text(str(count-1), width/2, height/2);
      myPort.write('1');
      //println("1");
    }
  }
  if (timeDiff > 500 && takingGif == false) {
    myPort.write('0');
    //println("0");
  }
}