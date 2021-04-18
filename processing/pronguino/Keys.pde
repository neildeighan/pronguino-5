/**
 * Keys
 *
 * Encapsulates the keys used for keyboard control of players paddle
 *
 * @author  Neil Deighan
 */
 
class Keys {

  char up;
  char down;

  /**
   * Class constructor
   *
   * @param  up    key character to move paddle up
   * @param  down  key character to move paddle down
   */
  Keys(char up, char down) {
    this.up = up;
    this.down = down;
  }
}
