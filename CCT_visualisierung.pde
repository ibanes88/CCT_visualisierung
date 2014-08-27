ArrayList pointList;
PFont font;
PImage bgImage;

//arrays for processing positions.txt
String[] temp;
String[] temp2;
String[] temp3;
String[] lines;

int n;
int x, x_, y, y_, id, id_; // variables for reading out coordinate list -> splitAssign() 
int r1, r2, g1, g2, b1, b2; //variables for pathcolors
int alpha = 50;
int strokeWeight = 3;
int radius = 3;
int backgroundColor = 100;

PVector location;

import controlP5.*;
ControlP5 cp5;



// Interface based on controlp5-Library

void setup()
{
  String[] frameNumber = loadStrings("framecount.txt");
  maxfc = Integer.parseInt(frameNumber[0]);
  lines = loadStrings("positions.txt");
  background(backgroundColor);
  bgImage = loadImage("bgImage.jpg");

  pointList = new ArrayList();
  font = createFont("Arial", 16, true);

  size(bgImage.width, bgImage.height);
  image(bgImage, 0, 0);
  personsTotal = new IntList();

  // cp5 interface control

  cp5 = new ControlP5(this);

  // define tabs
  cp5.addTab("Paths")
    .setColorBackground(color(100, 200, 255))
      .setColorLabel(color(255))
        .setColorActive(color(255, 200, 100))
          ;
  cp5.addTab("Directions")
    .setColorBackground(color(100, 200, 255))
      .setColorLabel(color(255))
        .setColorActive(color(255, 200, 100))
          ;
  cp5.addTab("Density")
    .setColorBackground(color(100, 200, 255))
      .setColorLabel(color(255))
        .setColorActive(color(255, 200, 100))
          ;
    cp5.addTab("Tracing")
    .setColorBackground(color(100, 200, 255))
      .setColorLabel(color(255))
        .setColorActive(color(255, 200, 100))
          ;
  // set tab properties
  cp5.getTab("default")
    .hide()
      ;
  cp5.getTab("Paths")
    .activateEvent(true)
      .setId(2)
        ;
  cp5.getTab("Directions")
    .activateEvent(true)
      .setId(3)
        ;
  cp5.getTab("Density")
    .activateEvent(true)
      .setId(4)
        ;
  cp5.getTab("Tracing")
    .activateEvent(true)
      .setId(5)
        ;

  //create controllers
  cp5.addSlider("pThickness_")
    .setBroadcast(false)
      .setRange(0, 10)
        .setValue(3)
          .setPosition(5, 40)
            .setSize(100, 20)
              .setBroadcast(true)
                .setLabel("path thickness")
                  .setColorLabel(color(0))
                    ;
  cp5.addSlider("pAlpha_")
    .setBroadcast(false)
      .setRange(0, 255)
        .setValue(50)
          .setPosition(5, 70)
            .setSize(100, 20)
              .setBroadcast(true)
                .setLabel("path transparency")
                  .setColorLabel(color(0))
                    ;
  cp5.addBang("color1_")
    .setPosition(5, 100)
      .setSize(20, 20)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("moving to the left")
            .setColorLabel(color(0))
              ;
  cp5.addBang("color2_")
    .setPosition(5, 140)
      .setSize(20, 20)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("moving to the right")
            .setColorLabel(color(0))
              ;
  cp5.addSlider("gridSize_")
    .setBroadcast(false)
      .setRange(2, 40)
        .setValue(14)
          .setPosition(5, 70)
            .setSize(100, 20)
              .setBroadcast(true)
                .setLabel("cells in grid")
                  .setColorLabel(color(0))
                    ;
                    
   cp5.addSlider("dRadius_")
    .setBroadcast(false)
      .setRange(0, 5)
        .setValue(3)
          .setPosition(5, 40)
            .setSize(100, 20)
              .setBroadcast(true)
                .setLabel("circle radius")
                  .setColorLabel(color(0))
                    ;
  cp5.addSlider("dAlpha_")
    .setBroadcast(false)
      .setRange(0, 255)
        .setValue(50)
          .setPosition(5, 70)
            .setSize(100, 20)
              .setBroadcast(true)
                .setLabel("circle transparency")
                  .setColorLabel(color(0))
                    ;
  cp5.addBang("resetTraces")
    .setPosition(5, 40)
      .setSize(20, 20)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("reset")
            .setColorLabel(color(0))
              ;

  //arrange controllers in Tabs
  cp5.getController("pThickness_").moveTo("Paths");
  cp5.getController("pAlpha_").moveTo("Paths");
  cp5.getController("color1_").moveTo("Paths");
  cp5.getController("color2_").moveTo("Paths");
  cp5.getController("gridSize_").moveTo("Directions");
  cp5.getController("dRadius_").moveTo("Density");
  cp5.getController("dAlpha_").moveTo("Density");
  cp5.getController("resetTraces").moveTo("Tracing");

timeCount = millis();
paths = new ArrayList <Path>();
frameRate(60);
} //e.o. setup


// draw-void only used for tracing-animation
void draw() 
{

if(click){
    temp3 = split(moves[zett], ',');
    int id = int(temp3[0]);
    int x = int(temp3[1]);
    int y = int(temp3[2]);
    if (personsTotal.hasValue(id))
    {
      int place = checkPlace(id);
      Path p = paths.get(place);
      p.update(x,y);
      
    } else {
    personsTotal.append(id);
    paths.add(new Path(id));
    }
    drawTr();

if (millis ()- timeCount >= 5) {
    timeCount = millis();
    zett++;
}
if (zett==moves.length){ click=false; zett=0;personsTotal.clear();paths = new ArrayList <Path>();}
}
} //e.o. draw




// processing data from positions.txt, by splitting every line into an array of substrings //
void splitAssign(int i) {
  temp = split(lines[i], ',');
  id_ = id;
  id = int(temp[0]);
  x_ = x;
  y_ = y;
  x = int(temp[1]);
  y = int(temp[2]);
  fc = int(temp[3]);
  location = new PVector(x, y);
}



// control events for interfacecontrols
void drPath() 
{
  image(bgImage, 0, 0);
  strokeWeight(strokeWeight);
  drawPaths(200, 255, 100, 100, 255, 200, alpha);
}

void pThickness_(int t) {
  strokeWeight = t;
  drPath();
}

void pAlpha_(int a) {
  alpha = a;
  drPath();
}

void drDirection()
{
  image(bgImage, 0, 0);
  drawDirections();

void gridSize_(int x) {
  xParts = x;
  drDirection();
}

void dRadius_(int x){
  radius = x;
  drDensity();
}

void dAlpha_(int a){
  alpha = a;
  drDensity();
}

void drDensity()
{
  image(bgImage, 0, 0);
  drawDensity();
}

void drTraces()
{
  image(bgImage, 0, 0);
  strokeWeight(1);
  drawTraces();
}

public void controlEvent(ControlEvent theEvent) {
  if (theEvent.isTab()) {
    if (theEvent.getTab().getId() == 2) {
      background(backgroundColor); 
      drPath();
    }
    if (theEvent.getTab().getId() == 3) {
      background(backgroundColor); 
      drDirection();
    }
    if (theEvent.getTab().getId() == 4) {
      background(backgroundColor); 
      drDensity();
    }
    if (theEvent.getTab().getId() == 5) {
      background(backgroundColor); 
      drTraces();
    }
  } else {
    println(
    "## controlEvent / id:"+theEvent.controller().id()+
      " / name:"+theEvent.controller().name()+
      " / label:"+theEvent.controller().label()+
      " / value:"+theEvent.controller().value()
      );
  }
}
