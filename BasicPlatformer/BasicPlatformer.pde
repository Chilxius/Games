/****************
Bennett Ritchie
Basic Platformer
****************/

Level currentLevel; //Level you're currently on
Level L_1; //First Level
Level L_2; //Second Level
Level L_3; //Third Level
Level L_4; //Fourth level
Level L_5; //Fifth level
Level L_6;
Level L_7;
Level L_8;
Level L_9;
Level L_10;
Level L_11;

//Creates the player
Jumper player;

//Current Level number
int levelNumber = 1;
//Max level
int levelCount = 11;

void setup()
{
  size(800,700);

  setupLevels();
  
  //Set current level to Level One
  currentLevel = L_1;
  
  //Start the player at the door
  player = new Jumper( L_1.doorX, L_1.doorY );
}

void draw()
{
  //Draw the Level
  currentLevel.drawLevel();
  
  //Move and draw the Player
  player.drawJumper();
  player.moveJumper();
  
  //Bounce Pad
  checkForBounce();
  //Did you get a key
  checkForTouchingKey();
  //Did you exit the door
  checkForExit();
}

//
///
////
///
//

void mousePressed()
{
  println( mouseX + " " + mouseY );
}

//Sets up level data - this method keeps the code out of setup()
void setupLevels()
{
  //Set up Level One's data
  L_1 = new Level();
  L_1.skyColor = color(50,50,100);
  L_1.blocksColor = color(150,120,0);
  L_1.p1 = new Platform(550,550);
  L_1.p2 = new Platform(50,550);
  L_1.p3 = new Platform(300,400);
  L_1.k1 = new Key(700,500);
  L_1.k2 = new Key(200,500);
  L_1.k3 = new Key(450,350);
  L_1.bounceX = 50;
  L_1.bounceY = 650;
  L_1.doorX = width/2;
  L_1.doorY = 600; 
  
  //Set up Level Two's data
  L_2 = new Level();
  L_2.skyColor = color(50,120,100);
  L_2.blocksColor = color(100,70,0);
  L_2.p1 = new Platform(600,550);
  L_2.p2 = new Platform(350,350);
  L_2.p3 = new Platform(100,150);
  L_2.k1 = new Key(700,500);
  L_2.k2 = new Key(450,300);
  L_2.k3 = new Key(200,100);
  L_2.bounceX = 400;
  L_2.bounceY = 650;
  L_2.doorX = 100;
  L_2.doorY = 600;  
  
  //Set up Level Three's data
  L_3 = new Level();
  L_3.skyColor = color(150,120,100);
  L_3.blocksColor = color(100,70,100);
  L_3.p1 = new Platform(600,150);
  L_3.p2 = new Platform(350,300);
  L_3.p3 = new Platform(100,150);
  L_3.k1 = new Key(700,100);
  L_3.k2 = new Key(450,100);
  L_3.k3 = new Key(200,100);
  L_3.bounceX = 200;
  L_3.bounceY = 400;
  L_3.doorX = 600;
  L_3.doorY = 600; 
  
  //Set up Level Four's data
  L_4 = new Level();
  L_4.skyColor = color(0);
  L_4.blocksColor = color(170);
  L_4.p1 = new Platform(600,100);
  L_4.p2 = new Platform(420,100);
  L_4.p3 = new Platform(220,100);
  L_4.k1 = new Key(675,200);
  L_4.k2 = new Key(600,200);
  L_4.k3 = new Key(750,200);
  L_4.bounceX = 650;
  L_4.bounceY = 600;
  L_4.doorX = 100;
  L_4.doorY = 600;
  
  //Set up Level 5's data
  L_5 = new Level();
  L_5.skyColor = color(40,50,100);
  L_5.blocksColor = color(230,200,200);
  L_5.p1 = new Platform(475,230);
  L_5.p2 = new Platform(475,140);
  L_5.p3 = new Platform(180,450);
  L_5.k1 = new Key(500,195);
  L_5.k2 = new Key(575,195);
  L_5.k3 = new Key(650,195);
  L_5.bounceX = 510;
  L_5.bounceY = 210;
  L_5.doorX = 550;
  L_5.doorY = 115;
  
  //Set up Level 6's data
  L_6 = new Level();
  L_6.skyColor = color(200,250,200);
  L_6.blocksColor = color(230,100,100);
  L_6.p1 = new Platform(110,550);
  L_6.p2 = new Platform(190,400);
  L_6.p3 = new Platform(270,250);
  L_6.k1 = new Key(550,222);
  L_6.k2 = new Key(550,333);
  L_6.k3 = new Key(550,444);
  L_6.bounceX = 0;
  L_6.bounceY = 0;
  L_6.doorX = 550;
  L_6.doorY = 550;
  
  //Set up Level 7's data
  L_7 = new Level();
  L_7.skyColor = color(40,50,100);
  L_7.blocksColor = color(230,200,200);
  L_7.p1 = new Platform(270,550);
  L_7.p2 = new Platform(190,400);
  L_7.p3 = new Platform(110,250);
  L_7.k1 = new Key(550,444);
  L_7.k2 = new Key(550,333);
  L_7.k3 = new Key(550,222);
  L_7.bounceX = 550;
  L_7.bounceY = 590;
  L_7.doorX = 550;
  L_7.doorY = 115;
  
  //Set up Level 8's data
  L_8 = new Level();
  L_8.skyColor = color(0);
  L_8.blocksColor = color(10);
  L_8.p1 = new Platform(-50,450);
  L_8.p2 = new Platform(500,300);
  L_8.p3 = new Platform(0,50);
  L_8.k1 = new Key(170,55.5);
  L_8.k2 = new Key(700,55);
  L_8.k3 = new Key(400,620);
  L_8.bounceX = 0;
  L_8.bounceY = 0;
  L_8.doorX = 400;
  L_8.doorY = 400;
  
  //Set up Level 9's data
  L_9 = new Level();
  L_9.skyColor = color(0);
  L_9.blocksColor = color(255);
  L_9.p1 = new Platform(500,500);
  L_9.p2 = new Platform(500,300);
  L_9.p3 = new Platform(500,100);
  L_9.k1 = new Key(210,260);
  L_9.k2 = new Key(210,130);
  L_9.k3 = new Key(600,-1000);
  L_9.bounceX = 600;
  L_9.bounceY = 30;
  L_9.doorX = 115;
  L_9.doorY = 600;
  
  //Set up Level 10's data
  L_10 = new Level();
  L_10.skyColor = color(40,90,0);
  L_10.blocksColor = color(90,40,0);
  L_10.p1 = new Platform(300,500);
  L_10.p2 = new Platform(100,505);
  L_10.p3 = new Platform(500,505);
  L_10.k1 = new Key(100,65);
  L_10.k2 = new Key(400,65);
  L_10.k3 = new Key(700,65);
  L_10.bounceX = 0;
  L_10.bounceY = 0;
  L_10.doorX = 400;
  L_10.doorY = 600;
  
  //Set up Level 11's data
  L_11 = new Level();
  L_11.skyColor = color(40,90,100);
  L_11.blocksColor = color(90,40,100);
  L_11.p1 = new Platform(630,605);
  L_11.p2 = new Platform(430,580);
  L_11.p3 = new Platform(230,555);
  L_11.k1 = new Key(15,250);
  L_11.k2 = new Key(250,120);
  L_11.k3 = new Key(765,290);
  L_11.bounceX = 250;
  L_11.bounceY = 550;
  L_11.doorX = 420;
  L_11.doorY = 127;
}

//Checks if the player grabbed a key
void checkForTouchingKey()
{
  //If player touched key 1...
  if( currentLevel.k1.active && dist( player.x, player.y, currentLevel.k1.x, currentLevel.k1.y ) < 30 )
  {
    //remove key from screen
    currentLevel.k1.active = false;
    //add to player's key count
    player.keys++;
  }
  
  //If player touched key 2...
  if( currentLevel.k2.active && dist( player.x, player.y, currentLevel.k2.x, currentLevel.k2.y ) < 30 )
  {
    //remove key from screen
    currentLevel.k2.active = false;
    //add to player's key count
    player.keys++;
  }
  
  //If player touched key 3...
  if( currentLevel.k3.active && dist( player.x, player.y, currentLevel.k3.x, currentLevel.k3.y ) < 30 )
  {
    //remove key from screen
    currentLevel.k3.active = false;
    //add to player's key count
    player.keys++;
  }
}

//Checked if you touched the door with three keys
void checkForExit()
{
  if( player.keys == 3 && dist( player.x, player.y, currentLevel.doorX, currentLevel.doorY+5 ) < 30 )
  {
    if( levelNumber < levelCount )
    {
      levelNumber++;
      loadNextLevel();
    }
  }
}

//Checks if you touched the bounce pad
void checkForBounce()
{
  if( dist( player.x, player.y+10, currentLevel.bounceX, currentLevel.bounceY ) < 20 )
    player.ySpeed-=20;
}

//Loads the next level, if there is one
void loadNextLevel()
{
  println(levelNumber);
  if( levelNumber == 2 )
    currentLevel = L_2;
    
  if( levelNumber == 3 )
    currentLevel = L_3;
    
  if( levelNumber == 4 )
    currentLevel = L_4;
    
  if( levelNumber == 5 )
    currentLevel = L_5;
    
  if( levelNumber == 6 )
    currentLevel = L_6;
    
  if( levelNumber == 7 )
    currentLevel = L_7;
    
  if( levelNumber == 8 )
    currentLevel = L_8;
    
  if( levelNumber == 9 )
    currentLevel = L_9;
    
  if( levelNumber == 10 )
    currentLevel = L_10;
    
  if( levelNumber == 11 )
    currentLevel = L_11;
    
  //HERE IS WHERE YOU WOULD ADD NEW LEVELS
  
  player.keys = 0;
}

//Checks if the player is on the ground or a platform
boolean playerOnGround()
{
  //Checks platform 1
  if(player.x > currentLevel.p1.x
  && player.x < currentLevel.p1.x+200
  && player.y+20 > currentLevel.p1.y-5
  && player.y+20 < currentLevel.p1.y+20)
  {
    return true;
  }
  //Checks platform 2
  if(player.x > currentLevel.p2.x
  && player.x < currentLevel.p2.x+200
  && player.y+20 > currentLevel.p2.y-5
  && player.y+20 < currentLevel.p2.y+20)
  {
    return true;
  }
  //Checks platform 3
  if(player.x > currentLevel.p3.x
  && player.x < currentLevel.p3.x+200
  && player.y+20 > currentLevel.p3.y-5
  && player.y+20 < currentLevel.p3.y+20)
  {
    return true;
  }
  
  //Keep player from falling through the floor
  if(player.y >= 630)
    return true;
    
  return false;
}

//Keyboard Input
void keyPressed()
{
  if( keyCode == UP && playerOnGround() )
  {
    if(levelNumber == 10 )
      player.ySpeed-=20;
    else if( levelNumber == 11 )
      player.ySpeed-=5;
    else
      player.ySpeed-=15; // <- Normal
  }
  
  if( keyCode == LEFT )
    player.L=true;
    
  if( keyCode == RIGHT )
    player.R=true;
}

//More Keyboard Input
void keyReleased()
{
  if( keyCode == LEFT )
    player.L=false;
    
  if( keyCode == RIGHT )
    player.R=false;
}


//CLASS FOR THE PLAYER
class Jumper
{
  float x,y;
  float xSpeed, ySpeed;
  boolean falling;
  boolean L,R;
  int keys;
  
  public Jumper( float x, float y )
  {
    this.x = x;
    this.y = y;
    xSpeed = ySpeed = 0;
    falling = false;
    keys = 0;
  }
  
  public void drawJumper()
  {
    fill(255,0,0);
    ellipse(x,y,40,40);
    
    for( int i = 0; i < keys; i++ )
    {
      int xPos = 20+15*i;
      noStroke();
      fill(200,200,0);
      ellipse(xPos,15,12,12);
      rect(xPos-2,15,4,20);
      rect(xPos-2,24,7,4);
      rect(xPos-2,31,7,4);
      fill(currentLevel.skyColor);
      ellipse(xPos,15,5,5);
      stroke(1);
    }
  }
  
  public void moveJumper()
  {
    //Add speed if button is pressed
    if(L)
      xSpeed-=0.5;
    if(R)
      xSpeed+=0.5;
      
    //Keep speed from going too far
    if(xSpeed>10)
      xSpeed = 10;
    if(xSpeed<-10)
      xSpeed = -10;
    
    //Gravity
    if( !playerOnGround() )
      ySpeed +=.5;
    if(ySpeed > 0)
      falling = true;
    
    //Change player's position
    x += xSpeed;
    y += ySpeed;
    
    //Sideways friction
    if( playerOnGround() )
      xSpeed/=1.1;
    else
      xSpeed/=1.01;
    
    //Keep player on screen and from falling through platforms
    if( x > width )
      x = width;
    if( x < 0 )
      x = 0;
    if( y > 630 )
       y = 630;
    if( playerOnGround() && ySpeed > 0 && falling )
    {
      ySpeed = 0;
      falling=false;
    }
  }
}

//CLASS FOR PLATFORMS
class Platform
{
  float x,y;
  color c;
  
  public Platform( float x, float y )
  {
    this.x = x;
    this.y = y;
  }
  
  public void drawPlatform()
  {
    noStroke();
    rect(x,y,200,50);
  }
}

//CLASS FOR KEYS
class Key
{
  float x,y;
  boolean active;
  
  public Key( float x, float y )
  {
    this.x = x;
    this.y = y;
    active = true;
  }
  
  void drawKey()
  {
    noStroke();
    fill(200,200,0);
    ellipse(x,y,12,12);
    rect(x-2,y,4,20);
    rect(x-2,y+9,7,4);
    rect(x-2,y+16,7,4);
    fill(currentLevel.skyColor);
    ellipse(x,y,5,5);
    stroke(1);
  }
}

//CLASS FOR LEVEL
  //EACH LEVEL HAS THREE PLATFORMS AND THREE KEYS
class Level
{
  Platform p1, p2, p3;
  Key k1, k2, k3;
  
  float startX, startY, doorX, doorY;
  color skyColor, blocksColor;
  
  float bounceX, bounceY;
  
  //Draws the level, with its platforms and keys
  void drawLevel()
  {
    background(skyColor);
    if(k1.active) k1.drawKey();
    if(k2.active) k2.drawKey();
    if(k3.active) k3.drawKey();
    fill(blocksColor);
    p1.drawPlatform();
    p2.drawPlatform();
    p3.drawPlatform();
    rect(0,height-50,width,50);
    
    //Door
    fill(90,70,30);
    noStroke();
    ellipse(doorX,doorY,50,50);
    rect(doorX-25,doorY,50,50);
    fill(0);
    rect(doorX+15,doorY+10,4,10);
    
    //Bouncer
    fill(255,200,216);
    ellipse(bounceX,bounceY,20,10);
  }
}
