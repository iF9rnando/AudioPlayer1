class Rect {
  int x;
  int y;
  int size;
  float pulseAmount;
  boolean pulseDirection;
  
  Rect(int x, int y) {
    this.x = x;
    this.y = y;
    size = 25;
    pulseAmount = 0;
    pulseDirection = true;
  }
  
  void display() {
    fill(#202020);
    rect(x, y, size, size);
  }
  
  void pulse() {
    if (pulseDirection) {
      pulseAmount += 0.02; // Adjust the increment value for a slower pulse animation
      if (pulseAmount >= 1) {
        pulseAmount = 1;
        pulseDirection = false;
      }
    } else {
      pulseAmount -= 0.02; // Adjust the decrement value for a slower pulse animation
      if (pulseAmount <= 0) {
        pulseAmount = 0;
        pulseDirection = true;
      }
    }
    
    int newSize = (int) (size + (size * pulseAmount));
    int offset = (size - newSize) / 2;
    rect(x + offset, y + offset, newSize, newSize);
  }
}
