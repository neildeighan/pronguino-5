/**
 * Paddle
 *
 * Encapsulates the paddle
 *
 * @author  Neil Deighan
 */
 
 // TODO: Could I use 'constrain' function anywhere here to assist with controller/paddle positioning ?
 // TODO: Add constants for colours i.e. debug 
 
class Paddle {
  float w;
  float h; 
  PVector location = new PVector();
  PVector velocity = new PVector();
  float speed;
  float speedFactor;
  color colour; 
  Player parent;

  /**
   * Class constructor
   *
   * @param  player  parent of this paddle  
   */
  Paddle(Player player) {
    
    // Set Parent
    this.parent = player; 

    // Apply Options
    this.applyOptions();

    // Set Location
    this.location.x = (this.parent.index == Constants.PLAYER_ONE) 
      ? surface.x+(this.w * 1.5) 
      : (surface.x + surface.w) - (this.w*1.5);

    // Set default speed Factor
    this.speedFactor = 1.0;
  }

  /**
   * Apply values from options, initially set in constructor
   */
  void applyOptions() {
    this.w = game.options.paddleWidth;
    this.h = game.options.paddleHeight;
    this.colour = game.options.paddleColours[parent.index];    
    this.speed = game.options.paddleSpeed;
  }
  
  /**
   * Sets the direction of the paddle
   *
   * @param  direction, multiplier, either up or down direction constants
   */
  void setDirection(int direction) {
    this.velocity.y = direction;
  }

  /**
   * Sets the speed of the paddle
   *
   * @param  speed, no. of pixels to multiply co-ords of velocity 
   */
  void setSpeed(float speed) {
    this.speed = speed;
  }

  /**
   * Sets the speed factor, this multplies the speed, when using controllers/keyboard
   *
   * @param  speedFactor, multiplier for speed 
   */
  void setSpeedFactor(float speedFactor) {
    this.speedFactor = speedFactor;
  }

  /**
   * Sets the position of the paddle depending on value of controller 
   */
  void positionByController() {        
    this.location.y = map(this.parent.controller.currentValue, 
      Constants.CONTROLLER_VALUE_MIN, Constants.CONTROLLER_VALUE_MAX, 
      surface.y, surface.y + surface.h - surface.lineWidth - this.h); 
  }
  
  /**
   * Sets the starting position of the paddle to middle
   */
  void positionAtStart() {
    this.location.y = surface.y + (surface.h - this.h) / 2;
  }

  /**
   * Sets the position of paddle to the surface boundary, depending on proximity
   */
  void positionAtBoundary() {
    if (this.location.y < surface.y + surface.lineWidth) {
      this.location.y = surface.y + this.w/2 + surface.lineWidth;
    } else {
      if (this.location.y+this.h + this.w/2 > (surface.y + surface.h - surface.lineWidth)) {
        this.location.y = (surface.y - this.w/2 + surface.h - surface.lineWidth - this.h);
      }
    }
  }

  /**
   * Move the paddle by adding velocity * (speed * factor) to new location 
   */
  void move() {
    this.location.add(PVector.mult(this.velocity, (this.speed*this.speedFactor)));    
  }

  /**
   * Sets the direction to 0, stopping the paddle
   */
  void stopMoving() {
    this.velocity.y = Constants.DIRECTION_NONE;
  }

  /**
   * Checks if the y co-ord of the paddle is outside of the top/bottom surface boundaries
   *
   * @return true, if outside of the boundaries 
   */
  boolean hitsBoundary() {
    return (this.location.y < surface.y + surface.lineWidth) || 
           (this.location.y + this.h + this.w/2 > surface.y + surface.h - surface.lineWidth);
  }

  /**
   * Checks the proximity of the ball to the paddle, and determines if collision is made
   *
   * @param  ball  
   *
   * @return true, if collision is made
   */
  boolean hits(Ball ball) {
    float horizontalDistance = abs(this.location.x - ball.location.x);
    float verticalDistance = ball.location.y - this.location.y;
    return horizontalDistance < (ball.radius + this.w/2) && 
          (verticalDistance > 0 && verticalDistance < this.h);    
  }

  /**
   * Check the x co-ord of the ball is outside of the left/right screen boundaries
   *
   * @param  ball  
   *
   * @return  true, if outside of boundaries
   */
  boolean misses(Ball ball) {
    return ( ball.location.x < 0 && this.parent.index == Constants.PLAYER_ONE) || 
           ( ball.location.x > width && this.parent.index == Constants.PLAYER_TWO);
  }

  /**
   * Draws the paddle
   */
  void display() {   
    
    // Style & Colour
    strokeWeight(this.w);
    strokeCap(ROUND);
    stroke(this.colour);
    
    // Draw
    line(this.location.x,this.location.y,this.location.x,this.location.y+this.h);

    // Debug
    if(game.options.debug.enabled && (game.options.debug.playerHitsBall || game.options.debug.paddleHitsBoundary)) {
      strokeWeight(1);
      stroke(#000000);
      point(this.location.x, this.location.y);  
    }
  }
}
