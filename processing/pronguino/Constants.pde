/**
 * Constants
 *
 * Logically named constants to remove the need to use numbers in rest of code, make more understandable, and less error prone 
 *
 * @author  Neil Deighan
 */
 
 // TODO: Make some of these options i.e. SCORE_MAX ?
 // TODO: Add some of these constants into relevant classes ?
 
public static class Constants {

  static final int PLAYER_ONE = 0;               // Index for player 1
  static final int PLAYER_TWO = 1;               // Index for player 2
  static final int PLAYER_COUNT = 2;             // Number of players    

  static final int AXIS_HORIZONTAL = 1;          // Axes on which paddle or ball is moving/bouncing on
  static final int AXIS_VERTICAL = 2;

  static final int DIRECTION_LEFT = -1;          // Multiplier used on the x co-ord of ball to go left
  static final int DIRECTION_RIGHT = 1;          // Multiplier used on the x co-ord of ball to go right
  static final int DIRECTION_UP = -1;            // Multiplier used on the y co-ord of paddle to go up
  static final int DIRECTION_DOWN = 1;           // Multiplier used on the y co-ord of paddle to go down
  static final int DIRECTION_OPPOSITE = -1;      // Multiplier used on the x/y co-ord of ball/paddle to go in opposite direction
  static final int DIRECTION_NONE = 0;           // Multiplier used on the x/y co-ord of ball/paddle stop

  static final int CONTROLLER_VALUE_MIN = 1;     // Minimum value (nibble) being received from controller input i.e. 0x0000 or 0000
  static final int CONTROLLER_VALUE_MAX = 7;     // Maximum value (nibble) being received from controller input i.e. 0x0007 or 0111
  
  static final int SCORE_MAX = 10;               // Winning Score
  
  static final char KEY_SPACE = ' ';             // Space Character
  
  static final int STATE_SETUP = 0;              // Game setting up
  static final int STATE_STARTED = 1;            // Game started state
  static final int STATE_ENDED = 2;              // Game ended state 
  static final int STATE_PAUSED = 3;             // Game paused state
  static final int STATE_SERVE = 4;              // Game waiting to serve state
  static final int STATE_MENU = 5;               // Game menu showing
  static final int STATE_OPTIONS = 6;            // Game options showing
  
  static final IntList STATE_INPLAY = new IntList(Constants.STATE_STARTED, Constants.STATE_SERVE, Constants.STATE_PAUSED, Constants.STATE_ENDED);  // List of in-play states
  
  static final int DATA_BITS_NIBBLE = 0x0F;      // Bit mask used to extract nibble from data (00001111)
  static final int DATA_BITS_VALUE = 0x07;       // Bit mask used to extract value of controller from nibble (00000111)
  static final int DATA_BITS_STATE = 0x08;       // Bit mask used to extract state of button from nibble (00001000)
  
  static final int BUTTON_STATE_LOW = 0;         // Button unpressed
  static final int BUTTON_STATE_HIGH = 1;        // Button pressed
  
  static final int INDICATOR_STATE_OFF = 0;      // Serve Indicator Off  
  static final int INDICATOR_STATE_ON = 1;       // Serve Indicator On
  
  static final color MESSAGE_COLOUR_OK = #00ff00;          // OK Message / green
  static final color MESSAGE_COLOUR_WARNING = #ffff00;     // Warning Message / yellow
  static final color MESSAGE_COLOUR_INFO = #0000ff;        // Information Message / blue
  static final color MESSAGE_COLOUR_ERROR = #ff0000;       // Error Message / red
  
  static final color CONTROL_COLOUR_ENABLED = #ffffff;     // Enabled control colour / white
  static final color CONTROL_COLOUR_DISABLED = #404040;    // Disabled control colour / grey
  static final color CONTROL_COLOUR_BACKGROUND = #000000;  // Disabled control colour / black
  static final color CONTROL_COLOUR_LABEL = #ffffff;       // Control label colour / white
  static final color CONTROL_COLOUR_ON = #00ff00;          // Toggle control ON / green
  static final color CONTROL_COLOUR_OFF = #ff0000;         // Toggle control OFF / red
  static final color CONTROL_COLOUR_INVALID = #ff0000;     // Indication of invalid control value / red
  static final color CONTROL_COLOUR_SLIDER = #0000ff;      // Slider colour / blue
  static final color CONTROL_COLOUR_FRAME = #ffffff;       // Frame colour / white
 
  // Added for consistancy, but could be replaced with editable options, eventually
  static final color OPTIONS_COLOR_PLAYER_ONE = #ee181e;   // Player one colour (red)
  static final color OPTIONS_COLOR_PLAYER_TWO = #35b748;   // Player twi colour (green)
  static final color OPTIONS_COLOR_NET = #707070;          // Net colour (grey)
  static final color OPTIONS_COLOR_BACKGROUND = #000000;   // Game background (black)
  static final color OPTIONS_COLOR_BALL = #f2d223;         // Ball colour (yellow)

}
