/**
 * Menu
 *
 * Initial screen to show menu items i.e. Play, Options etc 
 *
 * @author  Neil Deighan
 */
 
 // TODO: Whilst displaying, continously check serial port for connectivity and update message accordingly ?
 // TODO: Have a "Controller Ready" message for each player, already have controllerConnected(...) method in place ?
 // TODO: "Progress/Loading/Connecting" graphic whilst waiting for buttons to enabled ?
 
class Menu {

  PImage titleImage;
  float imageX;
  float imageY;
  
  ButtonControl playButton;
  ButtonControl optionsButton;
  ButtonControl exitButton;
  
  String message;
  color messageColour;
  
  /**
   * Class Constructor
   */   
  Menu() {
    
    // Set image & position
    this.titleImage = loadImage("images/neildeighan-blog-pronguino-logo.png");
    this.imageX = (width/2)-(this.titleImage.width/2);
    this.imageY = (height/2)-(this.titleImage.height/2)-100;
    
    // Set buttons
    this.playButton = new ButtonControl(this.imageX+25,300,75,25,"Play");
    this.optionsButton = new ButtonControl(this.imageX+125,300,75,25,"Options");
    this.exitButton = new ButtonControl(this.imageX+225,300,75,25,"Exit");
    
    // Set status message
    this.message = "";
    this.messageColour = Constants.MESSAGE_COLOUR_OK;
    
    // Disable Play/Options buttons initially, until controllers confirmed as connected/not connected
    this.disable();    
  }

  /**
   * Event method cascaded down from (in this case ... pronguino) mouseClicked()
   */
  void clicked() {
    // Check if play button clicked ..
    if(this.playButton.clicked()) {
     // Call event method
     playButtonClicked();
   }
   
   // Check if options button clicked ..
   if(this.optionsButton.clicked()) {
     // Call event method     
      optionsButtonClicked();
    }
    
    // Check if exit button clicked ..
    if(this.exitButton.clicked()) {
     // Call event method      
      exitButtonClicked();
    }
  }
  
  /**
   * Set message & colour to display
   */
  void setMessage(String message, int messageColour) {
    this.message = message;
    this.messageColour = messageColour;
  }

  /**
   * Enable Play/Options buttons
   */
  void enable() {
    this.playButton.disabled = false;
    this.optionsButton.disabled = false;
  }
  
  /**
   * Disable Play/Options buttons
   */  
  void disable() {
    this.playButton.disabled = true;
    this.optionsButton.disabled = true;
  }
  
  /**
   * Draw menu
   */
  void display() {
    
    // Image
    image(this.titleImage, this.imageX, this.imageY );
    
    // Buttons
    this.playButton.display();
    this.optionsButton.display();
    this.exitButton.display();
    
    // Message
    fill(this.messageColour);
    textAlign(CENTER, CENTER);
    text(this.message, width/2, 375);
  }
  
}
