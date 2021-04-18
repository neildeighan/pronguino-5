/**
 * Scoreboard
 *
 * Encapsulates the scoreboard
 *
 * @author  Neil Deighan
 */
 
 // TODO: Add scoreboard colours to Constants
 
class Scoreboard {
  float x;
  float y;
  float w;
  float h;
  PFont font;
  Player player;  
  
  /**
   * Class constructor
   *
   * @param  x      x co-ord of scoreboard
   * @param  y      y co-ord of scoreboard
   * @param  font   font family
   * @param  player player assigned to scoreboard 
   */
  Scoreboard(float x, float y, PFont font, Player player) {
    this.font = font;
    this.x = x;
    this.y = y;
    this.w = this.font.getSize() * 1.75;
    this.h = this.font.getSize() * 1.25;
    this.player = player;
  }

  /**
   * Draw the scoreboard
   */
  void display() {

    // Players Name
    fill(player.paddle.colour);
    textSize(16);
    textAlign(CENTER);
    text(this.player.name, this.x+(this.w/2), this.y-8);
    
    // Board
    stroke(#202020);
    strokeWeight(1);
    fill(#0f0f0f);
    rect(x, y, w, h, 5);
    
    // Players Score
    fill(#ffffff);  
    textFont(font);
    textAlign(RIGHT);
    text(this.player.score, this.x + font.getSize()*1.50, this.y + this.h*0.80);
  }
}
