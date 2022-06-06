class Ball
{
  float x;
  float y;
  float xSpeed;
  float ySpeed;
  float xRoll;
  float yRoll;
  float diameter = 30;
  
  public Ball()
  {
    y = x = 50;
    xSpeed = ySpeed = xRoll = yRoll = 0;
  }
  
  public Ball( float xInput, float yInput, float xSpdInput, float ySpdInput )
  {
    x = xInput;
    y = yInput;
    xSpeed = xSpdInput;
    ySpeed = ySpdInput;
  }
  
  public void moveBall() //Ball is moving through walls at high speeds
  {
    x += min(xSpeed + xRoll,50);
    if( x < diameter/3 ) x = diameter/3;
    if( x > width-diameter/3 ) x = width-diameter/3;
    y += min(ySpeed + yRoll,50);
    if( y < diameter/3 ) y = diameter/3;
    if( y > height-diameter/3 ) y = height-diameter/3;
    if(x>width-diameter/2)
      xSpeed = -abs(xSpeed);
    if(x<diameter/2)
      xSpeed = abs(xSpeed);
    if(y>height-diameter/2)
      ySpeed = -abs(ySpeed);
    if(y<diameter/2)
      ySpeed = abs(ySpeed);
    applyFriction();
  }
  
  public void drawBall()
  {
    fill(255);
    stroke(0);
    strokeWeight(1);
    if( dist(x,y,h.x,h.y) < 30 && xSpeed < 1 && ySpeed < 1 ) //ball going in hole
      circle(x,y,dist(x,y,h.x,h.y));
    else
      ellipse(x,y,30,30);
  }
  
  public void applyFriction()
  {
    xSpeed /= 1.1;
    ySpeed /= 1.1;
    xRoll /= 1.1;
    yRoll /=1.1;
  }
  
  public void hitBall( float xPower, float yPower )
  {
    xSpeed += xPower;
    ySpeed += yPower;
  }
  
  public void rollToward( Hole target )
  {
    if( x < target.x )
      xSpeed += 0.05;
    else
      xSpeed -= 0.05;
    if( y < target.y )
      ySpeed += 0.05;
    else
      ySpeed -= 0.05;
  }
  
  public void applyTerrain( TileType t )
  {
    
    switch (t)
    {
      case SAND:      applyFriction();     break;
      case TILT_LEFT: xRoll -= abs(xSpeed+ySpeed)/20; break;
      case TILT_RIGHT:xRoll += abs(xSpeed+ySpeed)/20; break;
      case TILT_UP:   yRoll -= abs(xSpeed+ySpeed)/20; break;
      case TILT_DOWN: yRoll += abs(xSpeed+ySpeed)/20; break;
      default: break;
    }
  }
  
  public void bounce( char direction )
  {
    if(direction == 'x')
      xSpeed = -xSpeed;
    else if(direction == 'y')
      ySpeed = -ySpeed;
    else
      println("INVALID BOUNCE DIRECTION");
  }
  
  public boolean notOnEdge( char axis )
  {
    if(axis=='x')
    {
      if( x > 50 && x < 650 )
        return true;
    }
    if(axis=='y')
    {
      if( y > 50 && y < 650 )
        return true;
    }
    return false;
  }
}
