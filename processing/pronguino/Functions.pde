/**
 * Functions
 *
 * Functions that do not necessarily belong in a class, as they could be used elsewhere
 * these do not require an instance of Functions to be created.
 *
 * @author  Neil Deighan
 */
 
 // TODO: Add/Amend functions to be more generic
 
static class Functions {

  /**
   * Extracts a high nibble (first four bits) from a byte
   *
   * @param  data  byte to extract nibble from
   */
  static int getHighNibble(byte data) {
    return (data >> 4) & Constants.DATA_BITS_NIBBLE;
  }

  /**
   * Extracts a low nibble (last four bits) from a byte
   *
   * @param  data  byte to extract nibble from
   */
  static int getLowNibble(byte data) {
    return data & Constants.DATA_BITS_NIBBLE;
  }
  
  /**
   * Creates data byte to send to Arduino to change indicator state
   *
   * @param  playerIndex    index of player 
   * @param  indicatorState ON/OFF 
   */ 
  static int getIndicatorData(int playerIndex, int indicatorState) {
    return (playerIndex << 1) | indicatorState;
  }
  
}
