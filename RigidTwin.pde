// LecturesInGraphics: vector interpolation
// Template for sketches
// Author: James Moak, Deep Ghosh
// Computational Aesthetics: Project 1 

//**************************** global variables ****************************
pts P = new pts();
float t=1, f=0;
int bcount = 0;
Boolean animate=true, bobFrame = false, article = true;
PImage bob, bob2, jarekImg;
float len=60; // length of arrows
color shirt, pants, shoe;
//**************************** initialization ****************************
void setup() {               // executed once at the begining 
  textureMode(NORMAL);
  size(600,600, P3D);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  myFace =loadImage("data/jarek.jpg");  
  bob = loadImage("data/bob.bmp");
  bob2 = loadImage("data/bob2.bmp");
  P.declare();
  P.addPt(P(100, 200));
  P.addPt(P(130, 200));
  P.addPt(P(160, 200));
  shirt = red;
  pants = brown;
  shoe = black;
  }

//**************************** display current frame ****************************
void draw() {      // executed at each frame
  background(white); // clear screen and paints white background
  if(snapPic) beginRecord(PDF,PicturesOutputPath+"/P"+nf(pictureCounter++,3)+".pdf"); 
  noStroke(); 
  
  t+=0.01; 
  if(t>2*PI) {t=0; animating=false;}
  
  
  pt p = P(360,300);
  vec v = V(0,-300);
  pt sp = P(360,330);
  vec sv = V(0,-160);
  pt pp = P(360,430);
  vec pv = V(0,-90);
  pt zp = P(370,600);
  vec zv = V(0,-105);
  
  fill(shirt);
  drawObject(sp, sv, false);
  fill(pants);
  drawObject(pp, pv, false);
  fill(shoe);
  drawObject(zp, zv, false);
  
  noFill();
  drawObject(p, v, true);
  
  for (int i=0;i<3;++i) {
    if (P.G[i].y < 200) P.G[i].y = 200;
    if (P.G[i].y > 450) P.G[i].y = 450;
  }
  
  fill(red); pen(red, 2);
  show(P.G[0], 10);
  line(100,200, 100, 450);
  fill(blue); pen(blue, 2);
  show(P.G[1], 10);
  line(130,200, 130, 450);
  fill(green); pen(green, 2);
  show(P.G[2], 10);
  line(160,200, 160, 450);
  
  if (article) {
    shirt = color(convertToColor(P.G[0].y), convertToColor(P.G[2].y), convertToColor(P.G[1].y));
    }
  if (!article) {
    pants = color(convertToColor(P.G[0].y), convertToColor(P.G[2].y), convertToColor(P.G[1].y));
    }
  shoe = getThirdColor(shirt, pants, t);
  
  bcount++;
  if (bcount > 5) {bobFrame = !bobFrame; bcount = 0;}
  
  if(snapPic) {endRecord(); snapPic=false;} // end saving a .pdf of the screen

  fill(black); displayHeader();
  if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 
  if(filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif"); // saves a movie frame 
  change=false; // to avoid capturing movie frames when nothing happens
  }  // end of draw()
  
//**************************** user actions ****************************
void keyPressed() { // executed each time a key is pressed: sets the "keyPressed" and "key" state variables, 
                    // till it is released or another key is pressed or released
  if(key=='?') scribeText=!scribeText; // toggle display of help text and authors picture
  if(key=='!') snapPicture(); // make a picture of the canvas and saves as .jpg image
  if(key=='`') snapPic=true; // to snap an image of the canvas and save as zoomable a PDF
  if(key=='~') { filming=!filming; } // filming on/off capture frames into folder FRAMES 
  if(key=='a') {animating=true; f=0; t=0;}  
  if(key=='1') article=!article;
  if(key=='s') P.savePts("data/pts");   
  if(key=='l') P.loadPts("data/pts"); 
  if(key=='Q') exit();  // quit application
  change=true; // to make sure that we save a movie frame each time something changes
  }

void mousePressed() {  // executed when the mouse is pressed
  P.pickClosest(Mouse()); // used to pick the closest vertex of C to the mouse
  change=true;
  }

void mouseDragged() {
  if (!keyPressed || (key=='a')) P.dragPicked();   // drag selected point with mouse
  if (keyPressed) {
      if (key=='.') f+=2.*float(mouseX-pmouseX)/width;  // adjust current frame   
      }
  change=true;
  }  

float convertToColor(float y) {
   return 255.0/150.0 * (450.0 - y);
}

//**************************** text for name, title and help  ****************************
String title ="CA 2015 Project 3", 
       name ="Student: James Moak",
       menu="?:(show/hide) help, a: animate, `:snap picture, ~:(start/stop) recording movie frames, Q:quit",
       guide=""; // help info

void drawObject(pt P, vec V, boolean t) {
  beginShape(); 
    if (t) {if (bobFrame) texture(bob); else texture(bob2);};
    v(P(P(P,1,V),1,R(V)), 0, 0);
    v(P(P(P,1,V),-1,R(V)), 1, 0);
    v(P(P(P,-1,V),-1,R(V)), 1, 1);
    v(P(P(P,-1,V),1,R(V)), 0, 1); 
  endShape(CLOSE);
  }
  
  
float timeWarp(float f) {return sq(sin(f*PI/2));}