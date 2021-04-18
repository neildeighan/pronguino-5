/**
 * Form
 *
 * Form Controls 
 *
 * @author  Neil Deighan
 */
 
 // TODO: Add tabOrder property to Control, use TAB/ENTER (and SHIFT+TAB) to navigate, setFocus ?
 // TODO: Add a Label as a nested class to Control, increase encapsulation, and allow adjust of x, instead of padding ?
 // TODO: Add character filters for InputControl i.e.integer/float only etc.
 // TODO: Add styling for focused field like InputControl, subtle outline for ToggleControl, thicker gauge for SliderControl ?
 // TODO: Add keyboard control for fields i.e. SPACE for ToggleControl, number/arrow keys for SliderControl, when hasFocus is true ?
 // TODO: Add other controls i.e. CheckBoxControl, RadioButtonControl, DropDownControl etc etc ?
 // TODO: Add the colour constants into Control class/interface ? bit more self-contained ?
 // TODO: Add link to frame in control, implement disabled property to frame, to disable all fields ?
 // TODO: Add 'animation' if button control clicked, would need to use pressed/released, set a state, use in display?
 // TODO: Create Java library for these ? will then be able to add callbacks for buttons etc ?
 // TODO: Change mouse cursor, when over, when grabbing slider etc ?
 // TODO: Look to use getter/setter methods more for say value, disabled etc, for consistancy ?
 // TODO: Change colour of labels when disabled ?
 // TODO: Add overload constructor/setValue for SliderControl to accept integers to ?
 
/**
 * IControl
 * 
 * Interface for controls 
 *
 * Classes implemented from this interface must have these methods
 */
interface IControl {
  boolean over();
  boolean clicked();
  void display();
}

/**
 * Control
 * 
 * Abstract class that partially implements IControl
 *
 * Abstract methods used where they cannot be implemented
 */ 
abstract class Control implements IControl {
  float x;
  float y;
  float w;
  float h;
  String label;
  boolean hasFocus = false;
  boolean disabled = false;
  
  /**
   * Constructor (with label)
   *
   * @param  x      co-ord
   * @param  y      co-ord
   * @param  w      width
   * @param  h      height
   * @param  label  control label   
   */ 
  Control(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label + "  ";    
  }

  /**
   * Constructor (without label)
   *
   * @param  x      co-ord
   * @param  y      co-ord
   * @param  w      width
   * @param  h      height 
   */ 
  Control(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;   
  }

  /**
   * Checks if control is enabled, checks if mouse is over control
   *
   * @return  true  if mouse cursor is over control
   */
  boolean over()  {
    if(this.disabled) {
      return false;
    }    
    if (mouseX >= this.x && mouseX <= this.x+this.w && 
        mouseY >= this.y && mouseY <= this.y+this.h) {
      return true;
    } else {
      return false;
    }  
  }

  /**
   * Event method cascaded down from (Menu/Options) clicked()
   *
   * If mouse is over control when clicked, sets as having current focus
   *
   * @return  true  if focus has been set
   */
  boolean clicked() {
    this.hasFocus = this.over();
    return this.hasFocus;
  }
  
  /**
   * Abstract method, that doesnt't have implementation at this level
   * needs to be implemeted in inherited classes
   *
   * Draws control 
   */
  abstract void display();
  
}

/**
 * ButtonControl
 * 
 * Concrete class that inherits methods and properties of Control superclass
 *
 * Basic clickable Button 
 */ 
class ButtonControl extends Control {

  // Declare extra properties specific to this control, text shown on button
  String caption;
  
  /**
   * Constructor
   *
   * @param  x      co-ord
   * @param  y      co-ord
   * @param  w      width
   * @param  h      height
   * @param  text   button text    
   */ 
  ButtonControl(float x, float y, float w, float h, String caption) {
    // Call the constructor of the superclass
    super(x, y, w, h);
    // Sets own properties 
    this.caption = caption;
  }
  
  /**
   * Overridden method, draws this control
   */
  void display() {
    // Border colour depending on disabled state        
    stroke(this.disabled ? Constants.CONTROL_COLOUR_DISABLED : Constants.CONTROL_COLOUR_ENABLED);
   
    // Draw button, colour depending on whether mouse over
    fill(this.over() ? Constants.CONTROL_COLOUR_ENABLED : Constants.CONTROL_COLOUR_BACKGROUND);
    rectMode(CORNER);
    rect(this.x, this.y, this.w, this.h, 5);

    // Text, colour depending on disabled state / or mouse over
    fill(this.over() ? Constants.CONTROL_COLOUR_BACKGROUND : this.disabled ? Constants.CONTROL_COLOUR_DISABLED : Constants.CONTROL_COLOUR_ENABLED);   
    textAlign(CENTER,CENTER);
    text(this.caption, this.x+(this.w/2), this.y+(this.h/2)-2);
  } 
}

/**
 * InputControl
 * 
 * Text entry control
 */ 
class InputControl extends Control {
  
  String value;
  int maxLength;
  boolean valid;

  /**
   * Constructor (String value)
   *
   * @param  x          co-ord
   * @param  y          co-ord
   * @param  w          width
   * @param  h          height
   * @param  label  
   * @param  maxLength  maximum length allowed
   * @param  value      string value
   */ 
  InputControl(float x, float y, float w, float h, String label, int maxLength, String value) {
    super(x, y, w, h, label);
    this.maxLength = maxLength;
    this.setValue(value);    
  }
  
  /**
   * Constructor (char value, no maxLength required, set internally)
   *
   * @param  x      co-ord
   * @param  y      co-ord
   * @param  w      width
   * @param  h      height
   * @param  label  
   * @param  value  char value 
   */  
  InputControl(float x, float y, float w, float h, String label, char value) {
    super(x, y, w, h, label);
    this.setValue(value);
    // Set maximum length to 1 as char
    this.maxLength = 1;
  }

  /**
   * Overloaded setter method for value (string) 
   */
  void setValue(String value) {
    this.value = value;
    this.validate();
  }

  /**
   * Overloaded setter method for value (char) 
   */
  void setValue(char value) {
    this.setValue(str(value));
  }
  
  /**
   * Validates the value
   *
   * @return  true  if valid
   */
  void validate() {
    this.valid = (this.value.length() > 0);
  }

  /**
   * Event method cascaded down from (Options) typed()
   *
   * Add key typed to value, if control has focus.
   * Remove last char from value if backspace typed.
   */
  void typed(char typedKey) {
    if(this.hasFocus) {      
      //TODO: This could be refactored a bit!
      if(typedKey==BACKSPACE && this.value.length() > 0) {
        this.value = this.value.substring(0, this.value.length()-1);
      } else {
        if(this.value.length() < this.maxLength && typedKey != BACKSPACE) {
          this.value += typedKey;
        }
      }             
    }  
    this.validate();
  }
  
  /**
   * Draw the input control
   */
  void display() {
    
    // Label
    fill(Constants.CONTROL_COLOUR_LABEL);
    textAlign(RIGHT, TOP);
    text(this.label, this.x, this.y);

    // Border
    if(this.valid) {
      stroke(this.disabled ? Constants.CONTROL_COLOUR_DISABLED : Constants.CONTROL_COLOUR_ENABLED);
    } else {
      stroke(Constants.CONTROL_COLOUR_INVALID);
    }
    
    // Input area
    fill(Constants.CONTROL_COLOUR_BACKGROUND);
    rectMode(CORNER);
    rect(this.x, this.y, this.w, this.h, 5);
    
    // Value
    fill(this.disabled ? Constants.CONTROL_COLOUR_DISABLED : Constants.CONTROL_COLOUR_ENABLED);
    textAlign(LEFT,CENTER);
    // Add a 'cursor' after value if it has focus
    text(this.value + (this.hasFocus ? '_' : ""), this.x+10, this.y+(this.h/2)-1);
  }
}

/**
 * ToggleControl
 * 
 * On/Off toggle button 
 */ 
class ToggleControl extends Control {

  boolean value;
  
  /**
   * Constructor
   *
   * @param  x      co-ord
   * @param  y      co-ord
   * @param  w      width
   * @param  h      height
   * @param  value  boolean value for On/Off    
   */ 
  ToggleControl(float x, float y, float w, float h, String label, boolean value) {
    super(x, y, w, h, label);
    this.value(value);
  }

  /**
   * Setter method for value
   */
  void value(boolean value) {
    this.value = value;
  }

  /**
   * This method call its superclass method of same name to determing wether to set value
   *
   * @return  true, if clicked
   */
  boolean clicked() {
    if(super.clicked()) { 
      this.value(!this.value);
      return true;
    } else {
      return false;
    }
  }

  /**
   * Draws the toggle control
   */
  void display() {
    
    // Label
    fill(Constants.CONTROL_COLOUR_LABEL);
    textAlign(RIGHT, TOP);
    text(this.label, this.x, this.y);
    
    // Outline
    stroke(this.disabled ? Constants.CONTROL_COLOUR_DISABLED : Constants.CONTROL_COLOUR_ENABLED);    
    fill(Constants.CONTROL_COLOUR_BACKGROUND);
    rectMode(CORNER);
    rect(this.x, this.y, this.w, this.h, this.h/2);
    
    // Switch
    noStroke();
    ellipseMode(CORNER);
    //TODO: This could be refactored a bit!
    if(this.value) {
      fill(this.disabled ? Constants.CONTROL_COLOUR_DISABLED  : Constants.CONTROL_COLOUR_ON);
      ellipse(this.x+(this.w/2)+2, this.y+2, this.h-3, this.h-3);
    } else {
      fill(this.disabled ? Constants.CONTROL_COLOUR_DISABLED  : Constants.CONTROL_COLOUR_OFF);
      ellipse(this.x+2, this.y+2, this.h-3, this.h-3);
    } 
  }
}

/**
 * SliderControl
 * 
 * Slider control with restricted value range
 */ 
class SliderControl extends Control {

  /**
   * SliderButtonControl
   * 
   * Slider part of the control, which moves with cursor when dragged
   */ 
  private class SliderButtonControl extends Control {
 
    // So we can access parent properties
    SliderControl parent;
    
    // Identifies when slider button has been 'grabbed' when dragging
    boolean grabbed;

    /**
     * SliderButtonControl class constructor
     *
     * @param  parent SliderControl     
     * @param  x      co-ord
     * @param  y      co-ord
     * @param  w      width
     * @param  h      height
     */
    SliderButtonControl(SliderControl parent, float x, float y, float w, float h) {
      super(x, y, w, h);
      this.parent = parent;
      this.grabbed = false;
      this.x = map(this.parent.value, this.parent.minValue, this.parent.maxValue, this.parent.x+(this.w/2), this.parent.x+this.parent.gaugeW-(this.w/2));      
    }

    /**
     * Event method cascaded down from (SliderControl) pressed() 
     */   
    void pressed() {
      // If mouse button pressed down while over control, set grabbed flag
      this.grabbed = this.over();
    }
  
    /**
     * Event method cascaded down from (SliderControl) released() 
     */   
    void released() {
      // If mouse button released, reset grabbed flag
      this.grabbed = false;
    }
  
    /**
     * Event method cascaded down from (SliderControl) dragged() 
     */   
    void dragged() {
      if(this.grabbed) {
        
        // As the mouse is being dragged, calculate the slider X from mouseX, keeping within boundaries of gauge
        this.x = constrain(mouseX, this.parent.x+(this.w/2), this.parent.x+this.parent.gaugeW-(this.w/2));

        // Calculate the value from the position of slider X
        this.parent.value(round(map(this.x, this.parent.x+(this.w/2), this.parent.x+this.parent.gaugeW-(this.w/2), this.parent.minValue, this.parent.maxValue)));           
      }
    }
    
    /**
     * Overriden method from superclass, as behaviour slightly different
     */
    boolean over()  {
      if(this.disabled) {
        return false;
      }  
      if (mouseX >= this.x-(this.w/2) && mouseX <= this.x+(this.w/2) && 
          mouseY >= this.y-(this.h/2) && mouseY <= this.y+(this.h/2)) {
        return true;
      } else {
        return false;
      }  
    }

    /**
     * Draw the slider button
     */
    void display() {
      
      // Slider Button
      fill(this.parent.disabled ? Constants.CONTROL_COLOUR_DISABLED : Constants.CONTROL_COLOUR_SLIDER);
      rectMode(CENTER);
      rect(this.x, this.y, this.w, this.h, this.h/2);
      
      // Value
      fill(this.parent.disabled ? Constants.CONTROL_COLOUR_BACKGROUND : Constants.CONTROL_COLOUR_ENABLED );
      textAlign(CENTER, CENTER);
      text(str(this.parent.value), this.x, this.y);     }
  }
  
  // SliderControl properties
  float gaugeW;
  float minValue;
  float maxValue;
  float value;
  
  // Slider Button
  SliderButtonControl sliderButton;

  /**
   * SliderControl Constructor
   *
   * @param  x      co-ord of gauge
   * @param  y      co-ord of gauge
   * @param  w      width of slider button
   * @param  h      height of slider button
   * @param  label
   * @param  min    minimum value allowed
   * @param  max    maximum value allowed
   * @param  value  float value 
   */
  SliderControl(float x, float y, float w, float h, String label, float minValue, float maxValue, float value) {
    super(x, y, w, h, label);
    this.minValue = minValue;
    this.maxValue = maxValue;
    this.value(value);    
    this.gaugeW = ((this.maxValue - this.minValue) / 2) * this.w;
    this.sliderButton = new SliderButtonControl(this, map(this.value, this.minValue, this.maxValue, this.x+(this.w/2), this.x+this.gaugeW-(this.w/2)), this.y, this.w, this.h);
  }

  /**
   * Setter method for value
   *
   * @param  value
   */   
  void value(float value) {
    this.value = value;
  }
  
  /**
   * Event method cascaded down from (Options) pressed() 
   */   
  void pressed() {
    this.sliderButton.pressed();
  }

  /**
   * Event method cascaded down from (Options) released() 
   */   
  void released() {
    this.sliderButton.released();
  }

  /**
   * Event method cascaded down from (Options) dragged() 
   */   
  void dragged() {
    this.sliderButton.dragged();
  }
  
  /**
   * Draw the slider control
   */
  void display() {
  
    // Label
    fill(Constants.CONTROL_COLOUR_LABEL);
    textAlign(RIGHT, CENTER);
    text(this.label, this.x, this.y);
    
    // Gauge
    stroke(this.disabled ? Constants.CONTROL_COLOUR_DISABLED : Constants.CONTROL_COLOUR_ENABLED);
    line(this.x, this.y, this.x+this.gaugeW, this.y);
    
    // Slider Button
    this.sliderButton.display();
  }
}

/**
 * Frame Control
 *
 * Framed border with title, used to group controls logically
 */
class FrameControl extends Control {
  String title;

  /**
   * Constructor
   *
   * @param  x          co-ord
   * @param  y          co-ord
   * @param  w          width
   * @param  h          height
   * @param  title  
   */
  FrameControl(float x, float y, float w, float h, String title) {
    super(x, y, w, h);
    this.title = title;      
  }

  /**
   * Draw the frame
   */
  void display() {
    
    // Border
    stroke(Constants.CONTROL_COLOUR_FRAME);
    noFill();
    rectMode(CORNER);
    rect(this.x, this.y, this.w, this.h, 5);

    // Title background
    noStroke();
    fill(Constants.CONTROL_COLOUR_BACKGROUND);    
    rect(this.x+10, this.y-10, textWidth(this.title)+2, 20);  
    
    // Title 
    fill(Constants.CONTROL_COLOUR_FRAME);
    textAlign(LEFT,CENTER);
    text(this.title, this.x+10, this.y);
  }
  
}
