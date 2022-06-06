class Hole
{
  float x,y,size;
  
  public Hole()
  {
    x = random(width);
    y = random(height);
    size = 40;
  }
  
  public Hole( float xInput, float yInput, float sizeInput )
  {
    x = xInput;
    y = yInput;
    size = sizeInput;
  }
  
  public void resetHole( float xIn, float yIn )
  {
    x = xIn;
    y = yIn;
  }
  
  public void drawHole()
  {
    fill(0);
    noStroke();
    ellipse(x,y,size,size);
  }
}
