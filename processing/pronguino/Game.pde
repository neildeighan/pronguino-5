/**
 * Game
 *
 * Encapsulates some of the operational side of the game 
 *
 * @author  Neil Deighan
 */

 // TODO: Add Menu here ?
 
class Game {

  int state;
  Options options;
  
  /**
   * Class constructor
   */
  Game() {
    // Set initial state while setting up
    this.state = Constants.STATE_SETUP;

    // Load options
    this.options = new Options();    
  }

  /**
   * Determines if game in play
   *
   * @return  true  if game in play
   */
  boolean inPlay() {
    return Constants.STATE_INPLAY.hasValue(this.state);
  }
  
  /**
   * Perform Game Action
   */
  void performAction() {
  
    // Determine what action to take depending on state
    switch(this.state) {
      case Constants.STATE_STARTED:
        this.pause();
        break;
      case Constants.STATE_PAUSED:
        this.resume();
        break;
      case Constants.STATE_ENDED:
        this.begin();
        break;
    }
  }

  /**
   * Pause Game
   */
  void pause() {
    // Set State    
    this.state = Constants.STATE_PAUSED;
    // Call 'event' method
    gamePaused();
  }
  
  /**
   * Resume Game
   */
  void resume() {
    // Set State    
    this.state = Constants.STATE_STARTED;
    // Call 'event' method    
    gameResumed();
  }
  
  /**
   * Start New Game
   */
  void begin() {
    // Set State
    this.state = Constants.STATE_SERVE;
    // Call 'event' method    
    gameBegin();
  }  
}
