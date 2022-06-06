/******************
* Chaser Game     *
* Bennett Ritchie *
* Version 4.1     *
******************/

//Chaser Data
final int maxChasers = 50; //Maximum number of chasers
float coord[][] = new float[2][maxChasers]; //Coordinates of all chasers
float speed[][] = new float[2][maxChasers]; //Speeds of all chasers
float collision[][] = new float[2][maxChasers]; //Locations of collisions
float maxSpeed = 7, speedUp = 0.0; //Speed constraints
int chaserCount, timer = 0; //Tracking number of chasers in play
boolean collided[] = new boolean[maxChasers]; //Tracks recent collisions
boolean pause[] = new boolean[maxChasers]; //Tracks when chasers cannot collide
int warpCount = 0; //Counter to counteract corner hacks

//Player Data
int deathX = 0, deathY = 0; //Final position of player
float angle = 0.0; //Player's rotation
int points = 0, high = 0; //Player's points and high score
boolean jumping = false; //Player is jumping
float jumpSize = 1.0; //Size multiplier when jumping
int jumps = 1;

//Powerup Data
float jumpPowX = width/2, jumpPowY = height/2; //Initial position of jump powerup
int jumpPowerupTimer = 500; //Time between jump pickups
boolean jumpPowerupActive = false; //Jump Powerup is on the field
float slowDown = 0, slowPowX = 0, slowPowY = 0; //Initial position of slow powerup
boolean slowPowerupActive = false; //Slow Powerup is on the field
int slowPowerupTimer = 1000;//Time between slow pickups
float slowWave = 0.0, slowWaveX = 0, slowWaveY = 0; //Slow powerup data
boolean killPowerupActive = false, chaserIsDead[] = new boolean[maxChasers]; //Tracking dead chasers
int killPowerupTimer = 400; //Time between kill pickups
float killPowX = 0, killPowY = 0; //Location of kill powerup
int killCount = 0;

//Chaser Chat Data
final int chatOptions = 40, gloatOptions = 30, dieOptions = 20;
String chat[] = new String[chatOptions]; //List of chaser quotes
String gloat[] = new String[gloatOptions]; //List of game over quotes
String die[] = new String[dieOptions]; //List of chaser death quotes
int talking[] = new int[maxChasers]; //Tracks which chasers are talking and what they are saying
int chatTimer = 0, gloatChoice = 0, dieChoice = 0;

//Cheat Code Data
final int cheats = 15;
boolean cheat[] = new boolean[cheats];
//0=swapped, 1=magenta, 2=fog of war, 3=streaks
//4=black background, 5=green, 6=aliens, 7=rainbows
//8=fireballs, 9=blue, 10=bloating, 11=vanishing
//12=screen spin, 13=random, 14=emojis
float bloat = 0.0; //Amount of chaser bloat
float vanish = 0.0; //Amount of chaser transparency - may remove
float extraSpeed = 0.1; //Amount of increased chaser speed
int emoji = 0;

void setup()
{
  size(1000,1000);
  background(255);
  textSize(30);
  strokeWeight(2);
  noStroke();
  setupPowerups();
  setupChasers(); //sets chaser starting data
  setupChat(); //populates the chat options
  setupCheats(); //sets all cheats to OFF
}

void draw()
{
  if( chaserCount > 0 ) //Only updates if game in progress
  {
    repaintBackground();
    updatePickups();
    updateChasers();
    drawChasers();
    drawHUD();
  }
  drawPlayer();
  
  if(killCount >= maxChasers)
    endGame();
  
  if( chaserCount == 0 && mousePressed ) //Start new game
    resetGame();
    
  /*for(int i = 0; i < maxChasers; i++)
  {
    if(chaserIsDead[i])
      print("DEAD ");
    else
      print("ALIVE ");  
  }
  println(" ");*/
}

void setupChasers()
{
  chaserCount = 1;
  for( int i = 0; i < maxChasers; i++ ) //initial positions for chasers
  {
    coord[0][i] = random(width); //Random horizontal positions
    coord[1][i] = 1000; //Random vertical positions
    collision[0][i] = 0;
    collision[1][i] = 0; //No collisions active
    collided[i] = false;
    pause[i] = false;
    talking[i] = 0; //No chasers talking yet
  }
  gloatChoice = int(random(gloatOptions));
}

void setupPowerups()
{
  setupPowerups('j');
  setupPowerups('s');
  setupPowerups('k');
}

void setupPowerups( char x )
{
  if(x=='j')
  {
    jumpPowX = random(width);
    jumpPowY = random(height);
    jumpPowerupActive = false;
    jumpPowerupTimer = 300+chaserCount*10;
  }
  else if(x=='s')
  {
    slowPowX = random(width);
    slowPowY = random(height);
    slowPowerupActive = false;
    slowPowerupTimer = 900+chaserCount*12;
  }
  else if(x=='k')
  {
    killPowX = random(width);
    killPowY = random(height);
    killPowerupActive = false;
    killPowerupTimer = 400;
  }
}

void setupChat() //should have a number of options equal to chatOptions 
{
  chat[0] = "Where'd he go?";
  chat[1] = "Get him!";
  chat[2] = "So hungry...";
  chat[3] = "Guys, he's that way!";
  chat[4] = "I smell his fear!";
  chat[5] = "I HUNGER";
  chat[6] = "BRAAAAINS";
  chat[7] = "Every move you make...";
  chat[8] = "Locked on target!";
  chat[9] = "Stay on target!";
  chat[10] = "Think you're pretty clever, don't you?";
  chat[11] = "I feel queasy...";
  chat[12] = "He's too fast!";
  chat[13] = "I meant to do that.";
  chat[14] = "RUN COWARD";
  chat[15] = "I WILL FIND HIM";
  chat[16] = "Surround him!";
  chat[17] = "I'm getting dizzy...";
  chat[18] = "Just a matter of time...";
  chat[19] = "You can't run forever!";
  chat[20] = "#doom";
  chat[21] = "Too many cheat days...";
  chat[22] = "EXTERMINATE";
  chat[23] = "Better watch out.";
  chat[24] = "Nitro Boost!";
  chat[25] = "AAAAAHHHHH!";
  chat[26] = "Tonight I dine on triangle!";
  chat[27] = "You killed my brother! Prepare to die!";
  chat[28] = "Vengance will be mine!";
  chat[29] = "I will find you. And I will kill you."; 
  chat[30] = "Do NoT rUn We ArE yOuR fRiEnDs";
  chat[31] = "I'm getting angry!";
  chat[32] = "Must go faster.";
  chat[33] = "How is he this fast?";
  chat[34] = "Dinner time!";
  chat[35] = "Nothing personal.";
  chat[36] = "Do you bleed?";
  chat[37] = "Clever girl.";
  chat[38] = "Give us a kiss!";
  chat[39] = "Seize him!"; 
  
  gloat[0] = "OM NOM NOM";
  gloat[1] = "Your soul is mine!";
  gloat[2] = "Target eliminated.";
  gloat[3] = "GIT GUD SKRUB";
  gloat[4] = "REKT";
  gloat[5] = "All your base are belong to us.";
  gloat[6] = "Game Over";
  gloat[7] = "Destroyed!";
  gloat[8] = "Delicious";
  gloat[9] = "Veni Viti Vici";
  gloat[10] = "Tora! Tora! Tora!";
  gloat[11] = "VICTORY";
  gloat[12] = "Is that all you got?";
  gloat[13] = "That's game!";
  gloat[14] = "Checkmate";
  gloat[15] = "Noob";
  gloat[16] = "YOU. SHALL NOT. PASS.";
  gloat[17] = "*munch*";
  gloat[18] = "Only human.";
  gloat[19] = "And they said you were good.";
  gloat[20] = "*crunch*";
  gloat[21] = "Mission Accomplished";
  gloat[22] = "LOSER!";
  gloat[23] = "WE ARE THE CHAMPIONS";
  gloat[24] = "Too easy.";
  gloat[25] = "Piece of cake.";
  gloat[26] = "WASTED";
  gloat[27] = "Thou art dead.";
  gloat[28] = "End of the line.";
  gloat[29] = "The master will be pleased.";
  
  die[0] = "OUCH";
  die[1] = "*zap*";
  die[2] = "IT BURNS!";
  die[3] = "I'm alergic to lasers!";
  die[4] = "NO!";
  die[5] = "I'll get you next time, Gadget.";
  die[6] = "Nani!?";
  die[7] = "Why me?";
  die[8] = "Bye.";
  die[9] = "POW";
  die[10] = "BOOM";
  die[11] = "MY FACE";
  die[12] = "!!!";
  die[13] = "Not like this...";
  die[14] = "MEGAKILL";
  die[15] = "MASSIVE DAMAGE";
  die[16] = "TARGET DESTROYED";
  die[17] = "BZZZT";
  die[18] = "MY LEG";
  die[19] = "MY CABBAGES";
}

void setupCheats()
{
  for( int i = 0; i < cheats; i++ )
    cheat[i]=false;
}

void chat() //Displays chaser chat
{
  fill(185,0,20); //Red text
  textSize(40); //Increased text size
  for(int i = 0; i < chaserCount; i++) //Cycles through chasers to make them talk 
    if(talking[i]!=0 && !chaserIsDead[i])
      text(chat[talking[i]],coord[0][i],coord[1][i]-40); 
}

void deathChat( int target )
{
  fill(180,0,0);
  textSize(40);
  text(die[int(random(dieOptions))],coord[0][target],coord[1][target]);
}

void chatOn() //Make a chaser start talking
{
  int x = int(random(chaserCount));
  talking[x]=int(random(chatOptions));
  chatTimer = 0;
}

void quiet() //Chasers stop talking
{
  for(int i = 0; i < chaserCount; i++)
    talking[i] = 0;
}

void repaintBackground() //Draws a transparent rectangle on the screen
{
  if(cheat[4]) //Draws a black background
    if(cheat[3])
      fill(0,5);
    else
      fill(0,50);
  else          //Draws a white background
    if(cheat[3])
      fill(255,5);
    else
      fill(255,50);
  noStroke();
  rect(0,0,width,height);
  if(chaserCount==0)
    endGame();
}

void drawPlayer() //Draw the player avatar, normally a spinning gold triangle
{
  fill(100,100,0);
  if( chaserCount > 0 ) //draws player if game in progress
  {
    translate(mouseX,mouseY); //move the 0,0 point on top of the player
    rotate(angle); //spin canvas
    if(!cheat[0])
      triangle(-13*jumpSize,13*jumpSize,0,-13*jumpSize,+13*jumpSize,+13*jumpSize);
    else //players and chasers swapped
    {
      fill(0);
      ellipse(0,0,25*jumpSize,25*jumpSize);
      fill(100,100,0);
    }
    if(!cheat[12]) //disables the un-spin if cheat is on
      rotate(-angle); //un-spin canvas
    translate(-mouseX,-mouseY); //move 0,0 point back
  }
  else //draws dead player
  {
    //print("draw dead");
    triangle(deathX-10,deathY+10,deathX,deathY-10,deathX+10,deathY+10);
    textSize(40);
    text(gloat[gloatChoice],deathX-100,deathY-40);
  }
  
  if(jumping) //Jump
    jumpSize += 0.1;
  if(jumpSize > 3)
    jumping = false;
  if(!jumping && jumpSize > 1)
    jumpSize-=0.1;
  if(jumpSize < 1)
    jumpSize = 1;
    
  if(slowDown > 0)
  {
    slowDown-=0.01;
    noFill();
    stroke(0,130,0);
    strokeWeight(5);
    circle(slowWaveX,slowWaveY,slowWave);
    noStroke();
    slowWave+=30;
  }
  if(slowDown < 0)
    slowDown = 0;
  
  angle += .02; //Spins player
  if(angle > 2*PI) //Resets angle by 360 degrees
    angle -= 2*PI;
}

void updateChasers()
{
  //Chat
  if( chatTimer > 210 && chaserCount != 0)
    chatOn();
  if( chatTimer >70 )
    quiet();
  chat(); 
  
  updateSpeeds(); //chaser speeds
  updatePositions(); //chaser positions
  
  if( timer > 100 && chaserCount < maxChasers && chaserCount!=0 ) //adds new chaser
    { chaserCount++; timer = 0; }
  
  checkForCollisions(); //Collision with player or chasers
}

void updateSpeeds()
{
  for( int i = 0; i < chaserCount; i++) //increases or decreases both x and y speed based on position relative to player
  {
    if(coord[0][i] < mouseX && speed[0][i] < (maxSpeed-slowDown))
      speed[0][i]+=speedUp+extraSpeed;
    if(coord[0][i] > mouseX && speed[0][i] > -(maxSpeed-slowDown))
      speed[0][i]-=speedUp+extraSpeed;
    if(coord[1][i] < mouseY && speed[1][i] < (maxSpeed-slowDown))
      speed[1][i]+=speedUp+extraSpeed;
    if(coord[1][i] > mouseY && speed[1][i] > -(maxSpeed-slowDown))
      speed[1][i]-=speedUp+extraSpeed;
      
    coord[0][i]+=speed[0][i];
    coord[1][i]+=speed[1][i];
  }
  timer++;
  chatTimer++;
  points++;
}

void updatePositions() //Moves chasers
{
  for( int i = 0; i < chaserCount; i++) //changes chaser positions
  {
    if(collided[i]) //Draws collision animations
    {
      drawCollision(collision[0][i],collision[1][i]);
      collided[i]=false;
    }

    if(coord[0][i] > width) //Loop across right side
      coord[0][i] -= width-10;
    else if(coord[0][i] < 0) //Loop across left side
    {
      coord[0][i] += width-10;
      warpCount++;  //Corner hack prevention
      if(warpCount>=50)
        cornerWarp(i,"left");
    }
    if(coord[1][i] > height)
      coord[1][i] -= height-10;
    else if(coord[1][i] < 0)
    {
      coord[1][i] += height-10;
      warpCount++;  //Corner hack prevention
      if(warpCount>=50)
        cornerWarp(i,"right");
    }
  }
}

void updatePickups()
{
  updateJumpPickup();
  updateSlowPickup();
  updateKillPickup();
}

void updateKillPickup()
{
 if(!killPowerupActive && killPowerupTimer <= 0)
    killPowerupActive = true;
    
  if(!killPowerupActive)
    killPowerupTimer--;
  else
  {
    fill(130,0,0);
    ellipse(killPowX,killPowY,30,30);
  }
  
  if(killPowerupActive && mouseX < killPowX+20 && mouseX > killPowX-20
                       && mouseY < killPowY+20 && mouseY > killPowY-20)
    {
      killCount++;
      fill(200,0,0);
      text("+100", killPowX-20, killPowY-20);
      chaserIsDead[chooseKillTarget()] = true;
      setupPowerups('k');
      points += 100;
    } 
}

void updateJumpPickup()
{
  if(!jumpPowerupActive && jumpPowerupTimer <= 0)
    jumpPowerupActive = true;
    
  if(!jumpPowerupActive)
    jumpPowerupTimer--;
  else
  {
    fill(0,0,130);
    ellipse(jumpPowX,jumpPowY,30,30);
  }
  
  if(jumpPowerupActive && mouseX < jumpPowX+20 && mouseX > jumpPowX-20
      && jumpSize == 1.0 && mouseY < jumpPowY+20 && mouseY > jumpPowY-20)
    {
      fill(0,0,200);
      text("+100", jumpPowX-20, jumpPowY-20);
      stroke(0,0,130);
      strokeWeight(3);
      line(jumpPowX,jumpPowY,600,30);
      circle(jumpPowX,jumpPowY,30);
      noStroke();
      strokeWeight(1);
      setupPowerups('j');
      jumps++;
      points += 100;
    }
}

void updateSlowPickup()
{
  if(!slowPowerupActive && slowPowerupTimer <= 0)
    slowPowerupActive = true;
    
  if(!slowPowerupActive)
    slowPowerupTimer--;
  else
  {
    fill(0,130,0);
    ellipse(slowPowX,slowPowY,30,30);
  }
  
  if(slowPowerupActive && mouseX < slowPowX+20 && mouseX > slowPowX-20
                       && mouseY < slowPowY+20 && mouseY > slowPowY-20)
    {
      fill(0,200,0);
      text("+100", slowPowX-20, slowPowY-20);
      slowWaveX = slowPowX;
      slowWaveY = slowPowY;
      setupPowerups('s');
      slowDown = 6;
      slowWave = 0.0;
      points += 100;
    }
}

int chooseKillTarget()
{
  int target = 0;
  float smallest = width+height;
  for(int i = 0; i < chaserCount; i++)
    if( !chaserIsDead[i] && dist(coord[0][i],coord[1][i],killPowX,killPowY) < smallest )
    {
      smallest = dist(coord[0][i],coord[1][i],killPowX,killPowY);
      target = i;
    }
  strokeWeight(10);
  stroke(200,0,0);
  line(coord[0][target],coord[1][target],killPowX,killPowY);
  deathChat(target);
  //if(chaserIsDead[maxChasers-1])
    if(allDead())
    {
      print("XXXXXXXXXXXXXXXXX");
      fill(150,150,0);
      textSize(50);
      text("VICTORY",mouseX,mouseY);
      endGame();
    }
  return target;
}

boolean allDead()
{
  for(int i = 0; i < maxChasers; i++)
    if(!chaserIsDead[i])
    {
      print(i + " is alive  ");
      return false;
    }
  print("ALL DEAD ");
  return true;
}

void checkForCollisions()
{
  for(int i = 0; i < chaserCount; i++)
  {  //checks to see if the player is within any chaser's reach
    if(mouseX < coord[0][i]+30 && mouseX > coord[0][i]-30
    && mouseY < coord[1][i]+30 && mouseY > coord[1][i]-30
    && jumpSize <= 1 && !chaserIsDead[i])
    {
      endGame();
    }
    for( int j = 0; j < chaserCount; j++) //chaser collisions
    {
      if(coord[0][j] < coord[0][i]+30 && coord[0][j] > coord[0][i]-30
      && coord[1][j] < coord[1][i]+30 && coord[1][j] > coord[1][i]-30
      && j != i && !pause[j])
      {
        speed[0][i] = -speed[0][i];
        speed[1][i] = -speed[1][i];
        pause[j]=true;
        collided[i] = true;
        collision[0][i] = coord[0][i]-((coord[0][i] - coord[0][j])/2);
        collision[1][i] = coord[1][i]-((coord[1][i] - coord[1][j])/2);
      }      
    }
  }
}

void drawChasers() //Could be cleaner
{
  for( int i = 0; i < chaserCount; i++ )//draws chasers
  {
    if(!chaserIsDead[i])
    {
      if(cheat[6]) //Aliens
        setColor(50,255,50,i);
  
      else if(cheat[5]) //Green
        setColor(30,90,0,i);
  
      else if(cheat[0]) //Swapped shapes
      {
        translate(coord[0][i],coord[1][i]);
        rotate(angle);
        fill(100,100,0,255-vanish);
        triangle(-28-bloat/2,28+bloat/2,bloat/2,-28-bloat/2,28+bloat/2,28+bloat/2);
        rotate(-angle);
        translate(-coord[0][i],-coord[1][i]);  
      }
      
      else if(cheat[1]) //Magenta
        setColor(277,0,136,i);
        
      else if(cheat[8]) //Fireballs
      {
        if(cheat[2])
        {
          fill(200,200,0,50-range(coord[0][i],coord[1][i])/1.3);
          ellipse(coord[0][i]-speed[0][i]*2,coord[1][i]-speed[1][i]*2,80,80);
          fill(200,150,0,100-range(coord[0][i],coord[1][i])/1.3);
          ellipse(coord[0][i]-speed[0][i],coord[1][i]-speed[1][i],70,70);
          fill(255,20,0,200-range(coord[0][i],coord[1][i])/1.3);
        }
        else
        {
          fill(200,200,0,50-vanish);
          ellipse(coord[0][i]-speed[0][i]*2,coord[1][i]-speed[1][i]*2,80,80);
          fill(200,150,0,100-vanish);
          ellipse(coord[0][i]-speed[0][i],coord[1][i]-speed[1][i],70,70);
          fill(255,20,0,200-vanish);
        }
      }
      
      else if(cheat[9]) //Blue
        setColor(0,0,255,i);
        
      else if(cheat[7]) //Rainbows
        setColor(coord[1][1]/4,coord[0][2]/4,coord[0][0]/4,i);
  
      else if(cheat[14]) //Emojis
        setColor(240,240,0,i);
       
      else
        setColor(0,0,0,i); //Black
      
      if(dist(int(coord[0][i]),int(coord[1][i]),int(slowWaveX),int(slowWaveY))==int(slowWave))
         setColor(0,180,0,i); //Stunned
          
      if(!cheat[0]) //Draws the chasers
        ellipse(coord[0][i],coord[1][i],60+bloat,60+bloat);
        
      if(cheat[6]) //Alien eyes
      {
        fill(200,255-vanish);
        ellipse(coord[0][i]+speed[0][i]*2,coord[1][i]+speed[1][i]*2,20,20);
        fill(0,255-vanish);
        ellipse(coord[0][i]+(speed[0][i]*2)+speed[0][i]/2,coord[1][i]+(speed[1][i]*2+2)+speed[1][i]/2,10,10);
      }
      
      if(cheat[14]) //Emoji Faces
        drawEmojiFace(i); //This was so much code that I put it in its own function
      
      fill(0); //Resets base colors
      noStroke();
      
      if(timer%50==0 && cheat[13]) //Activates the random color cheat
        colorToggle(int(random(10)));
      if(timer%5==0)
        pause[i]=false;   
    }
    if(cheat[10]) //Increases size if appropriate
      bloat += 0.1;
    else          //Deflates
    {
      if( bloat > 0 )
        bloat -= 0.5;
      if( bloat < 0 )
        bloat = 0.1;
    }
    if(cheat[11]) //Applies vanishing fade
      vanish = chaserCount*7;
    else
    {
      if( vanish > 0 )
        vanish -= 5;
      if( vanish < 0 )
        vanish = 0;
    }
  }
}

void drawCollision( float x, float y ) //Draws collision animations
{
  fill( 127,200 );
  ellipse(x,y,60,60);
}

void drawHUD() //Score, highscore, chaser count
{
  textSize(30);
  if(chaserCount!=0) //Game in progress
  {
    text("Score: " + points,20,40);
    text("High Score: " + high,225,40);
    text("Jumps: " + jumps,530,40);
  }
  else //Game ended
  {
    fill(255);
    rect(0,0,300,60); //Provides a background to make score readable
    fill(0); 
    text("Final Score: " + points,20,40);
  }
  text("Active Chasers: " + chaserCount, width/1.4, 40);
}

float range( float x, float y ) //Distance from coordinates to player
{
  float biggerDist;
  biggerDist = abs(x-mouseX);
  if( biggerDist < abs(y-mouseY))
    biggerDist = abs(y-mouseY);
  return biggerDist;
}

void cornerWarp( int x, String side )
{
  if( side.equals("left") )
    coord[0][x] = 0;
  if( side.equals("right") )
    coord[0][x] = 0;
  coord[1][x] = height;
  warpCount = 0; 
}

void endGame()
{
  for(int i = 0; i < chaserCount; i++) //stops chasers moving
  {
    speed[0][i] = 0;
    speed[1][i] = 0;
  }
  chaserCount = 0; //end of game trigger
  deathX = mouseX;
  deathY = mouseY;
  if(points > high)//update high score
    high = points;
}

void resetGame()
{
  setupChasers();
  setupPowerups();
  points=0;
  deathX = 0;
  deathY = 0;
  jumps = 1;
  slowDown = 0;
  killCount = 0;
}

void mousePressed()
{
  if( cheat[14] )
    emoji++;
}

void keyPressed()
{
  if( key == 'a' )
    colorToggle(6);
  
  if( key == 'f' )
    colorToggle(8);
  
  if( key == 'b' )
    colorToggle(9);
  
  if( key == 'r' )
    colorToggle(7);

  if( key == 'u' )
    cheat[4] = true;
    
  if( key == 'w' )
    cheat[4] = false;
    
  if( key == 'z' )
  {
    extraSpeed = 0.1;
    for( int i = 0; i < cheats; i++ )
      cheat[i]=false;
  }
  if( key == 'p' )
    cheat[3] = !cheat[3];
    
  if( key == 'l' )
    cheat[10] = !cheat[10];
  
  if( key == 'v' )
  {
    if(!cheat[11])
    {
      cheat[11] = true;
      cheat[2] = false;
    }
    else
      cheat[11] = false;
  }
  if( key == 'x' )
    extraSpeed *= 2;
  
  if( key == 'h' )
  {
    if(!cheat[2])
    {
      cheat[2] = true;
      cheat[11] = false;
    }
    else
      cheat[2] = false;
  }
  if( key == 'm' )
    colorToggle(1);
    
  if( key == '`' )
    cheat[12] = !cheat[12];
  
  if( key == '\\' )
    cheat[0] = !cheat[0];
    
  if( key == 'g' )
    colorToggle(5);
    
  if( key == 'n' )
    cheat[13] = !cheat[13];
   
  if( key == 'e' )
    colorToggle(14);
    
  if( key == 32 )
    if(jumpSize == 1.0 && jumps > 0 && chaserCount > 0)
    {
      fill(160,110,0);
      ellipse(mouseX,mouseY,60,60);
      jumps--;
      jumping = true;
    }
  
}

void colorToggle( int t ) //Change chaser color
{
  for( int i = 0; i < cheats; i++ )
  {
     if( i == 1 //magenta
      || i == 6 //aliens
      || i == 7 //rainbows
      || i == 8 //fireballs
      || i == 9 //blue
      || i == 5 //green
      || i == 14 //emojis
      || i == 0 )//swapped
      {
       if( i == t )
         cheat[i] = true;
       else
         cheat[i] = false;
      }
  }
}

void setColor( float r, float g, float b, int i )
{
  if(cheat[2])
    fill(r,g,b,255-range(coord[0][i],coord[1][i])/1.3);
  else
    fill(r,g,b,255-vanish);
}

void drawEmojiFace( int i )
{
  if(emoji % 3 == 0) //Grin
  {
    stroke(0);
    fill(0);
    ellipse(coord[0][i]-12-bloat/5,
            coord[1][i]-12-bloat/5,
            5,5);
    ellipse(coord[0][i]+12+bloat/5,
            coord[1][i]-12-bloat/5,
            5,5);
    fill(255);
    arc(coord[0][i],
        coord[1][i]+5+bloat/5,
        35+bloat/3,30,0,PI,CHORD);
    noStroke();
  }
  else if(emoji % 3 == 1) //Tongue
  {
    stroke(0);
    line(coord[0][i]-20-bloat/5,
         coord[1][i]-12-bloat/5,
         coord[0][i]-10-bloat/5,
         coord[1][i]-12-bloat/5);
    line(coord[0][i]+20+bloat/5,
         coord[1][i]-12-bloat/5,
         coord[0][i]+10+bloat/5,
         coord[1][i]-12-bloat/5);
    line(coord[0][i]-17-bloat/5,
         coord[1][i]+5+bloat/5,
         coord[0][i]+17+bloat/5,
         coord[1][i]+5+bloat/5);
    noStroke();
    fill(255,70,70);
    rect(coord[0][i]-5-bloat/5,
         coord[1][i]+5+bloat/5,10,15);
    arc(coord[0][i],coord[1][i]+19,
        10,10,0,PI);
    stroke(0);
    line(coord[0][i],
         coord[1][i]+5+bloat/5,
         coord[0][i],
         coord[1][i]+18+bloat/5);
  }
  else //Angry
  {
    fill(0);
    stroke(0);
    ellipse(coord[0][i]-12-bloat/5,
            coord[1][i]-12-bloat/5,
            5,5);
    ellipse(coord[0][i]+12+bloat/5,
            coord[1][i]-12-bloat/5,
            5,5);
    line(coord[0][i]-20-bloat/5,
         coord[1][i]-20-bloat/5,
         coord[0][i]-10-bloat/5,
         coord[1][i]-17-bloat/5);
    line(coord[0][i]+20+bloat/5,
         coord[1][i]-20-bloat/5,
         coord[0][i]+10+bloat/5,
         coord[1][i]-17-bloat/5);
    fill(255);
    arc(coord[0][i],
        coord[1][i]+15+bloat/5,
        35+bloat/3,30,PI,PI*2,CHORD);
    stroke(200,0,0);
    noFill();
    translate(coord[0][i]+20+bloat/5,
              coord[1][i]-25-bloat/5);
    for(int j = 0; j < 4; j++)
    {
      rotate(HALF_PI);
      arc(0,8,8,8,PI,2*PI);
    }
    translate(-(coord[0][i]+20+bloat/5),
              -(coord[1][i]-25-bloat/5));
    noStroke();
  }
}
