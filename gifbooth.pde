GifMaker gifExport;
int globalFrameCount = 0; //to determine how many frames to add to the gif
int timeLastFrameMade = 0; // to determine when to take next gif
boolean takingGif = false;  //to test whether or not gif is being made


//gifBooth is a function that is called every frame. 
void gifBooth() {
  if (takingGif) {
    int now = millis();
    int timeDiff = now - timeLastFrameMade;
    //println(timeDiff);
    if (timeDiff > 100) {
      timeLastFrameMade = now;
      takeAGifFrame(globalFrameCount);
      //println(globalFrameCount);
      globalFrameCount++;
      if (globalFrameCount>15) { //keep taking frames until it has reached 15 frames (change this to add more frames to the gif)
        stopMakingGif();
      }
    }
  }
}

void takeAGifFrame(int index) {
  //println("frame taken");
  String imageName = "img" + index + ".jpg";
  canvas.save(imageName);
  PImage img = loadImage(imageName);
  img.resize(600, 500);
  gifExport.setDelay(100); //determins how much time will go in between each frame in the final gif
  gifExport.addFrame(img); //adds that frame to gif
}

String gifName = "";

void StartMakingGif() {
  println("started!"); 
  myPort.write('1'); //turn ON LED on arduino
  int dayStamp = day();
  int hourStamp = hour();
  int minuteStamp = minute();
  int secondStamp = second();
  gifName = "data/"+dayStamp+hourStamp+minuteStamp+secondStamp+".gif";
  gifExport = new GifMaker(this, gifName); //saves to public dropbox folder called tumblr
  gifExport.setQuality(5);
  gifExport.setRepeat(0);
}
/*
void keyReleased() {
 StartMakingGif(); //when key is released, start making gif happens, takingGif becomes true, and filter is selected
 globalFrameCount=0;
 takingGif=true;
 //selectFilter(key);
 }
 */

void stopMakingGif() {
  myPort.write('0'); //turn off LED on arduino
  gifExport.finish();
  println("you're done!"); //add here a "you're done image"
  takingGif=false;
  
  println(gifName);
  currentGif = new Gif(this, gifName);
  currentGif.play();
}