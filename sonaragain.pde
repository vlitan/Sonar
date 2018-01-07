final int  BACK_COLOR = 0;
final int  MAX_DIST = 110;
final int  S_WEIGHT = 8;
final int  SCALE  = 2;
final int  ANG_COMP = 11;

import processing.serial.*;

public class point
{
  public float  x;
  public float  y;
};

Serial    myPort;
point     origin;
point     bound;
point     mid;
int       crement;
int       dst;
int       last;
int       angle;
int       angle_comp;
float     rads;

void setup() 
{
  /*****init display****/
  size(displayWidth * 11 / 12, displayHeight * 11 / 12);
  colorMode(RGB, 100);
  background(BACK_COLOR);
  strokeWeight(S_WEIGHT);
  /*********************/

  /***init serial com***/
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.buffer(1);
  /*********************/

  /***init vars*********/
  origin = new point();
  bound = new point();
  mid = new point();
  origin.x = width / 2;
  origin.y = height - 1;
  angle = 0;
  crement = 1;
  angle_comp = 0;
  /********************/
}

void draw() 
{
  /****angle update****/
  if (angle < 1)
  {
     crement = -crement;
     angle = 0;
  }
  else if (angle > 180)
  {
    crement = -crement;
    angle = 180;
  }
  angle_comp = (crement == -1) ? ANG_COMP : 0;
  rads = radians(angle + angle_comp);
  /*******************/
  
  /****points update****/
  dst = noiseFiltering();
  bound.x = width / 2 - cos (rads) * (width / 2);
  bound.y = height - sin (rads) * height;
  mid.x = width / 2 - cos (rads) * map(dst, 0, MAX_DIST, 0, width / 2);
  mid.y = height - sin (rads) * map(dst, 0, MAX_DIST, 0, height);
  /*********************/

  /***draw lines********/
  //base
  stroke(0, 100, 0);
  line(origin.x, origin.y, mid.x, mid.y);
  
  //object
  stroke(100, 0, 0);
  line(mid.x, mid.y, bound.x, bound.y);
  /********************/
}

void  serialEvent(Serial mport)
{
  dst = mport.read() - 1;
  if (dst <= 1)
    dst = MAX_DIST;
  mport.write(angle);
  angle += crement;
}

int  noiseFiltering()
{
  int aux;
  
  if ((last != MAX_DIST) && (dst == MAX_DIST))
  {
    last = MAX_DIST;
  }
  aux = last;
  last = dst;
  return (aux);
}
