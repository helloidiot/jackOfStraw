////////////////////////////////////////////////////////////////////////////////////////
// Jack of Straw
//
// by Joseph Rodrigues Marsh
//
// "The scarecrow is a relic of medieval times which continues to haunt the landscape.
// It seems to appear from nowhere and disappears equally mysteriously."
//
// Inspired by the Scarecrow photography of Colin Garratt, I wanted to represent the
// Scarecrows in their most abstract form, the skeleton. The Scarecrow has long been
// associated with ritual and mysticism, and I have tried to represent that with the
// skeletons resemblance to a cross.
//
// From a distance a Scarecrow can appear human, but up close it can be seen as
// its simple component parts, merely rags and sticks. To recreate this I drew the
// skeleton and read the brightness values from the graphic, using those to determine
// whether a right slash or left slash would be drawn.
// Up close, the viewer is able to see the component parts that make up the Scarecrow,
// but from a distance they see its full form.
//
// References:
//
// Colin Garratt - Shttp://bit.ly/2m739zb
// The technique was developed from a tutorial by Etienne Jacob: http://bit.ly/2j6Btc6
////////////////////////////////////////////////////////////////////////////////////////

// Import Processing PDF Library fro export
import processing.pdf.*;
PGraphicsPDF pdf;

// Create a PGraphics object to draw the skeleton to
PGraphics cross;

// Create two arrays, one for the pixels of the grpahic, and one for the brightness values
int [][] crossPixels;
int [][] crossBrightness;

// Image variables
int spacing = 10;

void setup()
{
  size(1920, 1080);
  background(255);

  /// Define the graphics buffer
  cross = createGraphics(width, height);

  // Begin the PDF recording
  pdf = (PGraphicsPDF)beginRecord(PDF, "JackOfStraw.pdf");
  beginRecord(pdf);

  // A function to draw the Scarecrows and add the data to the arrays
  setupImg();

  // A function for drawing the lines to screen
  crossNoise();

  // A function to draw a black border around the image
  border();

  // End the PDF record and exit
  endRecord();
  exit();
}

void setupImg(){

  // Initialise the an arrauy to store the pixels of the graphic
  crossPixels = new int [cross.width][cross.height];

  // and initialise another array to store the brightness values
  crossBrightness = new int [cross.width][cross.height];

  // Draw multiple versions of the Scarecrow
  cross.beginDraw();
  cross.rect(0,0, cross.width, cross.height);
  drawCross(cross, width / 2, height / 2, 1, 0);
  drawCross(cross, width, height - 150, 0.5, 255);
  cross.scale(0.7);
  cross.pushMatrix();
  cross.translate(-400, 160);
  drawCross(cross, cross.width / 2, cross.height / 2, 1, 0);
  //drawCross(cross, width, height - 150, 0.5, 255);
  cross.popMatrix();
  cross.translate(cross.width - 700, 160);
  drawCross(cross, cross.width / 2, cross.height / 2, 1, 0);
  //drawCross(cross, width, height - 150, 0.5, 255);
  cross.endDraw();

  cross.loadPixels();

  for (int i = 0; i < cross.height; i++){
    for (int j = 0; j < cross.width; j++){

      // Add the pixels from the buffer to a 2D array
      crossPixels[j][i] = cross.pixels[i * width + j];

      //Determine the brightness level of each pixel and store it in a new array
      crossBrightness[j][i] = int(brightness(crossPixels[j][i]));
    }
  }
  cross.updatePixels();

}


void drawCross(PGraphics p, float x, float y, float s, int c){
  // Draw the skeleton shape to an image buffer
  p.pushMatrix();
  p.pushStyle();
  p.noStroke();
  p.rectMode(CENTER);
  p.scale(s);
  p.translate(x, y);
  p.fill(c);
  p.rect(0, 0, 150, 790);
  p.translate(0, -150);
  p.rect(0, 0, 550, 120);
  p.popMatrix();
  p.popStyle();
}

void crossNoise(){

  strokeWeight(spacing / 3);

  // Loop through every pixel of the Scarecrow, iterating by a set spacing value
  for (int locY = (spacing * 8); locY < cross.height - (spacing * 8); locY += spacing)
  {
    for (int locX = (spacing * 12); locX < cross.width - (spacing * 12); locX += spacing)
    {
      // If the brightness value of the current pixel is less than one...
      if (crossBrightness[locX][locY] < 1)
        {
          // Draw a slash to the right
          line(locX, locY, locX + spacing, locY + spacing);
        }
        // Otherwise, draw a slash to the left
        else {
          line(locX, locY + spacing, locX + spacing, locY);
        }
      }
    }
}

// Draw a black outline to border the image
void border(){

  stroke(0);
  noFill();
  rect(spacing * 12, spacing * 8, cross.width - (spacing * 24), cross.height - (spacing * 16));
}

// Helpers //

void push()
{
  pushMatrix();
  pushStyle();
}

void pop()
{
  popMatrix();
  popStyle();
}
