/**
 * Net
 *
 * Encapsulates the tables net
 *
 * @author  Neil Deighan
 */
 
 // TODO: If any options used in form, will need to add applyOptions, might add anyway
 
class Net {

  float w;
  float h;
  float gap;
  float x;
  color colour;
  
  /**
   * Class constructor
   */
  Net() {
    this.w = game.options.netWidth;
    this.h = game.options.netHeight;
    this.gap = game.options.netGap;
    this.x = ((surface.w + surface.x*2) - this.w) / 2;
    this.colour = game.options.netColour;
  }

  /**
   * Draws the net
   */
  void display() {
    
    strokeWeight(this.w);
    stroke(this.colour);
    
    float y = surface.y + surface.lineWidth;
    do {
      line(this.x, y, this.x, y + this.h);      
      y += (this.h + this.gap);
    } while (y + this.h <= surface.h + surface.y);
  }
}
