/**
 * Player
 *
 * Encapsulates the player
 *
 * @author  Neil Deighan
 */
 
 // TODO: Make checking for keys case-insensitive
 
class Player {

  int index;
  int score;
  String name;
  char upKey;
  char downKey;  
  boolean hasBall;
  
  Controller controller;
  Paddle paddle;

  /**
   * Class Constructor
   *
   * @param  index  array index of the player being created
   */
  Player(int index) {
    
    // Sets Players Index
    this.index = index;

    // Create Controller
    this.controller = new Controller(this);

    // Create Paddle
    this.paddle = new Paddle(this);

    // Apply Options
    this.applyOptions();

    // Sets Score
    this.score = 0;
        
  }
  
  /**
   * Apply values from options, initially set in constructor
   */
  void applyOptions() {
    this.name = game.options.names[index];
    this.upKey = game.options.keys[index].up;
    this.downKey = game.options.keys[index].down;
    this.hasBall = (index == game.options.playerStartIndex);     
    this.paddle.applyOptions();
  }
  
  /**
   * Called everytime controller value changes
   */
  void controllerChanged() {

    // If the difference is negative, we want to move up .. down if positive ..
    this.paddle.setDirection( this.controller.valueDifference() < 0 ? Constants.DIRECTION_UP : Constants.DIRECTION_DOWN);
     
    // Set factor to multiply speed
    this.paddle.setSpeedFactor(abs(this.controller.valueDifference())*2);
     
    // Note: as the controller could change quickly from a low value to a high value, say 2 to 5,
    // we have to add the difference into the factor, and also multply by 2, as range decreased 
    // to 1-7 from 0-15 
  }

   /**
    * Called when controller initializes
    */
   void controllerInitialize() {
    // Set the paddle position based on controller values
    this.paddle.positionByController();

    // Raise "Event" ... to say controllers are ready
    controllerReady(this);
  }
  
  /**
   * Checks which key has been pressed to determine direction of players paddle
   *
   * @param  pressedKey  
   */
  void checkKeyPressed(char pressedKey) {

    // Reset speed factor for keyboard
    this.paddle.setSpeedFactor(1.0);

    if(pressedKey == this.downKey) {
      this.paddle.setDirection(Constants.DIRECTION_DOWN);
    } else {
        if(pressedKey == this.upKey) {
          this.paddle.setDirection(Constants.DIRECTION_UP);
        } else { 
            if(pressedKey == Constants.KEY_SPACE && game.state == Constants.STATE_SERVE) {
              this.serve();
            }
        }
    }
  }
  
  /**
   * Checks which key has been released stop movement of players paddle
   *
   * @param  releasedKey  
   */
  void checkKeyReleased(char releasedKey) {
    if (releasedKey == this.downKey || releasedKey == this.upKey) {
      this.paddle.setDirection(Constants.DIRECTION_NONE);
    }
  }

  /** 
   * Serve
   */
  void serve() {
    // Set indicator to OFF
    if(this.controller.connected) {
      this.controller.indicator.setState(Constants.INDICATOR_STATE_OFF);
    }
    // Call event method
    playerServed(this);
  }
  
}
