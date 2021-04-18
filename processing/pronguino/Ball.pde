/**
 * Ball
 *
 * Encapsulates the ball
 *
 * @author  Neil Deighan
 */
 
 // TODO: Add constants/options for colours
  
class Ball {
  PVector location = new PVector();
  PVector velocity = new PVector();
  float radius;
  float speed; 
  color colour;

  /**
   * Class Constructor 
   */
  Ball() {
    // Apply Options
    this.applyOptions();   
  }

  /**
   * Apply values from options
   */
  void applyOptions() {
     this.speed = game.options.ballSpeed;
     this.radius = game.options.ballRadius;
     this.colour = game.options.ballColour;   
  }
  
  /**
   * Repositions ball after collision, just before a bounce, 
   * bit of a hack, keep revisiting when improving collision
   *
   * @param  player    Player where ball needs to be repositioned to
   */
  void reposition(Player player) {
    this.location.x = (player.index==Constants.PLAYER_ONE) 
      ? player.paddle.location.x + (player.paddle.w/2 + this.radius) 
      : player.paddle.location.x - (player.paddle.w/2 + this.radius);  
  }
  
  /**
   * Positions the ball in front of the players paddle
   *
   * @param  player    Player where ball needs to be positioned
   */
  void positionAtPlayer(Player player) {
    // Note: I could call this.reposition, as same as below, but may
    // change/remove at some point, so keeping it independant.
    this.location.x = (player.index==Constants.PLAYER_ONE) 
      ? player.paddle.location.x + (player.paddle.w/2 + this.radius) 
      : player.paddle.location.x - (player.paddle.w/2 + this.radius);

    this.location.y = player.paddle.location.y + player.paddle.h/2;
  }

  /**
   * Sets the horizontal direction of the ball based on the player who missed ball
   *
   * @param  player  Player that missed the ball
   */
  void directionAtStart(Player player) {
    
    this.velocity.x = (player.index == Constants.PLAYER_ONE) 
      ? Constants.DIRECTION_RIGHT 
      : Constants.DIRECTION_LEFT;

    this.velocity.y = (player.paddle.location.y > surface.y+(surface.h/2))
      ? Constants.DIRECTION_UP
      : Constants.DIRECTION_DOWN;
  }

  /**
   * Move the ball by adding velocity * speed to location 
   */
  void move() {
    this.location.add(PVector.mult(this.velocity, this.speed));
  }

  /**
   * Changes the direction of the ball on the given axis.
   *
   * @param  axis  
   *
   * @throws Exception if invalid axis value given
   */
  void bounce(int axis) throws Exception {

    switch(axis) {
      case Constants.AXIS_HORIZONTAL:
        this.velocity.x *= Constants.DIRECTION_OPPOSITE;
        break;
      case Constants.AXIS_VERTICAL:
        this.velocity.y *= Constants.DIRECTION_OPPOSITE;
        break;
      default:
        // Have added simple parameter checking which raises 
        // error if invalid, this protects the game from the developer
        throw new Exception("axis parameter must be AXIS_HORIZONTAL or AXIS_VERTICAL");
    }
  }

  /**
   * Checks if the y co-ord of the ball is outside of the top/bottom surface boundaries
   *
   * @return true, if outside of the boundaries 
   */
  boolean hitsBoundary() {
    return ( ( this.location.y - this.radius < surface.y+surface.lineWidth) || 
             ( this.location.y + this.radius > surface.y+surface.h-surface.lineWidth) ) &&
             ( this.location.x > surface.x && this.location.x < surface.x + surface.w);  
  }
  
  /**
   * Draws the ball
   *
   * @param snapshot  if true, draws outline of ball only
   */
  void display(boolean snapshot) {

    // Mode (x,y = centre, r = radius)
    ellipseMode(RADIUS);
    
    // Colour
    if(snapshot) {
      noFill();
      stroke(#000000);
    } else {
     fill(this.colour);
     stroke(this.colour);
    }
    
    // Draw
    circle(this.location.x, this.location.y, this.radius);
    
    // Debug
    if(game.options.debug.enabled && (game.options.debug.playerHitsBall || game.options.debug.paddleHitsBoundary)) {
      strokeWeight(1);
      stroke(#000000);
      point(this.location.x, this.location.y);  
    }
  } 
}
