/**
 * Pronguino - Phorms
 *
 * Processing Forms
 *
 * @author  Neil Deighan
 *
 */

// TODO: Add Menu as child of Game ? 
// TODO: Maybe put more of logic/objects into Game (or another class within Game ?), keeping pronguino as top-level as possible ? 
// TODO: Remove options from Game, and if above, have Menu, Options and Game as top level objects, keeping this shorter ?
// TODO: Get Arduino to send two bytes per controller, to get more range of controller values, thus hopefully making paddle movement smoother 
// TODO: Allow change starting player, in options (Checkbox/Radio Button), by keyboard at serve state (Left/Right keys), by UNO pressing button of player "without ball" ?
// TODO: Assign a serve key for each player rather than just space ?
// TODO: ESC back to menu ?
// TODO: If controllers connected, and spacebar hit to serve, turn off indicator for serving player

// Import the serial library
import processing.serial.*;

// Declare Serial Port
Serial usbPort;

// Declare Game Objects
Surface surface;
Net net;
Ball ball;
Scoreboard[] scoreboards;
Player[] players;
Player player;
Game game;
Menu menu;

/**
 * Setup environment, create game objects, initialise serial communications
 */
void setup() 
{
  // Set Window size in pixels, these are refered to throughout code as "width" and "height" respectively,
  // and all game objects have been coded to be displayed relative to these, so you can have a really short game at 100 x 100,
  // or a really long game at say 1280 x 640, size() can also be replace with fullScreen().
  //
  // Note: Now that a playing surface has been added game objects are drawn relative to this, although the 
  //       surface as been drawn relative to "width" and "height".  
  size(800, 600);

  menu = new Menu();

  // Create Game
  game = new Game();

  // Set Frame Per Second (FPS)
  frameRate(game.options.framesPerSecond);

  // Create Surface
  surface = new Surface(75, 100); 

  // Create Net
  net = new Net();

  // Create Ball  
  ball = new Ball();

  // Create Scoreboards 
  float fontSize = game.options.scoreboardFontSize;
  PFont font = createFont(game.options.scoreboardFont, fontSize);

  // Create Players, each player will create its own paddle and controller
  players = new Player[Constants.PLAYER_COUNT];
  for (int index=0; index < Constants.PLAYER_COUNT; index++) {
    players[index] = new Player(index);
  }

  scoreboards = new Scoreboard[Constants.PLAYER_COUNT];
  scoreboards[Constants.PLAYER_ONE] = new Scoreboard(width/2-(fontSize*2), surface.y - fontSize*1.5, font, players[Constants.PLAYER_ONE]); 
  scoreboards[Constants.PLAYER_TWO] = new Scoreboard(width/2+(fontSize*0.25), surface.y - fontSize*1.5, font, players[Constants.PLAYER_TWO]);

  // Get Serial Port name .. change in Options once identified 
  // println(Serial.list());

  // Connect to serial port, just show error message for now,
  // the game will just continue to use keyboard controls 
  try {
    usbPort = new Serial(this, game.options.serialPortName, game.options.serialBaudRate);
  } 
  catch (Exception e) {
    if (e.getMessage().contains("Port not found")) {
      // Set warning message that controllers not connected, play still available with keyboard
      menu.setMessage("Controllers not connected", Constants.MESSAGE_COLOUR_WARNING);
      // Enable menu options
      menu.enable();
    } else {
      menu.setMessage(e.getMessage(), Constants.MESSAGE_COLOUR_ERROR);
    }
  }

  game.state = Constants.STATE_MENU;

  // Only set background the once, when debugging 
  if (game.options.debug.enabled) {   
    background(game.options.backgroundColour);
  }
}

/**
 * Called everytime a key is pressed 
 */
void keyPressed() {

  // Only check if game is playing ...
  if (game.inPlay()) {

    // Check if space key hit
    if (key == Constants.KEY_SPACE) {
      game.performAction();
    }

    // Check if any players control keys pressed
    for (Player player : players) {
      player.checkKeyPressed(key);
    }
  }
}

/**
 * Called everytime a key is released
 */
void keyReleased() {

  // Check if any players control keys released
  for (Player player : players) {
    player.checkKeyReleased(key);
  }
}

/**
 * Called everytime a key is typed
 */
void keyTyped() {
  // Only check further if on the options screen
  if (game.state == Constants.STATE_OPTIONS) {
    // Cascade down to game options
    game.options.typed(key);
  }
}

/**
 * Called everytime mouse button clicked
 */
void mouseClicked() {
  // Currently only need to check on menu ...
  if (game.state == Constants.STATE_MENU) {
    // Cascade down ..
    menu.clicked();
  }
  // ... and options screen
  if (game.state == Constants.STATE_OPTIONS) {
    // Cascade down
    game.options.clicked();
  }
}

/**
 * Called everytime mouse button pressed
 */
void mousePressed() {
  // Currently only need to check on options
  if (game.state == Constants.STATE_OPTIONS) {
    // Cascase down
    game.options.pressed();
  }
}

/**
 * Called everytime mouse button released
 */
void mouseReleased() {
  // Currently only need to check on options  
  if (game.state == Constants.STATE_OPTIONS) {
    // Cascase down    
    game.options.released();
  }
}

/**
 * Called everytime mouse button released
 */
void mouseDragged() {
  // Currently only need to check on options  
  if (game.state == Constants.STATE_OPTIONS) {
    // Cascase down   
    game.options.dragged();
  }
}

/**
 * Called when "Play" button on menu clicked
 */
void playButtonClicked() {
  // Apply any options that may have changed
  applyOptions();
  // Set State
  game.state = Constants.STATE_SERVE;
  // Start Game
  gameBegin();
}

/**
 * Called when "Options" button on menu clicked
 */
void optionsButtonClicked() {
  game.state = Constants.STATE_OPTIONS;
}

/**
 * Called when "Exit" button on menu clicked
 */
void exitButtonClicked() {
  exit();
}


/**
 * Called when controllers have initialized
 */
void controllerReady(Player player) {  
  // Set ready message
  menu.setMessage("Controllers Ready", Constants.MESSAGE_COLOUR_OK);
  // Enable menu options
  menu.enable();
}

/**
 * Called everytime controller button is pressed
 *
 * @param  playerIndex 
 */
void buttonPressed(int playerIndex) {

  if (game.state == Constants.STATE_SERVE) {
    for (Player player : players) {
      // Will only serve if player with ball button is pressed ..
      if (player.index == playerIndex && player.hasBall) {
        player.serve();
      }
    }
  } else {  
    game.performAction();
  }
}

/**
 * Called everytime controller button is released
 *
 * @param  playerIndex 
 */
void buttonReleased(int playerIndex) {
  // Nothing to do yet
}


/**
 * Called when controller indicator state changes
 */
void indicatorChanged(int playerIndex, int indicatorStatus) {

  if (players[playerIndex].controller.connected) {
    // Write data to Arduino, only if controller connected
    usbPort.write(Functions.getIndicatorData(playerIndex, indicatorStatus));
    // Small delay to allow processing
    delay(10);
  }
}

/**
 * Called when no data available
 */
void noDataAvailable() {
  // Stop moving paddles as no data ...
  for (Player player : players) {
    player.paddle.stopMoving();
  }
}

/** 
 * Apply options to game objects that have already been created
 */
void applyOptions() { 
  ball.applyOptions();
  for (Player player : players) {
    player.applyOptions();
  }
}

/**
 * Called when game paused
 */
void gamePaused() {
  noLoop();
}

/**
 * Called when game resumed
 */
void gameResumed() {
  loop();
}

/**
 * Called when new game started
 */
void gameBegin() {

  for (Player player : players) {
    
    // Clear Score
    player.score = 0;
  
    // Set paddle starting position
    if(player.controller.connected) {
      player.paddle.positionByController();
    } else {
      player.paddle.positionAtStart();
    }

    // Set Player to serve
    player.hasBall = (player.index == game.options.playerStartIndex);
    
    if (player.hasBall) {
      // Set starting position for ball      
      ball.positionAtPlayer(player);
      
      // Set Serve Indicator to on for player id it has ball
      if(player.controller.connected) {
        player.controller.indicator.setState(Constants.INDICATOR_STATE_ON);
      }
    }
  } 
}

/**
 * Called when player serves
 */
void playerServed(Player player) {
  // Set direction of ball from start position
  ball.directionAtStart(player);     
  // Set Game State
  game.state = Constants.STATE_STARTED;
  // Continue
  loop();
}


/**
 * Called everytime data is received from the serial port
 */
void serialEvent(Serial usbPort) {

  // Is there any data available ?
  while (usbPort.available() > 0) {

    // Get the data from port
    byte data = (byte)usbPort.read();

    // Split data into two nibbles .. one for each players controller    
    int highNibble = Functions.getHighNibble(data);
    int lowNibble = Functions.getLowNibble(data);

    // Set the value of each controller (first 3 bits of nibble ... 0-7)
    players[Constants.PLAYER_ONE].controller.setValue(highNibble & Constants.DATA_BITS_VALUE);    
    players[Constants.PLAYER_TWO].controller.setValue(lowNibble & Constants.DATA_BITS_VALUE);
    
    // Set the state of each controllers button (4th or most significant bit of each nibble ... 0-1)
    players[Constants.PLAYER_ONE].controller.button.setState((highNibble & Constants.DATA_BITS_STATE) >> 3); 
    players[Constants.PLAYER_TWO].controller.button.setState((lowNibble & Constants.DATA_BITS_STATE) >> 3);

    // Small delay before getting any further data, 
    // this is quite a crucial delay, see what happens 
    // when reduced to say 10 ... really threw me when I 
    // was trying to get paddle to move with controller! 
    delay(100);
  } 
  noDataAvailable();
}

/**
 * The code within this function runs continuously in a loop
 */
void draw() 
{  

  // Move the ball
  switch(game.state) {
  case Constants.STATE_STARTED:
    ball.move();
    break;
  case Constants.STATE_SERVE:
    // Move the ball with the players paddle
    for (Player player : players) {
      if (player.hasBall) {
        ball.positionAtPlayer(player);
      }
    }
    break;
  }

  // Move player paddles
  for (Player player : players) {
    player.paddle.move();
  }

  // Check if the ball hits the surface boundary
  if (ball.hitsBoundary()) {
    try {
      // This will only cause error if we provided an invalid parameter, try it
      ball.bounce(Constants.AXIS_VERTICAL);
    } 
    catch (Exception e) {
      // Just show error message for now
      // the game will continue, but you will see some strange movements
      println(e.getMessage());
    }
  }   

  // Check if player paddle hits the surface boundary
  for (Player player : players) {
    if (player.paddle.hitsBoundary()) {
      // Reposition
      player.paddle.positionAtBoundary();
      // Stop
      player.paddle.stopMoving();
    }
  }

  // Check if player paddle hits ball
  for (Player player : players) {
    if (player.paddle.hits(ball)) {

      // Debug
      if (game.options.debug.enabled && game.options.debug.playerHitsBall) {
        ball.display(true);
        saveFrame("debug/Player("+player.index+")-Paddle"+player.paddle.location+"-Hits-Ball"+ball.location);
      }

      // Reposition
      ball.reposition(player);

      // Debug
      if (game.options.debug.enabled && game.options.debug.ballReposition) {
        saveFrame("debug/Ball-Position"+ ball.location+"-At-Player("+player.index+")-Paddle"+player.paddle.location);
      }

      // Bounce
      try {
        // This will only cause error if we provided an invalid parameter, try it.
        ball.bounce(Constants.AXIS_HORIZONTAL);
      } 
      catch (Exception e) {
        // Just show error message for now, the game will continue, but you will see some strange movements
        println(e.getMessage());
      }
    }
  }

  // Check if player paddle misses ball
  for (Player player : players) {
    if (player.paddle.misses(ball)) {
      // Add point to other players score
      players[player.index^1].score++;

      // Set the current player to serve
      player.hasBall = true;
      players[player.index^1].hasBall = false;

      // Move to ball to players paddle
      ball.positionAtPlayer(player);

      // Set Serve Indicator to on for player
      player.controller.indicator.setState(Constants.INDICATOR_STATE_ON);

      // Waiting to serve
      game.state = Constants.STATE_SERVE;
    }
  }

  // Check for winner
  for (Player player : players) {
    if (player.score == Constants.SCORE_MAX) {    

      // Game Ended
      game.state = Constants.STATE_ENDED;
      noLoop();
    }
  }

  // Display ..
  switch(game.state) {
    case Constants.STATE_MENU:
      background(game.options.backgroundColour);
      menu.display();
      break;
    case Constants.STATE_OPTIONS:
      background(game.options.backgroundColour);
      game.options.display();
      break;
    default:
      // Set background in draw() when not debugging, as it needs to be drawn every frame. 
      if (!game.options.debug.enabled) {   
        background(game.options.backgroundColour);
      }
      // ... Game objects
      surface.display();
      net.display();
      ball.display(false);
      for (Player player : players) {
        scoreboards[player.index].display();
        player.paddle.display();
      }
      break;
  }    

  // Saves an image of screen every frame, which can be used to make a movie
  // saveFrame("movie/frame-######.tif");
  // WARNING: Remove or comment if not in use, can fill up disk space if forgotton about
}
