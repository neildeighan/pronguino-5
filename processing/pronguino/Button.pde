/**
 * Button
 *
 * Encapsulates the players "button", when Arduino connected
 *
 * @author  Neil Deighan
 */

 // TODO: With introduction of form controls would this be better renamed ? Switch ? 
 
class Button {

  Controller parent;
  int state;
  
  /**
   * Class Constructor
   *
   * @param controller  parent of button
   */ 
  Button(Controller controller) {
    // Set Parent
    this.parent = controller;
    
    // Initial State
    this.state = Constants.BUTTON_STATE_LOW;
  }
  
  /**
   * Sets state of button
   *
   * @param state  value to set (0 or 1)
   */
  void setState(int state) {
    
    // Set State
    this.state = state;
    
    // Raise "Event"
    if(this.state == Constants.BUTTON_STATE_HIGH) {
      buttonPressed(this.parent.parent.index);
    } else {
      // BUTTON_STATE_LOW
      buttonReleased(this.parent.parent.index);  
    }   
  }
}
