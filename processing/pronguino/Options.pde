/**
 * Options
 *
 * Configurable game options, some of the values are stored in a json file
 *
 * @author  Neil Deighan
 */
 
 // TODO: Split out, separate class for form / data etc ?
 // TODO: Make more options editable on form ?
 // TODO: Make some of these options constants ?
 // TODO: As with Debug, group other options into other classes ?
 // TODO: If a drop-down/list control added, could add list of serial ports to select/test ?
 
class Options {

  // Declare object for storing json data
  JSONObject optionsData;

  // Declare options that can be saved / loaded
  Debug debug;              // Debug toggle/options
  float ballSpeed;          // Number of pixels to add when moving ball
  float paddleSpeed;        // Number of pixels to add when moving paddle
  String[] names;           // Player Names
  Keys[] keys;              // Keys for paddle control (up, down) for players
  
  // Declare other options
  float framesPerSecond;    // Number of frames to be displayed every second
  float netWidth;           // Width of net element in pixels 
  float netHeight;          // Height of net element in pixels
  float netGap;             // Size of gap between net elements
  float ballRadius;         // Radius of ball in pixels 
  float paddleWidth;        // Width of paddle in pixels
  float paddleHeight;       // Height of paddle in pixels
  color backgroundColour;   // RGB value of background colour, hex format  
  String scoreboardFont;    // Name of font used for scoreboard, file must be in data folder
  float scoreboardFontSize; // Size of font, also used for positioning of scoreboard
  String serialPortName;    // Name of serial port when Arduino is plugged into USB port, use println(Serial.list()); in setup() to find which one to use
  int serialBaudRate;       // Baud rate of serial communications between Arduino and serial port, must be set same on both 
  float surfaceLineWidth;   // Width of borders / lines on playing surface in pixels
  color netColour;          // Net Colour
  color[] paddleColours;    // Paddle Colours
  color ballColour;         // Ball Colour
  int playerStartIndex;     // Index of player to serve first
  
  // Declare Form Controls
  FrameControl debugFrame;
  ToggleControl debugEnabledToggle;
  ToggleControl debugPlayerHitsBallToggle;
  ToggleControl debugBallRepositionToggle;
  ToggleControl debugPaddleHitsBoundaryToggle;
  ToggleControl debugBallHitsBoundaryToggle;   
  
  FrameControl speedFrame;
  SliderControl ballSpeedSlider;
  SliderControl paddleSpeedSlider;
  
  FrameControl[] playerFrames;
  InputControl[] playerNameInputs;
  InputControl[] playerUpInputs;
  InputControl[] playerDownInputs;
 
  ButtonControl okButton;
  ButtonControl cancelButton;
  
  /**
   * Class Constructor
   */
  Options() {

    // Load Options
    this.read();
    
    // Default other options
    this.framesPerSecond = 60.0;            
    this.netWidth = 2.0;                     
    this.netHeight = 6.0;                  
    this.netGap = 5.0;                        
    this.ballRadius = 5.0;
    this.paddleWidth = 10.0;                
    this.paddleHeight = 50.0;               
    this.backgroundColour = Constants.OPTIONS_COLOR_BACKGROUND;                                
    this.scoreboardFont = "Orbitron-Medium.ttf";     
    this.scoreboardFontSize = 48.0;         
    this.serialPortName = "/dev/ttyACM0";  
    this.serialBaudRate = 9600;
    this.surfaceLineWidth = 3;
    this.netColour = Constants.OPTIONS_COLOR_NET;                         
    this.paddleColours = new color[Constants.PLAYER_COUNT];   
    this.paddleColours[Constants.PLAYER_ONE] = Constants.OPTIONS_COLOR_PLAYER_ONE;
    this.paddleColours[Constants.PLAYER_TWO] = Constants.OPTIONS_COLOR_PLAYER_TWO;
    this.ballColour = Constants.OPTIONS_COLOR_BALL;                         
    this.playerStartIndex = Constants.PLAYER_ONE;
    
    // Create Form Controls
    this.debugFrame = new FrameControl(80,100,300,200,"Debugging");   
    this.debugEnabledToggle = new ToggleControl(220,120,40,20, "Enabled", this.debug.enabled);
    this.debugPlayerHitsBallToggle = new ToggleControl(220,150,40,20, "Player Hits Ball", this.debug.playerHitsBall);
    this.debugBallRepositionToggle = new ToggleControl(220,180,40,20, "Ball Reposition", this.debug.ballReposition);
    this.debugPaddleHitsBoundaryToggle = new ToggleControl(220,210,40,20, "Paddle Hits Boundary", this.debug.paddleHitsBoundary);
    this.debugBallHitsBoundaryToggle = new ToggleControl(220,240,40,20, "Ball Hits Boundary", this.debug.ballHitsBoundary);   

    this.speedFrame = new FrameControl(80,320,300,100,"Speed");
    this.ballSpeedSlider = new SliderControl(140, 340, 30, 20, "Ball", 1.0, 10.0, this.ballSpeed);
    this.paddleSpeedSlider = new SliderControl(140, 380, 30, 20, "Paddle", 1.0, 10.0, this.paddleSpeed); 

    this.playerFrames = new FrameControl[Constants.PLAYER_COUNT];
    this.playerNameInputs = new InputControl[Constants.PLAYER_COUNT];    
    this.playerUpInputs = new InputControl[Constants.PLAYER_COUNT];
    this.playerDownInputs = new InputControl[Constants.PLAYER_COUNT];
    
    this.playerFrames[Constants.PLAYER_ONE] = new FrameControl(400,100,300,150,"Player One");
    this.playerNameInputs[Constants.PLAYER_ONE] = new InputControl(450,120,200,20, "Name", 10, this.names[Constants.PLAYER_ONE]);    
    this.playerUpInputs[Constants.PLAYER_ONE] = new InputControl(450,150,50,20, "Up", this.keys[Constants.PLAYER_ONE].up);     
    this.playerDownInputs[Constants.PLAYER_ONE] = new InputControl(450,180,50,20, "Down", this.keys[Constants.PLAYER_ONE].down);
    
    this.playerFrames[Constants.PLAYER_TWO] = new FrameControl(400,270,300,150,"Player Two");
    this.playerNameInputs[Constants.PLAYER_TWO] = new InputControl(450,290,200,20, "Name", 10, this.names[Constants.PLAYER_TWO]);
    this.playerUpInputs[Constants.PLAYER_TWO] = new InputControl(450,320,50,20, "Up", this.keys[Constants.PLAYER_TWO].up);     
    this.playerDownInputs[Constants.PLAYER_TWO] = new InputControl(450,350,50,20, "Down", this.keys[Constants.PLAYER_TWO].down);   
    
    this.okButton = new ButtonControl(305,450,75,25,"OK");
    this.cancelButton = new ButtonControl(400,450,75,25,"Cancel");
  }

  /**
   * Load options from a json file
   */
  void read() {
    // Load object data
    this.optionsData = loadJSONObject("data/options.json");
    
    // Get debug options
    this.debug = new Debug();
    JSONObject debugOptions = optionsData.getJSONObject("debug");
    this.debug.enabled = debugOptions.getBoolean("enabled");
    this.debug.playerHitsBall = debugOptions.getBoolean("playerHitsBall");
    this.debug.ballReposition = debugOptions.getBoolean("ballReposition");
    this.debug.paddleHitsBoundary = debugOptions.getBoolean("paddleHitsBoundary");
    this.debug.ballHitsBoundary = debugOptions.getBoolean("ballHitsBoundary");
    
    // Get speed options
    this.ballSpeed = optionsData.getFloat("ballSpeed");                                       
    this.paddleSpeed = optionsData.getFloat("paddleSpeed");
    
    // Get players options
    JSONArray playersOptions = optionsData.getJSONArray("players");
    this.keys = new Keys[playersOptions.size()];
    this.names = new String[playersOptions.size()];
    for (int i = 0; i < playersOptions.size(); i++) {
      JSONObject playerOption = playersOptions.getJSONObject(i); 
      int id = playerOption.getInt("id");
      this.names[id] = playerOption.getString("name"); 
      this.keys[id] = new Keys(playerOption.getString("up").charAt(0), playerOption.getString("down").charAt(0));
    }  
  }
  
  /**
   * Get values from the controls into local properties 
   */
  void apply() {
    
    // Apply debug options
    this.debug.enabled = this.debugEnabledToggle.value;
    this.debug.playerHitsBall = this.debugPlayerHitsBallToggle.value;
    this.debug.ballReposition = this.debugBallRepositionToggle.value;
    this.debug.paddleHitsBoundary = this.debugPaddleHitsBoundaryToggle.value;
    this.debug.ballHitsBoundary = this.debugBallHitsBoundaryToggle.value;
    
    // Apply speed options
    this.ballSpeed = this.ballSpeedSlider.value;
    this.paddleSpeed = this.paddleSpeedSlider.value;
    
    // Apply players options
    for(int id = 0; id < Constants.PLAYER_COUNT; id++) {
      this.names[id] = this.playerNameInputs[id].value;
      this.keys[id].up = this.playerUpInputs[id].value.charAt(0);
      this.keys[id].down = this.playerDownInputs[id].value.charAt(0); 
    }    
  }  

  /**
   * Reset control values from local properties
   */
  void reset() {
    this.debugEnabledToggle.value = this.debug.enabled;
    this.debugPlayerHitsBallToggle.value = this.debug.playerHitsBall;
    this.debugBallRepositionToggle.value = this.debug.ballReposition;
    this.debugPaddleHitsBoundaryToggle.value = this.debug.paddleHitsBoundary;
    this.debugBallHitsBoundaryToggle.value = this.debug.ballHitsBoundary;
    
    this.ballSpeedSlider.value(this.ballSpeed);
    this.paddleSpeedSlider.value(this.paddleSpeed); 

    for(int id = 0; id < Constants.PLAYER_COUNT; id++) {
      this.playerNameInputs[id].setValue(this.names[id]);
      this.playerUpInputs[id].setValue(this.keys[id].up);
      this.playerDownInputs[id].setValue(this.keys[id].down);
    }
  } //<>//
  
  /**
   * Write the options data to file
   */
  void write() {
  
    // Set debug options
    this.optionsData.getJSONObject("debug").setBoolean("enabled",this.debug.enabled);
    this.optionsData.getJSONObject("debug").setBoolean("playerHitsBall",this.debug.playerHitsBall);
    this.optionsData.getJSONObject("debug").setBoolean("ballReposition",this.debug.ballReposition);
    this.optionsData.getJSONObject("debug").setBoolean("paddleHitsBoundary",this.debug.paddleHitsBoundary);
    this.optionsData.getJSONObject("debug").setBoolean("ballHitsBoundary",this.debug.ballHitsBoundary);    

    // Set speed options
    this.optionsData.setFloat("ballSpeed", this.ballSpeed);
    this.optionsData.setFloat("paddleSpeed", this.paddleSpeed);
    
    // Set players options
    for (int i = 0; i < this.optionsData.getJSONArray("players").size(); i++) {
      JSONObject playerOption = this.optionsData.getJSONArray("players").getJSONObject(i);
      int id = playerOption.getInt("id");
      playerOption.setString("name", names[id]);
      playerOption.setString("up", str(keys[id].up));
      playerOption.setString("down", str(keys[id].down));      
    }
    
    // Save options to file
    saveJSONObject(this.optionsData, "data/options.json");
  }

  /**
   * Checks all the controls on form are valid
   *
   * @return  true  if form valid 
   */
  boolean valid() {
    // Currently only input controls need validation ... 
    for (int id=0; id < Constants.PLAYER_COUNT; id++) {
      // ... this will return false if any of the controls are invalid
      if (!this.playerNameInputs[id].valid || !this.playerUpInputs[id].valid || !this.playerDownInputs[id].valid) {
        return false;
      }
    }
    // returns true on completion of loop, nothing invalid
    return true;
  }
  
  /**
   * Event method cascading down from (pronguino) mouseClicked()
   */
  void clicked() {
    
    // Call the clicked method of each control which will handle its own relevant checks/actions i.e. over(), set focus/value etc
    this.debugEnabledToggle.clicked();
    this.debugPlayerHitsBallToggle.clicked();
    this.debugBallRepositionToggle.clicked();
    this.debugPaddleHitsBoundaryToggle.clicked();
    this.debugBallHitsBoundaryToggle.clicked();
    
    this.ballSpeedSlider.clicked();
    this.paddleSpeedSlider.clicked();
    
    for (int id=0; id < Constants.PLAYER_COUNT; id++) { 
      this.playerNameInputs[id].clicked();
      this.playerUpInputs[id].clicked();
      this.playerDownInputs[id].clicked();      
    }

    if(this.okButton.clicked()) {
      this.okButtonClicked();
    }
    if(this.cancelButton.clicked()) {
      this.cancelButtonClicked();
    }
  }
  
  /**
   * Event method cascading down from (pronguino) mousePressed()
   */  
  void pressed() {
    // Call the pressed method of each control that implements it
    this.ballSpeedSlider.pressed();
    this.paddleSpeedSlider.pressed();
  }

  /**
   * Event method cascading down from (pronguino) mousePressed()
   */  
  void released() {
    // Call the released method of each control that implements it
    this.ballSpeedSlider.released();
    this.paddleSpeedSlider.released();
  }

  /**
   * Event method cascading down from (pronguino) mouseDragged()
   */  
  void dragged() {
     // Call the dragged method of each control that implements it    
     this.ballSpeedSlider.dragged();
     this.paddleSpeedSlider.dragged();
  }

  /**
   * Event method cascading down from (pronguino) keyTyped()
   */  
  void typed(char typedKey) {
    // Call the typed method of each control that implements it
    for (int id=0; id < Constants.PLAYER_COUNT; id++) {
      this.playerNameInputs[id].typed(typedKey);
      this.playerUpInputs[id].typed(typedKey);
      this.playerDownInputs[id].typed(typedKey);
    }
  }

  /**
   * Called when the OK button clicked
   */         
  void okButtonClicked() {
    // Apply options
    this.apply();
    // Save options
    this.write();    
    // Go back to menu
    game.state = Constants.STATE_MENU;
  }

  /**
   * Called when the Cancel button clicked
   */         
  void cancelButtonClicked() {
    // reset options
    this.reset();
    // Go Back to menu
    game.state = Constants.STATE_MENU;
  }
  
  /**
   * Disable controls where necessary 
   */         
  void disable() 
  {
    // Disable other debug options if debug not enabled ...
    boolean debugDisabled = !this.debugEnabledToggle.value;
    this.debugPlayerHitsBallToggle.disabled = debugDisabled;
    this.debugBallRepositionToggle.disabled = debugDisabled;
    this.debugPaddleHitsBoundaryToggle.disabled = debugDisabled;
    this.debugBallHitsBoundaryToggle.disabled = debugDisabled;

    // Testing enabled/disabled on other fields
    //this.ballSpeedSlider.disabled = debugDisabled;
    //this.paddleSpeedSlider.disabled = debugDisabled;

    //for (int id=0; id < Constants.PLAYER_COUNT; id++) { 
    //  playerNameInputs[id].disabled = debugDisabled;
    //  playerUpInputs[id].disabled = debugDisabled;
    //  playerDownInputs[id].disabled = debugDisabled;
    //}

    // Disable OK button if form not valid
    this.okButton.disabled = !this.valid();
  }
   
  void display() {
  
    // Disable controls
    this.disable();
    
    // Debug 
    this.debugFrame.display();
    this.debugEnabledToggle.display();
    this.debugPlayerHitsBallToggle.display();
    this.debugBallRepositionToggle.display();
    this.debugPaddleHitsBoundaryToggle.display();
    this.debugBallHitsBoundaryToggle.display();
    
    // Speed
    this.speedFrame.display();
    this.ballSpeedSlider.display();
    this.paddleSpeedSlider.display();
    
    /// Players
    for (int id=0; id < Constants.PLAYER_COUNT; id++) { 
      this.playerFrames[id].display();
      this.playerNameInputs[id].display();
      this.playerUpInputs[id].display();
      this.playerDownInputs[id].display();
    }

    // Buttons
    this.okButton.display();
    this.cancelButton.display();
  }
  
}
