//Bennett Ritchie
//Waterfall Ninja
//Version 1.4

int platformCount = 20; //30 for baby mode
final float gravity = .98;
int maxMission = 10; //8 for baby mode
int maxLevel = 1+maxMission*2;
float jumpX, jumpY, shurikenX = 0, shurikenY = 0, shotX = 0, shotY = 0;
float fireX = 0, fireY = 0, fireSize = 50, tentacleCrawlCount=0;
float speed = 0, fallSpeed = 0;
float flyerX = -25, flyerY = -25, flyerSpeed = 3, eyeOffsetX = 0, eyeOffsetY=0;
float platform[][];
float waveOffset = 0, shurikenAngle = 0, pinwheelAngle = 0;
int level = 0, mission = 1, bossX = width/2,
    bossHealth = 1, bossTimer = 0, bossLevel=1,
    explosionCount = 50, bossExplodeTimer=0,
    hooks = 2, line = 0,
    flyerTimer = 50, flyerHealth = 3,
    villagerCount = 7;
boolean weaponActive = false, bossActive = false, bossMovingRight = true, bossExploding = false,
        collisionOn = true, tentacleCrawlSwap = true, shotActive=false, shotRight=false,
        hookActive = false, pressingDown=false, flyerActive=false, flyerMovingRight = false;
float explodeCoord[][] = new float[2][explosionCount];
int explodeSize[] = new int[explosionCount];
float tentacleLength[] = new float[maxMission];
boolean pickup[] = new boolean[maxLevel+1];
boolean barrierOn[] = new boolean[3];
float pickupCoord[][] = new float[2][maxLevel+1];
color pinColorA, pinColorB;
color flyerColor[] = new color[4];
boolean flyerHasOrb = false, orbDropping = false;
float droppedOrbX=0, droppedOrbY=0, droppedOrbSpeed=0;
boolean hookDropping = false, canGetNewHook = true;
float droppedHookX=0, droppedHookY=0, droppedHookSpeed=0;
float villagerCoord[][] = new float[2][villagerCount];
float villagerBase[][] = new float[2][villagerCount];
color villagerColor[] = new color[villagerCount];
float villagerSpeed[][] = new float[2][villagerCount];
float deadBossY = -500;
boolean paused = false;
boolean classicControls = false;
boolean initialSetup = true;

int startupPhase = 0; //0 = controls, 1 = difficulty, 2 = game start
int gameDifficulty = 0;

void setup()
{
  size(650,900);
  jumpX=width/2;
  jumpY=height/2;
  rectMode(CENTER);
  pickup[7] = true;  //For intro screen
  pickup[13] = true;
  pickup[19] = true;
}

void draw()
{
  if(startupPhase < 2)
  {
    background(0);
    drawJumper( jumpX, jumpY );
    drawLogo();
    drawPrompt(startupPhase);
    pickup[5]=true;
  }
  else
  {
    if(initialSetup)
    {
      setupStuff();
      initialSetup = false;
    }
    
    background(0,0,150);
    if(mission<=maxMission)
    {
      drawWater();
      movePlatforms();
      drawPlatforms();
      if(hookActive)
        grapple();
      moveJumper();
      drawJumper( jumpX, jumpY );
      if(level == 0)
        drawSpray();
      if(bossActive)
      {
        if(!bossExploding)
          drawFireball();
        drawBoss();
      }
    
      if(bossExploding)
      {
        if(bossExplodeTimer>0)
          bossExplodeTimer--;
        if(bossExplodeTimer<5)
          collisionOn = false;
      }
      if(shotActive)
      {
        moveShot();
        drawShot();
      }
      
      drawHUD();
      cuePickup();
      cueFlyer();
      drawFlyer();
      
      pinwheelAngle-=.03;
      if(pinwheelAngle <= 0)
        pinwheelAngle += 2*PI;
      
      if(orbDropping)
        orbFalls();
        
      if(hookDropping)
        hookFalls();
      
      if(barrierUp(level))
      {
        drawBarrier(level);
        checkBarrier();
      }
      
      if(weaponActive) //Had to move this to after boss due to rotation issues
      {
        moveShuriken();
        drawShuriken();
      }
    
      if(!keyPressed)
        slow();
  
    }
    else //Victory Screen
    {
      removePlatforms();  //Move this to a once-only location
      drawWater(); 
      deadBossY++;
      drawDeadBoss();
      drawVillage(); //testing
      moveVillagers();
      moveJumper();
      drawJumper( jumpX, jumpY );
      if(!keyPressed)
        slow();
    }
  }
}

void drawLogo()
{
  textSize(75);
  fill(50,75,150);
  text("WATERFALL", 80,200);
  fill(150,50,50);
  text("NINJA",380,250);
}

void drawPrompt(int x)
{
  if(x==0)
    drawControlPrompt();
  else if(x==1)
    drawDifficultyPrompt();
}

void drawControlPrompt()
{
  if(classicControls)
  {
    drawButton(150,700,'W',0);
    drawButton(100,750,'A',1);
    drawButton(150,750,'S',2);
    drawButton(200,750,'D',3);
    
    drawButton(500,700,'I',4);
    drawButton(450,750,'J',5);
    drawButton(500,750,'K',6);
    drawButton(550,750,'L',5);
  }
  else
  {
    drawButton(500,700,"UP",0,false);
    drawButton(450,750,"LFT",1,false);
    drawButton(500,750,"DWN",2,false);
    drawButton(550,750,"RT",3,false);
    
    drawButton(150,700,'W',4);
    drawButton(100,750,'A',5);
    drawButton(150,750,'S',6);
    drawButton(200,750,'D',5);
  }
    textSize(20);
    fill(250);
    text("Press SPACE to change control scheme",137,600);
    text("Press any key to continue",197,640);
    if(classicControls)
      text("CLASSIC",285,720);
    else
      text("ARROWS",285,720);
}

void drawDifficultyPrompt()
{ 
  noStroke();
  fill(195,175,135);
  rect(width/3-5,height*.8,60,70);
  fill(90,70,30);
  rect(width/3-5,height*.8-32,80,6);
  rect(width/3-5,height*.8+32,80,6);
  fill(180,160,120);
  rect(width/3-5,height*.8-32,70,14,5);
  rect(width/3-5,height*.8+32,70,14,5);
  
  fill(195,175,135);
  rect(2*width/3-5,height*.8,100,70);
  fill(90,70,30);
  rect(2*width/3-5,height*.8-32,120,6);
  rect(2*width/3-5,height*.8+32,120,6);
  fill(180,160,120);
  rect(2*width/3-5,height*.8-32,110,14,5);
  rect(2*width/3-5,height*.8+32,110,14,5);
  
  textSize(20);
  fill(250);
  text("Choose a difficulty:",237,600);
  fill(50);
  text("EASY",width/3-30,height*.8-5);
  text("1",width/3-12,height*.8+20);
  text("NORMAL",2*width/3-48,height*.8-5);
  text("2",2*width/3-12,height*.8+20);
}

void drawButton(int x, int y, String c, int image, boolean b ) //there's a better way to do this
{
  strokeWeight(1);
  stroke(255);
  fill(190,180,170);
  rect(x,y,40,40);
  fill(210,200,190);
  rect(x,y,35,35);
  textSize(15);
  fill(0);
  text(c,x-15,y-3);
  
  textSize(10);
  if(image == 0)
    text("Jump",x-12,y+10);
  else if(image == 1)
    text("Left",x-12,y+10);
  else if(image == 2)
    text("Down",x-12,y+10);
  else if(image == 3)
    text("Right",x-12,y+10);
    
  else if(image == 4)
    drawLittleShuriken(x,y);
  else if(image == 5)
    drawLittleShot(x,y);
  else if(image == 6)
    drawHookIcon(x-3,y+5);
}

void drawButton(int x, int y, char c, int image )
{
  strokeWeight(1);
  stroke(255);
  fill(190,180,170);
  rect(x,y,40,40);
  fill(210,200,190);
  rect(x,y,35,35);
  textSize(15);
  fill(0);
  text(c,x+3,y-3);
  
  textSize(10);
  if(image == 0)
    text("Jump",x-12,y+10);
  else if(image == 1)
    text("Left",x-12,y+10);
  else if(image == 2)
    text("Down",x-12,y+10);
  else if(image == 3)
    text("Right",x-12,y+10);
    
  else if(image == 4)
    drawLittleShuriken(x,y);
  else if(image == 5)
    drawLittleShot(x,y);
  else if(image == 6)
    drawHookIcon(x-3,y+5);
}

void drawLittleShot(int x, int y)
{
  strokeWeight(1);
  stroke(125);
  fill(100);
  quad(x+15,y,x,y+5,x-15,y,x,y-5);  
}

void drawLittleShuriken(int x, int y)
{
  strokeWeight(1);
  stroke(125);
  fill(100);
  triangle(x,y-10,x+2,y,x-2,y);
  triangle(x,y+10,x+2,y,x-2,y);
  triangle(x,y-2,x,y+2,x-10,y);
  triangle(x,y-2,x,y+2,x+10,y);
}

void drawDeadBoss()
{
  translate(width/2,deadBossY);
  
  rotate(.2*PI);
  noStroke();
  fill(#FF7300);  //head
  ellipse(0,0,100,100);
  stroke(#DB1600);  //eyes
  strokeWeight(5);
  line(15,0,35,20);
  line(15,20,35,0);
  line(-15,0,-35,20);
  line(-15,20,-35,0);
  rotate(-(.2*PI));
    
  strokeWeight(15); //Tentacles
  stroke(#FF7300);
  noFill();
  rotate(PI/4);
  for( int i = 0; i < 4; i++ )
  {
    rotate(2*PI/4);
    arc(37.5,-150-deadBossY/5,75,50,0,PI);
    arc(-37.5,-150-deadBossY/5,75,50,PI,2*PI);
  }
  rotate(-PI/4);
  
  translate(-width/2,-deadBossY);

}

void drawVillage()
{
  noStroke();
  fill(50,150,0);
  rect(width/2,height,width,230);
  fill(110,90,50);
  rect(width/2,height,width,50);
  fill(90,70,30);
  rect(width/2,height,width,30);
  
  fill(90,70,30);
  rect(width/4,height-100,200,100);
  rect((width/4)*3,height-100,200,100);
  fill(190,170,130);
  quad(width/4-130,height-120,width/4-105,height-200,width/4+105,height-200,width/4+130,height-120);
  quad((width/4)*3-130,height-120,(width/4)*3-105,height-200,(width/4)*3+105,height-200,(width/4)*3+130,height-120);
  
  for( int i = 0; i < villagerCount; i++ ) //Draw Villagers
  {
    noStroke();
    fill(villagerColor[i]);
    if(i%4==0)
      ellipse(villagerCoord[0][i],villagerCoord[1][i],30,30);
    else
      ellipse(villagerCoord[0][i],villagerCoord[1][i],50,50);
  }
}

void removePlatforms()
{
  for(int i = 0; i < platformCount; i++)
  {
    platform[0][i]=0;
    platform[1][i]=0;
  }
}

boolean barrierUp( int lvl )
{
  if( ( lvl == 6 && barrierOn[0] )
  ||  ( lvl == 12 && barrierOn[1] ) 
  ||  ( lvl == 18 && barrierOn[2] ) )
    return true;
  return false;
}

void checkBarrier()
{
  if( jumpY<150 )
  {
    if( ( level == 6 && !pickup[1] )
    ||  ( level == 12 && !pickup[9] )
    ||  ( level == 18 && !pickup[17] ) )
    barrierOn[(level/6)-1]=false;
    else
    {
      fallSpeed+=30;
      jumpY-=5;
    }
  }
}

void drawBarrier( int lvl )
{
  noStroke();
  if( lvl == 6 )
    fill(255,0,0,9);
  else if( lvl == 12 )
    fill(0,255,0,9);
  else
    fill(0,0,255,9);
    
  for( int i = 0; i < 20; i++ )
    rect(width/2,0,width,15*i);
}

void cueFlyer()
{
  if(level != 0  //Countdown to launch
  && !flyerActive )
    flyerTimer--;

  if( !flyerActive  //Get off if hurt
  && flyerX > -45
  && flyerX < width+45 )
  {
    if( flyerMovingRight )
      flyerX-=9;
    else
      flyerX+=9;
  }
  
  if( flyerMovingRight && flyerX > width + 200 ) //Gone too far right
  {
    flyerMovingRight=false;
    flyerY=random(height-300);
    flyerSpeed=random(1,level/2);
  }
  if( !flyerMovingRight && flyerX < -200 ) //Gone too far left
  {
    flyerMovingRight=true;
    flyerY=random(height-300);
    flyerSpeed=random(1,level/2);
  }

  if( flyerTimer<=0 )  //Ready to go again
  {
    flyerActive=true;
    //canGetNewHook = true;
  }
  
  if( flyerActive && level != 0 )  //Normal Movement
  {
    if( flyerMovingRight )
    {
      flyerX+=flyerSpeed;
      flyerY++;
      if(flyerY > jumpY-50 && flyerY < jumpY+50 && jumpX > flyerX)
        flyerX+=1+(level/3);
    }
    else
    {
      flyerX-=flyerSpeed;
      flyerY++;
      if(flyerY > jumpY-50 && flyerY < jumpY+50 && jumpX < flyerX)
        flyerX-=1+(level/3);
    }
    if(flyerY>=height+25)
      flyerY-=height+50;
  }
  
  if( flyerHealth <=0 && flyerActive) //Turn off if killed
  {
    flyerActive=false;
    if(flyerHasOrb)
    {
      flyerHasOrb=false;
      orbDropping=true;
      canGetNewHook=false;
      droppedOrbX = flyerX;
      droppedOrbY = flyerY;
    }
    else if(hooks<4 && !hookDropping && canGetNewHook)
    {
      hooks++;
      canGetNewHook = false;
      hookDropping=true;
      droppedHookX=flyerX;
      droppedHookY=flyerY;     
    }
  }
    
  if( flyerHealth <= 0 && flyerX < -25 //dead and off left
  ||  flyerHealth <= 0 && flyerX > width + 25 ) //dead and off right
  {
    flyerHealth=3;
    flyerTimer=300;
  }
}

void orbFalls()
{
  droppedOrbSpeed+=gravity;
  droppedOrbY+=droppedOrbSpeed;
  if( level != activeOrb() )
    drawGem(activeOrb(),droppedOrbX,droppedOrbY);
  if(droppedOrbY>height+25)
  {
    orbDropping=false;
    droppedOrbSpeed=0;
  }
}

void hookFalls()
{
  droppedHookSpeed+=gravity;
  droppedHookY+=droppedHookSpeed;
    drawHookIcon(int(droppedHookX),int(droppedHookY));
  if(droppedHookY>height+25)
  {
    hookDropping=false;
    droppedHookSpeed=0;
  }
}

void drawFlyer()
{   
  eyeOffsetX = (jumpX-flyerX)/32.5;
  eyeOffsetY = (jumpY-flyerY)/45;

  noStroke();
  fill(flyerColor[flyerHealth]); //Change color with damage
  ellipse(flyerX,flyerY,50,50);
  
  stroke(flyerColor[flyerHealth]); //Limbs
  strokeWeight(3);
  noFill();
  arc(flyerX,flyerY-25,60,50,0,PI);
  arc(flyerX,flyerY-20,75,40,0,PI);
  arc(flyerX,flyerY+25,60,50,PI,2*PI);
  arc(flyerX,flyerY+20,75,40,PI,2*PI);
  
  fill(255);  //Eye
  ellipse(flyerX+eyeOffsetX,flyerY+eyeOffsetY,20,20);
  fill(flyerColor[flyerHealth]);  //Iris
  if(flyerHasOrb)
  {
    if(activeOrb()==1)
      stroke(255,0,0);
    else if(activeOrb()==9)
      stroke(0,255,0);
    else
      stroke(0,0,255);
  }
  //ellipse(flyerX+eyeOffsetX*1.2,flyerY+eyeOffsetY*1.2,11,11); //WHERE IS THE PHANTOM IRIS COMING FROM??
  fill(0);  //Pupil
  ellipse(flyerX+eyeOffsetX*1.2,flyerY+eyeOffsetY*1.2,10,10);
  fill(flyerColor[flyerHealth]);  //Eyelid
  stroke(flyerColor[flyerHealth]);
  //strokeWeight(1);
  //stroke(0);
  arc(flyerX+eyeOffsetX,flyerY+eyeOffsetY,22,22,1.2*PI,1.8*PI,OPEN);
  arc(flyerX+eyeOffsetX,flyerY+eyeOffsetY,22,22,.3*PI,.7*PI,OPEN);
  

}

void cuePickup()
{
  if(pickup[level] && level != bossLevel)
  {
    drawPickup(level);
    if(dist(jumpX,jumpY,pickupCoord[0][level],pickupCoord[1][level])<50)
    {
      if( flyerHasOrb && ( level==1 || level == 9 || level == 17 ) );
      else  //Don't pick up stolen orbs
        pickup[level]=false;
      if(isBoost(level))
        boost();
      else if(isHook(level) && hooks < 4)
        hooks++;
    }
  }
}

boolean isGem( int x )
{
  if( x == 1
  ||  x == 9
  ||  x == 17 )
    return true;
  return false;
}

void drawPickup( int x )
{
  if( x == 0
  ||  x == 4
  ||  x == 8
  ||  x == 12
  ||  x == 20 )
    drawBoost();
  if( x == 2 || x == 16 )
    drawHook();
  if( x == 1 || x == 9 || x == 17 )
    drawGem(x);
  if( x == 5 )
    drawKunai(width/2,100);
  if( x == 11 )
    drawBoots(width/2,100);
  if( x == 15 )
    drawFireScroll(width/2,100);
  if( x == 7 )
    drawGi('y');
  if( x == 13 )
    drawGi('r');
  if( x == 19 )
    drawGi('b');
}

void drawGi(char rankColor)
{
  noStroke();
  
  if(rankColor=='y')
    fill(200,200,0);
  if(rankColor=='r')
    fill(200,0,0);
  if(rankColor=='b')
    fill(20);
  
  rect(pickupCoord[0][level],pickupCoord[1][level],35,50);
  rect(pickupCoord[0][level],pickupCoord[1][level]-10,60,12);
  
  if(rankColor=='y')
    fill(0);
  if(rankColor=='r')
    fill(0);
  if(rankColor=='b')
    fill(206,172,0);
    
  rect(pickupCoord[0][level],pickupCoord[1][level]+10,36,8);

  if(rankColor=='y')
    fill(170,170,0);
  if(rankColor=='r')
    fill(170,0,0);
  if(rankColor=='b')
    fill(0);
    
  rect(pickupCoord[0][level],pickupCoord[1][level],17,49);
}

void drawBoost()
{
  float x = pickupCoord[0][level];
  float y = pickupCoord[1][level];
  translate( x, y );
  rotate(pinwheelAngle);
  noStroke();
  fill(pinColorA);
  triangle(0,0,12,-6,6,-12);
  triangle(0,0,-12,6,-6,12);
  triangle(0,0,-12,-6,-6,-12);
  triangle(0,0,12,6,6,12);
  fill(pinColorB);
  triangle(0,0,-6,-12,12,-24);
  triangle(0,0,12,-6,24,12);
  triangle(0,0,6,12,-12,24);
  triangle(0,0,-12,6,-24,-12);
  rotate(-pinwheelAngle);
  translate(-x,-y);
}

void drawHook()
{
  stroke(100,80,40);
  strokeWeight(5);
  noFill();
  ellipse(pickupCoord[0][level]+3,pickupCoord[1][level]+3,20,20);
  ellipse(pickupCoord[0][level],pickupCoord[1][level],20,20);
  arc(pickupCoord[0][level],pickupCoord[1][level]-8,20,40,HALF_PI,1.5*PI);
  stroke(130);
  strokeWeight(4);
  arc(pickupCoord[0][level]+3,pickupCoord[1][level]-8,50,40,1.5*PI,1.8*PI);
  arc(pickupCoord[0][level]+3,pickupCoord[1][level]-8,35,40,1.5*PI,1.85*PI);
  arc(pickupCoord[0][level]+3,pickupCoord[1][level]-8,20,40,1.5*PI,1.9*PI);
}

void drawHookIcon( int x, int y)
{
  stroke(100,80,40);
  strokeWeight(3);
  noFill();
  ellipse(x+2,y+2,15,15);
  ellipse(x,y,15,15);
  stroke(130);
  strokeWeight(3);
  arc(x+3,y+2,25,20,1.5*PI,1.8*PI);
  arc(x+3,y+2,17,20,1.5*PI,1.85*PI);
  arc(x+3,y+2,10,20,1.5*PI,1.9*PI);
}

boolean isBoost( int x )
{//1 4 8 12 20
  if( x == 0
  ||  x == 4
  ||  x == 8
  ||  x == 12
  ||  x == 20 )
    return true;
  return false;
}

boolean isHook( int x )
{//3 16
  if( x == 2 || x == 15 )
    return true;
  return false;
}

void boost()
{
  fallSpeed=-30;
}

void drawHUD()
{
  noFill();
  strokeWeight(3);
  stroke(200);
  rect(40,height-60,50,50);
  rect(105,height-60,50,50);
  rect(170,height-60,50,50);
  
  rect(width-40,height-60,50,50);
  rect(width-105,height-60,50,50);
  rect(width-170,height-60,50,50);
  
  strokeWeight(2);
  stroke(100);
  rect(40,height-60,48,48);
  rect(105,height-60,48,48);
  rect(170,height-60,48,48);
  
  rect(width-40,height-60,48,48);
  rect(width-105,height-60,48,48);
  rect(width-170,height-60,48,48);
  
  //2-gem 6-gun 10-gem 12-boots 16-star 18-gem
  if(!pickup[1])
    drawGem('r',40,height-60);  //red gem
  if(!pickup[9])
    drawGem('g',105,height-60); //green gem
  if(!pickup[17])
    drawGem('b',170,height-60); //blue gem
    
  if(!pickup[5])
    drawKunai(width-170,height-60);
  if(!pickup[11])
    drawBoots(width-106,height-60);
  if(!pickup[15])
    drawFireScroll(width-40,height-60);
    
  //Grappling Hooks
  for(int i = 0; i < hooks; i++)
    drawHookIcon(width-45*(i+1),height-100);
}

void drawKunai(int x, int y)
{
  noStroke();
  fill(200);
  triangle(x+23,y,x,y-9,x,y);
  fill(150);
  triangle(x+23,y,x,y+9,x,y);
  triangle(x-23,y,x,y-9,x,y);
  fill(100);
  triangle(x-23,y,x,y+9,x,y);
}

void flyerDamaged()
{
  if(flyerHealth>0)
    flyerHealth--;
  if(flyerMovingRight)
    flyerMovingRight=false;
  else
    flyerMovingRight=true;
  if(flyerHealth<=0)
    flyerActive=false;
}

void drawBoots(int x, int y)
{
  noStroke();
  fill(140,120,80);
  rect(x+2,y+5,40,5);
  fill(100,80,40);
  rect(x-15,y-6,4,21);
  rect(x+10,y-3,4,15);
  stroke(100,80,40);
  noFill();
  strokeWeight(4);
  arc(x-13,y+1,24,28,1.5*PI,2*PI);
  noStroke();
  fill(150);
  curve(x-100,y-50,x+20,y+10,x-20,y+15,x-100,y-50);
  fill(200);
  curve(x-50,y-50,x+18,y+12,x-10,y+15,x-100,y-25);
}

void drawFireScroll(int x, int y)
{
  noStroke();
  fill(195,175,135);
  rect(x+1,y,30,35);
  fill(90,70,30);
  rect(x+1,y-16,40,3);
  rect(x+1,y+16,40,3);
  fill(180,160,120);
  rect(x+1,y-16,35,7,5);
  rect(x+1,y+16,35,7,5);
  fill(150,0,0);
  ellipse(x+1,y+5,12,12);
  triangle(x+1,y-10,x+7,y+3,x-5,y+3);
  fill(200,100,0);
  ellipse(x+1,y+5,9,9);
  triangle(x+1,y-8,x+5,y+3,x-3,y+3);
}

void drawGem( int level, float x, float y )
{
  if(level == 1)
    drawGem('r',x,y);
  else if(level == 9)
    drawGem('g',x,y);
  else
    drawGem('b',x,y);
}

void drawGem( int level )
{
  if(!flyerHasOrb)
  {
    if(level == 1)
      drawGem('r');
    else if(level == 9)
      drawGem('g');
    else
      drawGem('b');
  }
}

void drawGem(char gemColor)
{
  drawGem(gemColor,pickupCoord[0][level],pickupCoord[1][level]); 
}

void drawGem(char gemColor, float x, float y)
{
  noStroke();
  if(gemColor=='r' && barrierOn[0])
    fill(255,0,0);
  else if(gemColor=='g' && barrierOn[1])
    fill(0,255,0);
  else if(gemColor=='b' && barrierOn[2])
    fill(0,0,255);
  else
    fill(100,100,100);
  
  ellipse(x,y,40,40);
  
  fill(255,127);
  ellipse(x+9,y-9,10,10);
  ellipse(x+10,y-10,5,5);
}

void moveShot()
{
  if(shotRight)
    shotX+=12;
  else
    shotX-=12;
    
  if(shotX > width || shotX < 0)
    shotActive=false;
}

void drawShot()
{
  noStroke();
  fill(100);
  quad(shotX+20,shotY,shotX,shotY+7,shotX-20,shotY,shotX,shotY-7);  
  
  if( dist(shotX,shotY,flyerX,flyerY) < 50 && flyerActive)
  {
    flyerDamaged();
    shotActive=false;
    canGetNewHook = true;
  }
}

void resetPickups()
{
  for(int i = 0; i < maxLevel; i++)
  {
    pickupCoord[0][i] = random(100,width-100);
    pickupCoord[1][i] = random(100,height-100);
    if( i == 1 || i == 5 || i == 9
    || i == 11 || i == 15 || i == 17
    || i == 7 || i == 13 || i == 19 )
    {
      pickupCoord[0][i] = width/2;
      pickupCoord[1][i] = 100;
    }
  }
  pickup[0] = true;
  pickup[2] = true;
  pickup[4] = true;
  pickup[8] = true;
  pickup[12] = true;
  pickup[16] = true;
  pickup[20] = true;
}

void resetExplosions()
{
  for(int i = 0; i < explosionCount; i++)
  {
    explodeCoord[0][i] = random(-(100+mission*5),100+mission*5);
    explodeCoord[1][i] = random(-50,100+mission*5);
    explodeSize[i] = 0;
  }
}

void slow()
{
  if(speed<0)
    speed++;
  if(speed>0)
    speed--;
}

void drawFireball()
{
  fireY+=2+mission;
  if(fireY>height)
  {
    fireX=bossX;
    fireY=10;
  }
  
  fill(150,100,0,150);
  ellipse(fireX,fireY,fireSize,fireSize);
  fill(200,50,0,150);
  ellipse(fireX,fireY+5,fireSize*.8,fireSize*.84);
  fill(255,0,0,150);
  ellipse(fireX,fireY+10,fireSize*.6,fireSize*.66);
  
  checkFireHit();
}

void checkFireHit()
{
  if(dist(fireX,fireY,jumpX,jumpY) < fireSize)
  {
    if(int(random(4))%2==0)
      speed+=50;
    else
      speed-=50;
  }
  if( (speed < 10 && speed > -10 ) //Not smacked already
  && playerOnScreen()             
  && mission > 1                   //Not first boss
  && level == bossLevel            //IS a boss level
  && jumpY < 200+25*mission )      //Player gets too high
  {
    resetTentacles();
    if(bossMovingRight)            //Tentacle smack
      speed=30;
    else
      speed=-30;
    jumpY+=3;
  }
}

boolean playerOnScreen()
{
  if( jumpX > 25 && jumpX < width-25 )
    return true;
  return false;
}

void drawTentacles()
{
  if(tentacleCrawlSwap)
    tentacleCrawlCount++;
  else
    tentacleCrawlCount--;
  if(tentacleCrawlCount>=200 || tentacleCrawlCount<=0)
    tentacleCrawlSwap = !tentacleCrawlSwap;
  float divisor = width/(1+mission);
  noFill();
  strokeWeight(10+2*mission);
  for(int i = 0; i < mission; i++)
  {
    stroke(0,127);  //boss shadow
    if((i%2==0))
    {
      arc(divisor*(i+1)+tentacleCrawlCount/5,-10+tentacleLength[i],50,tentacleLength[i],.35*PI,1.5*PI);
      arc(divisor*(i+1)+tentacleCrawlCount/5,-10,50,tentacleLength[i],0,.5*PI);
    }
    else
    {
      arc(divisor*(i+1)-tentacleCrawlCount/7,-20+tentacleLength[i],50,tentacleLength[i],1.5*PI,2*PI);
      arc(divisor*(i+1)-tentacleCrawlCount/7,-20+tentacleLength[i],50,tentacleLength[i],0,.7*PI);
      arc(divisor*(i+1)-tentacleCrawlCount/7,-20,50,tentacleLength[i],.5*PI,1.5*PI);
    }
    
    stroke(#FF7300);  //boss skin
    if((i%2==0))
    {
      arc(divisor*(i+1)+tentacleCrawlCount/5,tentacleLength[i],50,tentacleLength[i],.35*PI,1.5*PI);
      arc(divisor*(i+1)+tentacleCrawlCount/5,0,50,tentacleLength[i],0,.5*PI);
    }
    
    else
    {
      arc(divisor*(i+1)-tentacleCrawlCount/7,-10+tentacleLength[i],50,tentacleLength[i],1.5*PI,2*PI);
      arc(divisor*(i+1)-tentacleCrawlCount/7,-10+tentacleLength[i],50,tentacleLength[i],0,.7*PI);
      arc(divisor*(i+1)-tentacleCrawlCount/7,-10,50,tentacleLength[i],.5*PI,1.5*PI);
    }
  }
  
  noStroke();
}

void drawBoss()
{
  
  if(!bossExploding)
  {
    if(bossMovingRight)
      bossX++;
    else
      bossX--;
    if(bossX < 100)
      bossMovingRight=true;
    if(bossX > width-100)
      bossMovingRight=false;
  }
    
  fill(#FF7300);  //head
  ellipse(bossX,0,200+12*bossHealth,150+9*bossHealth);
  fill(#DB1600);  //eyes
  arc(bossX+40,40,50,50,0,.75*PI);
  arc(bossX+40,40,50,50,1.75*PI,2*PI);
  arc(bossX-40,40,50,50,.25*PI,1.25*PI);
  
  if(mission>1)
    drawTentacles();
      
  if(bossExploding)
    drawExplosions();
}

void drawExplosions()
{
  fill(255,0,0,127);
  if(bossExplodeTimer>=0) //Safety clause
  for(int i = 0; i < explosionCount-bossExplodeTimer; i++)
  {
    if(explodeSize[i]<25)
      explodeSize[i]++;
    if(explodeSize[i]>=25)
      explodeSize[i]=0;
    ellipse(explodeCoord[0][i]+bossX,explodeCoord[1][i],explodeSize[i]*2,explodeSize[i]*2);
  }
}

void moveShuriken()
{
  shurikenY-=7;
  if( flyerActive && dist(shurikenX,shurikenY,flyerX,flyerY) < 50 )
    weaponActive=false;
  
  if( bossActive && !bossExploding && dist(shurikenX,shurikenY,bossX,0) < 75+4.5*bossHealth) //Boss hit
  {
    bossHealth--;
    if(!pickup[15])
      bossHealth--;
    weaponActive = false;
    if(bossHealth<=0)
    {
      delay(100*mission);
      frameRate(20);
      bossExploding=true;
      bossExplodeTimer=50;
    }
  }
  if(shurikenY<0)
    weaponActive=false;
}

void reset()
{
  mission++;
  fireSize+=2;
  bossHealth = 1 + mission*2;
  bossLevel = 1 + mission*2;
  bossExploding=false;
  frameRate(60);
  collisionOn=true;
  resetExplosions();
  resetPickups();
}

void drawShuriken()
{
  if(!pickup[15])
  {
    noStroke();
    fill(200,50,50,100);
    ellipse(shurikenX,shurikenY,60,63);
    ellipse(shurikenX,shurikenY+10,60,75);
  }
  strokeWeight(2);
  stroke(125);
  if(!pickup[15])
    stroke(155,120,90);
  translate(shurikenX,shurikenY);
  rotate(shurikenAngle);
  fill(100);
  triangle(0,-25,5,0,-5,0);
  triangle(0,25,5,0,-5,0);
  triangle(0,-5,0,5,-25,0);
  triangle(0,-5,0,5,25,0);
  shurikenAngle+=.372;
  if(shurikenAngle >= 2*PI)
    shurikenAngle -= 2*PI;
  rotate(-shurikenAngle);
  translate(-shurikenX,-shurikenY);
}

void drawWater()
{
  noFill();
  strokeWeight(5);
  for(int i = 0; i < width; i+=100)
    for(int j = -200; j < height; j+=100)
    {
      stroke(100,100,200);
      if(i%200==0)
        arc(i+25,j+20+waveOffset,95,50,0,PI);
      else
        arc(i+25,j+20+waveOffset*1.5,95,50,0,PI);

      waveOffset+=.005;
      if(waveOffset>200)
        waveOffset-=200;
    }
}

void drawSpray()
{
  for(int i = 0; i < width; i += 40)
  {
    fill(255);
    ellipse(i,height,60,60);
    fill(0,0,255);
    ellipse(i+random(-50,50),height-random(50),3,3);
  }
}

void setupStuff()
{
  platform = new float[2][platformCount];
  for(int i = 0; i < platformCount; i++)
  {
    platform[0][i] = random(width);
    platform[1][i] = random(height);
  }
  resetTentacles();
  for(int i = 0; i < maxLevel; i++)
  {
    if(i!=3||i!=6||i!=10||i!=14||i!=18)
      pickup[i]=true; 
    pickupCoord[0][i] = random(100,width-100);
    pickupCoord[1][i] = random(100,height-100);
  }
  pinColorA = color(random(100,255),random(100,255),random(100,255));
  pinColorB = color(random(100,255),random(100,255),random(100,255));
  resetExplosions();
  flyerColor[3] = color(250,50,250);
  flyerColor[2] = color(225,25,127);
  flyerColor[1] = color(200,0,0);
  flyerColor[0] = color(100,0,50,127);
  barrierOn[0] = true;
  barrierOn[1] = true;
  barrierOn[2] = true;
  
  for( int i = 0; i < villagerCount; i++ )
  {
    villagerColor[i]=color(random(50,200),random(50,200),random(50,200)); 
    villagerCoord[0][i] = (i+1) * (width/(villagerCount));
    villagerCoord[1][i] = height;
    villagerSpeed[0][i] = random(3,7);
    villagerSpeed[1][i] = -random(10,15);
    villagerBase[0][i] = villagerCoord[0][i];
    villagerBase[1][i] = villagerCoord[0][i];
  }
}

void resetTentacles()
{
  for(int i = 0; i < maxMission; i++)
  {
    tentacleLength[i] = random(350);
  } 
}

void movePlatforms()
{
  for(int i = 0; i < platformCount; i++)
  {
    platform[1][i]+=1;
    if(i%4==0)
      platform[1][i]+=0.5;
    if(platform[1][i]>height)
    {
      platform[1][i]-=height+25;
      platform[0][i]=random(width-50);
    }
  }
}

void drawPlatforms()
{
  rectMode(CENTER);
  for( int i = 0; i < platformCount; i++ )
  {
    noStroke();
    fill(120,100,60);
    rect(platform[0][i]+50,platform[1][i]+15,120,30,30);
    fill(220,200,160);
    ellipse(platform[0][i],platform[1][i]+15,25,30);
    stroke(220,200,160);
    strokeWeight(1);
    line(platform[0][i]+30,platform[1][i]+20,platform[0][i]+60,platform[1][i]+20);
    line(platform[0][i]+40,platform[1][i]+10,platform[0][i]+80,platform[1][i]+10);
    line(platform[0][i]+70,platform[1][i]+20,platform[0][i]+90,platform[1][i]+20);
    stroke(170,150,110);
    ellipse(platform[0][i],platform[1][i]+15,14,18);
    ellipse(platform[0][i],platform[1][i]+15,6,8);
  }
}

void moveJumper()
{
  if(!hookActive)
  {
    jumpX += speed;
    jumpY += fallSpeed;
    fallSpeed += gravity;
    if( dist( jumpX, jumpY, flyerX, flyerY ) < 50 )
    {
      if(flyerMovingRight)
        speed+=20;
      else
        speed-=20;
      if(!flyerHasOrb && flyerActive && playerHasActiveOrb())
      {
        flyerHasOrb = true;
        pickup[activeOrb()]=true;
      }
    }
  }
  if( isOnPlatform() || isOnGround() )
  {
    fallSpeed = 0;
  }
  if(jumpX < 22 || jumpX > width-22)
    speed = 0;

  if(jumpX < 25)
      jumpX+=5;
  else if(jumpX > width-25)
      jumpX-=5;
      
  if(jumpY > height && level == 0)
    jumpY--;
  if(jumpY < 0 && level < bossLevel)
    newLevel(true);
  if(jumpY >= height && level > 0)
    newLevel(false);
}
void moveVillagers()
{
  for(int i = 0; i < villagerCount; i++)
  {
    villagerCoord[1][i] += villagerSpeed[1][i];
    villagerSpeed[1][i] += gravity;
    
    if( i % 4 == 0 )
      villagerCoord[0][i] += villagerSpeed[0][i];
      
  
    if( villagerCoord[1][i] >= height-32 )
      villagerSpeed[1][i] = -random(10,18);

    if(villagerCoord[0][i] < 22 || villagerCoord[0][i] > width-22)
      villagerSpeed[0][i] = -villagerSpeed[0][i];
  
    //if(villagerCoord[0][i] < 25)
    //    villagerCoord[0][i]+=5;
    //else if(villagerCoord[0][i] > width-25)
    //    villagerCoord[0][i]-=5;
  }
}

boolean playerHasActiveOrb()
{
  if( !pickup[1] && barrierOn[0] 
  ||  !pickup[9] && barrierOn[1]
  ||  !pickup[17] && barrierOn[2] )
    return true;
  return false;
}

int activeOrb()
{
  if( barrierOn[0] )
    return 1;
  else if( barrierOn[1] )
    return 9;
  else if( barrierOn[2] )
    return 17;
  else
    return 0;
}

void newLevel(int x)
{
  if(x==0)
  {
    level=1;
    jumpY=height;
    newLevel(false); 
  }
}

void newLevel(boolean progress)
{
  weaponActive=false;
  shotActive=false;
  flyerActive=false;
  orbDropping=false;
  hookDropping=false;
  if(level != 0)
  {
    flyerMovingRight=!flyerMovingRight;
    flyerY=random(height);
    flyerSpeed = random(1,level/2);
    if(flyerMovingRight)
      flyerX=random(-100,-25);
    else
      flyerX=random(width+25,width+100);
  }
  pinColorA = color(random(100,255),random(100,255),random(100,255));
  pinColorB = color(random(100,255),random(100,255),random(100,255));
  if(progress)
  {
    level++;
    jumpY+=height;
    fallSpeed-=10;
  }
  else
  {
    level--;
    jumpY-=height;
    if(bossExploding && level==0)
      reset();
  }
  for(int i = 0; i < platformCount; i++)
  {
    platform[0][i] = random(width);
    platform[1][i] = random(height);
  }
  if(level==bossLevel)
  {
    bossActive=true;
    bossX=width/2;
    fireX=bossX;
    fireY=10;
  }
  if(level<bossLevel)
    bossActive=false;
}

boolean isOnPlatform()
{
  if( pressingDown )
    return false;
  if(!collisionOn)
    return false;
  if(fallSpeed < 0)
    return false;
  for(int i = 0; i < platformCount; i++)
  {
    if( (jumpY < platform[1][i]+10 && jumpY > platform[1][i]-30) 
    &&  (jumpX > platform[0][i]-10 && jumpX < platform[0][i]+110) )
    {
      jumpY = platform[1][i]-24;
      fill(0,0,255);
      return true;
    }
  }
  return false;
}

boolean isOnGround()
{
  if( level > 0 )
    return false;
  if( jumpY > height-50 )
    return true;
  return false;
}

void drawJumper( float x, float y )
{
  noStroke();
    
  if(!pickup[19])
    fill(0);
  else if(!pickup[13])
    fill(200,0,0);
  else if(!pickup[7])
    fill(200,200,0);
  else
    fill(255);
  ellipse(x,y,50,50);
  
  if(!pickup[19])    // belt/headband
    fill(206,172,0);
  else
    fill(50);
  arc(x,y,50,50,1.20*PI,1.80*PI,OPEN);
  
  if(!pickup[19])
    fill(0);
  else if(!pickup[13])
    fill(200,0,0);
  else if(!pickup[7])
    fill(200,200,0);
  else
    fill(255);
  arc(x,y,50,50,1.35*PI,1.65*PI,OPEN);
  
  
  //if(!pickup[19])
  //  fill(0);
  //else if(!pickup[13])
  //  fill(200,0,0);
  //else if(!pickup[7])
  //  fill(200,200,0);
  //else
  //  fill(255);
  //ellipse(x,y,50,50);
}

void jump()
{
  if( isOnPlatform() || isOnGround() )
    if(!pickup[11])
      fallSpeed -= 23;
    else
      fallSpeed -= 20;
}
  
void move( char direction )
{
  if( direction == 'r' )
    speed += 3;
  if( direction == 'l' )
    speed -= 3;
}

void shuriken()
{
  if(!weaponActive)
  {
    weaponActive = true;
    shurikenX = jumpX;
    shurikenY = jumpY;
  }
}

void shoot(char direction)
{
  if(!shotActive)
  {
    if(direction == 'r')
      shotRight=true;
    if(direction == 'l')
      shotRight=false;
    shotActive=true;
    shotX = jumpX;
    shotY = jumpY;
  }
}

void grapple()
{
  strokeWeight(5);
  stroke(140,120,80);
  line(jumpX,jumpY,jumpX,jumpY-line);
  stroke(130);
  line(jumpX,jumpY-line,jumpX,jumpY-line-24);
  line(jumpX,jumpY-line,jumpX+10,jumpY-line-20);
  line(jumpX,jumpY-line,jumpX-10,jumpY-line-20);
  line+=15;
  if( line > jumpY )
  {
    hookActive=false;
    fallSpeed = -30;
    line=0;
  }
}

void keyPressed()
{
  if(startupPhase==0)
  {
    if( key == ' ' )
      classicControls = !classicControls;
    else
      startupPhase = 1;
  }
  else if(startupPhase==1)
  {
    if( key == '1' )
    {
      gameDifficulty = 0;
      platformCount = 40;
      maxMission = 8;
      startupPhase=2;
    }
    else if( key == '2' )
    {
      gameDifficulty = 1;
      startupPhase=2;
    }
    else if( key == '3' )
    {
      gameDifficulty = 2;
      startupPhase=2;
    }
  }
  else
  {
    if(!paused && classicControls)
    {
      if( key == 'w' )
        jump();
    
      else if( key == 'd' && speed < 8)
        move('r');
    
      else if( key == 'a' && speed > -8)
        move('l');
        
      if( key == 's' )
        pressingDown = true;
    
      if( key == 'i' )
        shuriken(); 
    
      else if( key == 'j' && !pickup[5] )
        shoot('l');
    
      else if( key == 'l' && !pickup[5] )
        shoot('r');
    
      else if( key == 'k' && hooks > 0 && level != bossLevel && mission<=maxMission)
      {
        hooks--;
        hookActive = true;
      }
    }
    else if(!paused && !classicControls)
    {
      if( keyCode == UP )
        jump();
    
      else if( keyCode == RIGHT && speed < 8)
        move('r');
    
      else if( keyCode == LEFT && speed > -8)
        move('l');
        
      if( keyCode == DOWN )
        pressingDown = true;
    
      if( key == 'w' )
        shuriken(); 
    
      else if( key == 'a' && !pickup[5] )
        shoot('l');
    
      else if( key == 'd' && !pickup[5] )
        shoot('r');
    
      else if( key == 's' && hooks > 0 && level != bossLevel && mission<=maxMission)
      {
        hooks--;
        hookActive = true;
      }
    }
    
    if( key == ' ' )
    {
      if(paused)
      {
        paused = false;
        loop();
      }
      else if(!paused)
      {
        paused = true;
        noLoop();
      }
    }
  }
}

void keyReleased()
{
  if( key == 's' || keyCode == DOWN )
    pressingDown = false;
}

void mousePressed()
{
  if(startupPhase==1)
  {
    if( mouseX < width/3+25 && mouseX > width/3-35 && mouseY < height*.8+35 && mouseY > height*.8-35 )
    {
      startupPhase=2;
      gameDifficulty=0;
      platformCount = 30;
      maxMission = 8;
      print("EASY");
    }
    else if( mouseX < 2*width/3+45 && mouseX > 2*width/3-55 && mouseY < height*.8+35 && mouseY > height*.8-35 )
    {
      startupPhase=2;
      gameDifficulty=1;
      print("NORMAL");
    }
  }
}
