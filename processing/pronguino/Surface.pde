/**
 * Surface
 *
 * Encapsulates the playing surface (table)
 *
 * @author  Neil Deighan
 */
 
 // TODO: Add colours to Constants
 
class Surface {

  float x;
  float y; 
  float w;
  float h;
  float lineWidth;

  /**
   * Class constructor
   */
  Surface(float x, float y) {

    this.x = x;
    this.y = y;
    this.w = width - (this.x * 2);
    this.h = height - (this.y * 2);
    this.lineWidth = game.options.surfaceLineWidth;
  }

  /**
   * Draws the playing surface
   */
  void display() {

    // Line Width & Colour
    strokeWeight(this.lineWidth);    
    stroke(#ffffff);                     

    // Surface
    fill(#135da1);              
    rect(this.x, this.y, this.w, this.h);

    // Service Rule Line
    line(this.x, this.y+(this.h/2), this.x+this.w, this.y+(this.h/2));
  }
}
