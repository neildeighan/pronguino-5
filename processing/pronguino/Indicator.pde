/**
 * Indicator
 *
 * Encapsulates the controllers serve indicator
 *
 * @author  Neil Deighan
 */
 
class Indicator {

  Controller parent;
  int state;
  int previousState;
  
  /**
   * Class Constructor
   *
   * @param controller  parent of indicator
   */ 
  Indicator(Controller controller) {
    // Set Parent
    this.parent = controller;

    // Initial State
    this.state = Constants.INDICATOR_STATE_OFF;
  }
  
  /**
   * Sets state of indicator
   *
   * @param state  value to set (0 or 1)
   */
  void setState(int state) {
    
    // Set State
    this.state = state;
    
    // Check for changes  ...
    if(state != previousState) {
      // Raise "Event"      
      indicatorChanged(this.parent.parent.index, state);
      // Set Previous state for comparision
      this.previousState = state;
    } 
    
  }
}
