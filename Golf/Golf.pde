Ball b;
Hole h;
Map m;

int totalStrokes = 0;
int strokes = 0;
int par = 0;
int coursePar = 0;
int level = 1;
int maxLevel = 10;

String report = "";

void setup()
{
  size(700,700);
  b = new Ball();
  b.x = 60;
  h = new Hole(225,225,40);
  m = new Map();
  m.setLevel(level);
  h.resetHole(m.holeX,m.holeY);
  par = m.par;
}

void draw()
{
  //background(0,150,30);
  m.drawMap();
  
  h.drawHole();
  b.drawBall();
  b.moveBall();
  b.applyTerrain( m.terrain( b.x/50, b.y/50 ) );
  checkForBounce();
  
  if(mousePressed)
  {
    strokeWeight(dist(mouseX,mouseY,b.x,b.y)/35);
    line(mouseX,mouseY,b.x,b.y);
  }
  
  if( dist(b.x,b.y,h.x,h.y) < h.size*2/3 )
    b.rollToward( h );
    
  if( dist(b.x,b.y,h.x,h.y) < .1 )
    nextLevel();
    
  drawHUD();
}

void mouseReleased()
{
  applyForceToBall();
  strokes++;
}

void applyForceToBall()
{
  float xForce=dist(b.x,0,mouseX,0)/10,
        yForce=dist(0,b.y,0,mouseY)/10;
  if( b.x < mouseX )
    xForce = -xForce;
  if( b.y < mouseY )
    yForce = -yForce;
    
  b.hitBall(xForce*2,yForce*2); //force doubled here
}

void checkForBounce()
{
  if( b.notOnEdge('x') && m.terrain((b.x-b.diameter/2)/50,b.y/50)==TileType.BLOCK )
  {
    b.x-=b.xSpeed;
    b.xSpeed = -b.xSpeed;
  }
  if( b.notOnEdge('x') && m.terrain((b.x+b.diameter/2)/50,b.y/50)==TileType.BLOCK )
  {
    b.x-=b.xSpeed;
    b.xSpeed = -b.xSpeed;
  }
  if( b.notOnEdge('y') && m.terrain(b.x/50,(b.y+b.diameter/2)/50)==TileType.BLOCK )
  {
    b.y-=b.ySpeed;
    b.ySpeed = -b.ySpeed;
  }
  if( b.notOnEdge('y') && m.terrain(b.x/50,(b.y-b.diameter/2)/50)==TileType.BLOCK )
  {
    b.y-=b.ySpeed;
    b.ySpeed = -b.ySpeed;
  }
}

void nextLevel()
{
  totalStrokes += strokes;
  strokes = 0;
  coursePar += par;
  if(level<maxLevel)
  {
    level++;
    totalStrokes += strokes;
    strokes = 0;
    m.setLevel(level);
    h.resetHole(m.holeX,m.holeY);
    b.x=m.ballX;
    b.y=m.ballY;
    par = m.par;
  }
}

void drawHUD()
{
  fill(0);
  textSize(20);
  if(level != maxLevel)
  {
    text("Hole: " + level,10,30);
    text("Par: " + par,10,50);
    text("Stroke: " + strokes,10,70);
  }
  else
  {
    text("Total Strokes: " + totalStrokes,10,30);
    text("Course Par: " + coursePar,10,50);
    if(totalStrokes < coursePar)
    {
      fill(50,200,50);
      report = "Performance: ";
    }
    else if(totalStrokes > coursePar)
    {
      fill(200,50,50);
      report = "Performance: +";
    }
    else
    {
      fill(0);
      report = "Performance: +-";
    }
    text(report + (totalStrokes-coursePar),10,70);
  }
}
