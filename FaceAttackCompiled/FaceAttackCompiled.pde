/*####################*\
*  Face Attack Game!!  *
# By: Bennett Ritchie  #
#    and his class     #
#                      #
# Many appologies for  #
# the poorly documented#
# code. I get sloppy   #
* when I code quickly, *
\*####################*/


/**********************************\
* Use mouse to move your ship      *
* and left click to shoot the      *
* attacking faces. Hold down       *
* 'f' to charge your beam weapon.  *
* Green powerups increase your     *
* main gun's power, yellow powerups*
* improve your charged beam.       *
* Every face that gets by you      *
* will steal one of your cookies.  *
*                                  *
* Beware of Cookie-Dog.            *
\**********************************/

////////////////////////////
// Never tested in replit //
////////////////////////////////////
// Code requires the cookie image //
////////////////////////////////////

//For Background, which will be black/purple with stars
int starCount = 500;
float star[][] = new float[2][starCount];
float red,blue;
boolean redUp,blueUp;

//For the enemy faces, which will grow more numerous as the game goes on
int faceCount = 50;
int activeFaces = 1;
int activeShot = 0;
Face faces[] = new Face[faceCount];
int enemyShotCounter = 0;
int randomFace=0;

//Player's shots
Shot shots[] = new Shot[50];

//Game data
int score = 0;
boolean gameOver = false;
boolean paused = false;
boolean charging = false;

//This is for the charge beam. Sorry for the confusing names.
float chargeRecharge = 100;
float maxChargeSize = 70;
float chargeShotSize = 0;
float chargeShotX;
float chargeSpeedBonus = 0;

//This is for the main gun
float shotChargeCounter = 0;
float shotRefilBonus = 0;
int chargedShots=1;
int maxShots=2;

//For powerups that faces drop
int powerupChance;
Powerup power;

//For Cookie-Dog
Boss doggo;

//For the 'treasures'
int maxTreasures = 22;
int treasureCount = maxTreasures;
color [] treasCol = new color[treasureCount];
float boomCount[] = new float [maxTreasures];
PImage cookie;

void setup()
{
  size(1100,900); 
  for(int i = 0; i < faceCount; i++)
    faces[i] = new Face(random(width),-100);
  for(int i = 0; i < shots.length; i++)
    shots[i] = new Shot();
  for(int i = 0; i < starCount; i++)
  {
    star[0][i] = random(width);
    star[1][i] = random(height);
  }
  for(int i = 0; i < treasureCount; i++)
  {
    treasCol[i] = color(random(0,175),random(0,175),random(0,175));
    boomCount[i] = 0;
  }
  red = random(35);
  blue = min(red,random(70));
  redUp=blueUp=true;
  textSize(30);
  
  power = new Powerup(0,0,0);
  powerupChance = 1;
  
  doggo = new Boss();
  
  cookie = loadImage("cookie.png");
  cookie.resize(50,50);
  imageMode(CENTER);
}

void draw()
{
  if(treasureCount <= 0) //End game
  {
    gameOver = true;
  }
    
  background(min(red,blue),0,blue);
  cycleBackground();
  drawStars();
  
  if(!doggo.active && doggo.bossCounter < 0)
    doggo.active=true;
  if(doggo.active)
  {
    doggo.drawBoss();
    doggo.moveBoss();
          
    if(doggo.left.active)
    {
      doggo.left.moveBossShot(mouseX);
      doggo.left.drawBossShot();
      if(dist(doggo.left.X,doggo.left.Y,mouseX,height-50) < 30)
      {
        treasureCount-=3;
        doggo.left.active=false;
      }
    } 
    if(doggo.right.active)
    {
      doggo.right.moveBossShot(mouseX);
      doggo.right.drawBossShot();
      if(dist(doggo.right.X,doggo.right.Y,mouseX,height-50) < 30)
      {
        treasureCount-=3;
        doggo.right.active=false;
      }
    }
  }
  for(int i = 0; i < activeFaces; i++)
  {
    if(faces[i].moveDown()) //returns true if made it past the ship
      treasureCount--;
    faces[i].drawFace();
  }
  
  if(!gameOver)
    enemyShotCounter++;
  if( enemyShotCounter>=100-(activeFaces*2) )
  {
    randomFace = int(random(activeFaces));
    if(!faces[randomFace].destroyed)
    {
      faces[randomFace].shoot();
      enemyShotCounter = 0;
    }
    else
      enemyShotCounter--;
  }
  for(int i = 0; i < activeFaces; i++)
  {
    if(faces[i].shot.active)
    {
      faces[i].shot.moveShot();
      faces[i].shot.drawShot();
    }
    
    if( dist(faces[i].shot.X,faces[i].shot.Y,mouseX,height-50) < 30 && faces[i].shot.active )
    {
      /*textSize(50);
      text("GAME OVER",width/3,height/2);
      noLoop();
      gameOver = true;
      paused = true;*/
      treasureCount-=3;
      faces[i].shot.active = false;
    }
  }
  
  if(!gameOver)
  {
    for(int i = 0; i < shots.length; i++)
    {
      if(shots[i].active)
      {
        shots[i].drawShot();
        shots[i].moveShot();
        
        //Shots against boss
        if(doggo.health > 0 && dist(doggo.X,doggo.Y,shots[i].X,shots[i].Y)<125)
        {
          doggo.takeDamage();
          shots[i].active=false;
        }
        
        for(int j = 0; j < activeFaces; j++)
        {
          if( !faces[j].destroyed && shots[i].hitScored( faces[j].X, faces[j].Y ) )
          {
            faces[j].destroyed=true;
            shots[i].active=false;
            score += 10;
            doggo.bossCounter -=10;
            if(!power.active)
              powerupChance--;
            if(powerupChance<=0)
            {
              powerupChance=int(random(10,20+activeFaces));
              if(random(2)<1)
                power = new ShotPowerup(faces[j].X,faces[j].Y,3);
              else
                power = new BeamPowerup(faces[j].X,faces[j].Y,3);
              power.activate();
            }
          }
        }
      }
    }
  }
  fill(255);
  text("Score: " + score,30,30);
  
  if(power.active)
  {
    power.drawPowerup();
    power.movePowerup();
    if(dist(power.X,power.Y,mouseX,height-50)<30)
    {
      if(power.collect())
      {
        maxShots++;
        shotRefilBonus+=0.1;
      }
      else
      {
        chargeSpeedBonus+=0.15;
        maxChargeSize+=maxChargeSize/12;
      }
      powerupChance=int(random(10,20+activeFaces));
    }
    else if(power.Y>height) //Get a new powerup quickly if they miss it.
    {
      powerupChance=5;
      power.active=false;
    }
  }
  
  if(!gameOver)
  {
    chargeShot();
    drawShotHud();
    drawShip();
    if(chargeRecharge<100)
    {
      chargeRecharge+=.5;
      if(chargeRecharge<15)
      {
        drawChargedBeam();
        for(int i = 0; i < activeFaces; i++)
        {
          if(dist(faces[i].X,0,chargeShotX,0)<chargeShotSize)
          {
            if(!faces[i].destroyed)
            {
              faces[i].destroyed=true;
              score+=10;
              doggo.bossCounter -= 10;
              if(!power.active)
                powerupChance--;
            }
          }
          if(dist(faces[i].shot.X,0,chargeShotX,0)<chargeShotSize)
          {
            if(faces[i].shot.active)
            {
              faces[i].shot.active=false;
              score+=3;
              doggo.bossCounter -= 3;
            }
          }
          //Beam against boss
          if(doggo.health > 0 && doggo.canTakeBeamDamage && dist(doggo.X,0,chargeShotX,0)<125)
          {
            doggo.takeDamage();
            doggo.canTakeBeamDamage=false;
          }
        }
      }
      else if(chargeRecharge==20)
      {
        chargeShotSize=0;
        doggo.canTakeBeamDamage=true;
      }
    }
  }
  
  //May work on this formula
  if((score/10 > (activeFaces-1)*(activeFaces-1)
  ||  score/10 > activeFaces*activeFaces) //for first trigger
  &&  activeFaces < faceCount)
    activeFaces++;
    
  drawTreasures();
}

void drawTreasures()
{
  for(int i = 0; i < maxTreasures; i++)
  {
    if(i < treasureCount)
    {
      translate(25+i*50,height);
      rotate(1.3*i);
      image(cookie,0,0);
      rotate(-1.3*i);
      translate(-(25+i*50),-height);
    }
    else
      drawExplosion(i);
  }
}

void cycleBackground()
{
  if(redUp)
    red+=0.02;
  else
    red-=0.03;
  if(blueUp)
    blue+=0.03;
  else
    blue-=0.02;
  
  if(blue>90)
    blueUp=false;
  if(blue<=0)
    blueUp=true;
  if(red>30)
    redUp=false;
  if(red<=0)
    redUp=true;
}

void drawStars()
{
  fill(250,200,50);
  noStroke();
  for(int i = 0; i < starCount; i++)
  {
    if(i%10==0) //closer star
    {
      circle(star[0][i],star[1][i],5);
      star[1][i]+=0.2;
    }
    else
    {
      circle(star[0][i],star[1][i],3);
      star[1][i]+=0.1;
    }
    
    if( star[1][i] > height )
    {
      star[0][i] = random(width);
      star[1][i] = -5;
    }
  }
}

void chargeShot() //charging normal shots - bad name I'm sorry
{
  if(shotChargeCounter<100)
    shotChargeCounter+=1+shotRefilBonus;
  if(shotChargeCounter>=100 && chargedShots < maxShots)
  {
    shotChargeCounter=0;
    chargedShots++;
  }
}

void drawChargedBeam()
{
  fill(random(255),random(255),0);
  noStroke();
  rect(chargeShotX-chargeShotSize/2,-chargeShotSize,chargeShotSize,height-80+chargeShotSize,chargeShotSize);
}

void drawShotHud()
{
  stroke(230);
  strokeWeight(2);
  fill(0,0,50);
  rect(30,height-60,100,30);
  rect(30,height-100,100,30);
  noStroke();
  fill(shotChargeCounter*2.5,shotChargeCounter*1.5,0);
  rect(31,height-59,shotChargeCounter-1,29);
  fill(chargeRecharge*2.5,0,chargeRecharge*1.5);
  rect(31,height-99,chargeRecharge-1,29);
  
  fill(250,150,0);
  for(int i = 0; i < chargedShots; i++)
  {
    ellipse(153+i*35,height-45,27,27);
  }
}

void drawShip()
{
  fill(mouseX/4,255-(mouseX-width/2),mouseY/4);
  triangle(mouseX,height-75,mouseX-25,height-25,mouseX+25,height-25);

  if(charging)
  {
    if(chargeShotSize<maxChargeSize)
    {
      chargeShotSize+=.1+chargeSpeedBonus;
    }
    fill(random(255),random(255),0);
    ellipse(mouseX,height-70-(chargeShotSize/2),chargeShotSize,chargeShotSize);
  }
}

void resetFaces()
{
  for(int i = 0; i < activeFaces; i++)
    faces[i].resetFace();
  for(int i = 0; i < shots.length; i++)
    shots[i] = new Shot();
  textSize(30);
}

public void drawExplosion( int index )
{
  if(boomCount[index]<100)
  {
    noStroke();
    fill(255,100+boomCount[index],0,250-(2.5*boomCount[index]));
    circle(25+index*50,height,boomCount[index]);
    boomCount[index]++;
  }
}

void mousePressed()
{
  if(chargedShots>0 && !charging)
  {
    chargedShots--;
    shots[activeShot].shoot();
    activeShot++;
    if(activeShot>=50)
      activeShot = 0;
  }
  //faces[0].shoot(); //for testing
  //doggo.health--;
}

void keyPressed()
{
  if(key == 'f' && chargeRecharge == 100)
    charging=true;
  
  if(key == ' ')
  {
    //if(gameOver)
    //{
    //  gameOver = false;
    //  paused = false;
    //  resetFaces();
    //  loop();
    //}
    if(paused)
    {
      paused = false;
      loop();
    }
    else
    {
      paused = true;
      noLoop();
    }
  }
  if(key == ' ' && !gameOver);
}

void keyReleased()
{
  if(key == 'f')
  {
    if(charging)
    {
      charging=false;
      chargeRecharge = 0;
      chargeShotX=mouseX;
    }
  }
}

void printSpeeds() //for testing
{
  for(int i = 0; i < faceCount; i++)
  {
    text("Face " + i + ": " + faces[i].speed,30,50+i*50);
  }
}

//----------------------------------------------

class BeamPowerup extends Powerup
{
   public BeamPowerup( float x, float y, float s )
   {
     super(x,y,s);
   }
   
   void drawPowerup()
   {
     stroke(255,0,0);
     strokeWeight(3);
     fill(250,250,0);
     circle(X,Y,25);
   }
   
   boolean collect()
   {
     active=false;
     return false; //false for beam
   }

}

//--------------------------------------------

//The dreaded Cookie-Dog

class Boss
{
  float X,Y,fade;
  int health, maxHealth, bossCounter;
  boolean active, movingRight,
  canTakeBeamDamage, fading;
  BossShot left,right;
  
  public Boss()
  {
    X = -100;
    Y = random(0,height*2/3);
    bossCounter = 500;
    fade = 100;
    maxHealth = health = 5;
    active = false;
    movingRight = true;
    canTakeBeamDamage=true;
    fading = false;
    left = new BossShot();
    right = new BossShot();
  }
  
  void reset()
  {
    active = false;
    movingRight = true;
    canTakeBeamDamage =true;
    fading = false;
    X = -100;
    Y = random(0,height*2/3);
    fade = 100;
    maxHealth++;
    health = maxHealth;
    bossCounter = maxHealth*100;
    left = new BossShot();
    right = new BossShot();
  }
  
  void drawBoss()
  {
    fill(170+((maxHealth-health)*10),170,170,fade*2.5);ellipse(X+0,Y+0,250,250);fill(0+((maxHealth-health)*10),0,0,fade*2.5);ellipse(X-105,Y+0,55,200);ellipse(X+105,Y+0,55,200);fill(255,255-((maxHealth-health)*10),255-((maxHealth-health)*10),fade*2.5);ellipse(X-50,Y-25,50,50);ellipse(X+50,Y-25,50,50);fill(0+((maxHealth-health)*10),0,0,fade*2.5);ellipse(X-50,Y-25,40,40);ellipse(X+50,Y-25,40,40);fill(255,255-((maxHealth-health)*10),255-((maxHealth-health)*10),fade*2.5);ellipse(X-40,Y-40,7.5,7.5);ellipse(X+60,Y-40,7.5,7.5);fill(0+((maxHealth-health)*10),0,0,fade*2.5);ellipse(X+0,Y+15,20,15);

    if(fading)
      fade--;
    if(fade<=0)
      reset();
  }
  
  void moveBoss()
  {
    if(movingRight)
      X+=(maxHealth+1)-health;
    else
      X-=(maxHealth+1)-health;
      
    if(X>width+150)
    {
      movingRight =false;
      Y = random(0,height*2/3);
    }
    if(X<-150)
    {
      movingRight =true;
      Y = random(0,height*2/3);
    }
    
    if(!left.active && X > width/4 && X < width/2 )
      left.shoot(X-50,Y-25);
      
    if(!right.active && X > width/2 && X < width*3/4 )
      right.shoot(X+50,Y-25);

  }
  
  void takeDamage()
  {
    score += 15;
    health--;
    if(health==0)
    {
      score += 100;
      fading=true;
      health=maxHealth+1;
    }
  }
}

//--------------------------------------------

//Wobbly Seeker Shots

class BossShot
{
  float X,Y,speed,maxSpeed;
  boolean active;
  
  public BossShot()
  {
    X=0;
    Y=0;
    speed=0;
    maxSpeed=3;
    active = false;
  }
  
  void shoot( float x, float y )
  {
    X=x;
    Y=y;
    active=true;
  }
  
  void activate()
  {
    active = true;
  }
  
  void moveBossShot( float x )
  {
    if(x>X && speed < maxSpeed)
      speed+=.3;
    else if( x<X && speed > -maxSpeed)
      speed-=.3;
    X+=speed;
    Y+=3;
    
    if(Y>height+15)
      active=false;
  }
  
  void drawBossShot()
  {
    fill(random(255),0,random(255));
    ellipse(X,Y,30,30);
  }
}

//------------------------------------------

//Basic nose-missiles

class EnemyShot
{
  float X,Y,speed;
  boolean active;
  
  public EnemyShot( float x, float y, float s )
  {
    X = x;
    Y = y;
    speed = s;
    active = false;
  }
  
  public void shoot(float x, float y)
  {
    X=x;
    Y=y;
    active = true;
  }
    
  public void drawShot()
  {
    noStroke();
    fill(255,0,0,50);
    ellipse(X,Y-10,15,15);
    ellipse(X,Y-17,17,17);
    ellipse(X,Y-24,20,20);
    fill(127);
    rect(X-7,Y-14,14,30);
    triangle(X-7,Y+15,X+7,Y+15,X,Y+25);
  }
  
  public void moveShot()
  {
    Y+=speed+(7-speed);
    if(Y>height+30)
      active=false;
  }
}

//---------------------------------------

//Base class for the two different kinds of powerup

class Powerup
{
  float X,Y;
  float speed;
  boolean active;
  
  public Powerup( float x, float y, float s )
  {
    X=x;
    Y=y;
    speed=s;
    active=false;
  }
  
  void activate()
  {
    active=true;
  }
  
  boolean collect()
  {
    active=false;
    return false;
  }
  
  void drawPowerup()
  {}
     
  void movePowerup()
  {
    Y+=speed;
    if(Y<0)
    active=false;
  }
}

//----------------------------------------

//The player's shots.

class Shot
{
  float X,Y;
  boolean active;
  
  public Shot()
  {
    X=mouseX;
    Y=height-50;
    active=false;
  }
  
  void drawShot()
  {
    noStroke();
    fill(200,250,50,200);
    ellipse(X,Y,10,40);
  }
  
  void moveShot()
  {
    Y-=7;
    if(Y<0)
    {
      active=false;
    }
  }
  
  void shoot()
  {
    X=mouseX;
    Y=height-50;
    active=true;
  }
  
  public boolean hitScored( float faceX, float faceY )
  {
    if( dist( faceX, faceY, X, Y ) < 75 )
      return true;
    return false;
  }
}

//-------------------------------------------

class ShotPowerup extends Powerup
{
   public ShotPowerup( float x, float y, float s )
   {
     super(x,y,s);
   }
   
   void drawPowerup()
   {
     stroke(0,255,0);
     strokeWeight(3);
     fill(100,250,0);
     circle(X,Y,25);
   }
   
   boolean collect()
   {
     active=false;
     return true; //true for shot
   }
}

//----------------------------------------

//The game's enemies, which are faces drawn
//by my students and me.

//Edit the drawFace() method to add new faces.
//  If they were using mouseX and mouseY, change it to X and Y (find and replace)
//Edit the changeFace() method based on the faces available.

class Face
{
  float X,Y;
  float speed;
  boolean destroyed,goingRight;
  int boomCounter, faceChoice;
  float width1,height1; //for one of the faces' code
  EnemyShot shot;
  
  public Face( float x, float y )
  {
    X = x;
    Y = y;
    speed = random(.5,2);
    destroyed = false;
    shot = new EnemyShot(X,Y,speed+(5-speed));
    goingRight = true;
    boomCounter = 0;
    faceChoice = changeFace();
    width1=175;
    height1=175;
  }
  
  public boolean moveDown()
  {
    if(!destroyed)
    {
      if(goingRight)
        X++;
      else
        X--;

      if(X>width)
        goingRight=false;
      if(X<0)
        goingRight=true;
      Y+=speed;
      if(Y>=height+100)
      {
        resetFace();
        return true;
      }
    }
    return false;
  }
  
  public void resetFace()
  {
    X = random(width);
    Y = -100;
    speed = random(.5,2);
    destroyed = false;
    boomCounter = 0;
    faceChoice = changeFace();
  }
  
  public void shoot()
  {
    if(!shot.active)
      shot.shoot(X,Y);
  }
  
  public int changeFace()
  {
    return int(random(28)); //Change this number based on how many faces there are
  }
  
  public void drawExplosion()
  {
    noStroke();
    fill(255,100+boomCounter,0,250-(2.5*boomCounter));
    circle(X,Y,boomCounter*2);
    boomCounter++;
    if(boomCounter==100)
      resetFace();
  }
  
  public void drawFace()
  {
    noStroke();
    if(destroyed)
      drawExplosion();
    else if(faceChoice == 0) //Ja'Shawn G
    {
      fill(#FFA600);rect(X-50,Y-80,20,40);rect(X+30,Y-80,20,40);fill(#FF0516);ellipse(X-0,Y-10,160,160);fill(#F7E00C);rect(X-30,Y+10,60,20);fill(#FFF700);rect(X-50,Y-40,40,20);rect(X+10,Y-40,40,20);fill(#FF0015);triangle(X-0,Y+0,X-10,Y+10,X-10,Y+10);
    }
    else if(faceChoice == 1 ) //Erick O
    {
      fill(255, 229, 180);rect(X-75,Y-75,150,150,20);if(mousePressed){fill(220,0,0);}else{fill(0,220,0);}rect(X-105,Y-105,210,80,30);fill(0);rect(X-25,Y-20,20,50,10);fill(0);rect(X+15,Y-20,20,50,10);fill(255);ellipse(X,Y-65,60,60);arc(X+100,Y-65,60,60,HALF_PI,PI * 1.5);arc(X-100,Y-65,60,60,1.5 * PI, TWO_PI);arc(X-100,Y-65,60,60,0, HALF_PI);
    }
    else if(faceChoice == 2 ) //Jalon S
    {
      fill(60,40,210);rect(X-100,Y-100,200,150);fill(225);ellipse(X-45,Y-50,90,30);ellipse(X+55,Y-50,90,30);fill(0);ellipse(X-15,Y-50,20,10);ellipse(X+80,Y-50,20,10);ellipse(X-30,Y+10,90,30);
    }
    else if(faceChoice == 3 ) //Josh W
    {
      noStroke();fill(210, 155, 130);rect(0 + X - width1 / 2, 0 + Y - height1 / 2, width1, height1);fill(70, 60, 40);rect(0 + X - width1 / 2, 0 + Y - height1 / 2, width1, height1 / 4);rect(0 + X - width1 / 2, height1 / 4 + Y - height1 / 2, width1 / 8, height1 / 8);rect(width1 / 8 * 7 + X - width1 / 2, height1 / 4 + Y - height1 / 2, width1 / 8, height1 / 8);fill(255, 255, 255);rect(width1 / 8 + X - width1 / 2, height1 / 2 + Y - height1 / 2, width1 / 8, height1 / 8);rect(width1 / 8 * 6 + X - width1 / 2, height1 / 2 + Y - height1 / 2, width1 / 8, height1 / 8);fill(110, 90, 220);rect(width1 / 4 + X - width1 / 2, height1 / 2 + Y - height1 / 2, width1 / 8, height1 / 8);rect(width1 / 8 * 5 + X - width1 / 2, height1 / 2 + Y - height1 / 2, width1 / 8, height1 / 8);fill(170, 135, 110);rect(width1 / 8 * 3 + X - width1 / 2, height1 / 8 *5 + Y - height1 / 2, width1 / 4, height1 / 8);rect(width1 / 4 + X - width1 / 2, height1 / 8 * 6 + Y - height1 / 2, width1 / 2, height1 / 8);
    }
    else if(faceChoice == 4 ) //Josh P
    {
      stroke(0); fill(220,220,220); triangle(X-50,Y+76,X+0,Y-37,X+40,Y+76);fill(255,255,255);rect(X-75,Y+0,25,25);rect(X+50,Y+0,25,25);ellipse(X+0,Y-49,50,50);fill(0,0,0);ellipse(X+12,Y-52,15,15);fill(255,255,255);ellipse(X-13,Y-52,15,15);ellipse(X+0,Y-37,25,10);
    }
    else if(faceChoice == 5) //Elisha
    {
      fill(250,255,13);rect(X-50,Y-50,100,100);  fill(0,0,255);ellipse(X-30,Y-30,20,20);  ellipse(X+30,Y-30,20,20);  fill(255,0,0);rect(X-10,Y-10,20,20);  fill(0,0,0);rect(X-35,Y+10,10,30);  rect(X+25,Y+10,10,30);  rect(X-35,Y+30,60,10);
    }
    else if(faceChoice == 6) //James M
    {
      fill(0,0,255);rect(X-60,Y-60,120,120);fill(0,255,0);ellipse(X-30,Y-30,30,30);ellipse(X+30,Y-30,30,30);fill(255,0,150);rect(X-10,Y-10, 20, 20);fill(255,255,0);rect(X-40,Y+20,80,20);
    }
    else if(faceChoice == 7) //Jackson C
    {
      fill(250,0,0);rect(X-75,Y-105,150,200);fill(0,0,0);rect(X-60,Y-75,50,50);fill(0,0,0);rect(X+10,Y-75,50,50);fill(0,0,250);ellipse(X-20,Y+10,30,30);fill(0,0,250);ellipse(X+20,Y+10,30,30);fill(255,165,0);rect(X-35,Y+55,70,30);
    }
    else if(faceChoice == 8) //Dionte P
    {
      fill(0, 18, 255);ellipse(X+0, Y+0, 140, 150);fill(254, 255, 0);ellipse(X+20, Y-30, 20, 20);fill(255, 0, 0);rect(X-40, Y-40, 20, 20);fill(255,200,0);rect(X-10,Y +0, 20, 20);fill(200, 200, 200);rect(X-20, Y+30, 40, 10);    
    }
    else if(faceChoice == 9) //Omar L
    {
      fill(255);stroke(0);rect(X-80,Y-55,160,130);triangle(X+0,Y+0,X-5,Y+10,X+15,Y+10);rect(X-50,Y+35,80,20);rect(X-40,Y-35,20,20);rect(X+30,Y-35,20,20);
    }
    else if(faceChoice == 10) //Oliver H
    {
      stroke(0);fill(39,128,109);rect(X-90,Y-60,50,70);rect(X+40,Y-60,50,70);rect(X-40,Y-60,80,120);fill(200,0,255);rect(X-20,Y-30,10,10);rect(X+10,Y-30,10,10);noStroke();fill(55,247,234);rect(X-20,Y+10,10,20);rect(X+10,Y+10,10,20);rect(X-20,Y+30,40,10);ellipse(X,Y,20,20);
    }
    else if(faceChoice == 11) //Charles B
    {
      fill (255,255,0);ellipse(X,Y,200,200);fill(0,0,255);ellipse(X-50,Y-50,25,25);ellipse(X+50,Y-50,25,25);fill(255,192,203);rect(X-50,Y+50,100,25);fill(255,0,0);triangle(X-25,Y+25,X,Y-25,X+25,Y+25);
    }
    else if(faceChoice == 12) //Averit B
    {
      fill(255, 255, 0);rect(X-50, Y-50, 100, 100);fill(200, 200, 255);rect(X-30, Y-30, 20, 20);rect(X+10, Y-30, 20, 20);fill(100, 255, 100);triangle(X,Y,X-15,Y+15,X+15,Y+15);fill(255, 255, 222);rect(X-30, Y+25, 60, 10);
    }
    else if(faceChoice == 13) //Ethan A
    {
      fill(0,255,0);rect(X -70,Y -70,140,140);fill(255,0,0);rect(X +15,Y -50,40,40);rect(X -55,Y -50,40,40);fill(255);rect(X -50,Y +30,20,20);rect(X +30,Y +30,20,20);rect(X -50,Y +10,100,20);
    }
    else if(faceChoice == 14) //Dea'von M
    {
      fill(255, 255, 0);rect(X-60,Y-70, 130, 120);fill(0,0,255);rect(X-40,Y-40, 20, 20);rect(X+20,Y-40, 20, 20);fill(255, 255, 0);rect(X-10,Y-10, 20, 20);fill(255,255,255);rect(X-30,Y+20, 60, 20);fill(255);rect(X-10,Y+20,10,10);rect(X+10,Y+20,10,10);
    }
    else if(faceChoice == 15) //Lena Q
    {
      fill(253,185,200);triangle(X-60,Y-80,X-57,Y-20,X-20,Y-50);triangle(X+58,Y-80,X+17,Y-50,X+56,Y-20);ellipse(X+0,Y+0,120,120);fill(138,3,3);ellipse(X-30,Y,30,30);ellipse(X+30,Y,30,30);fill(0,0,0);ellipse(X,Y+30,10,10);
    }
    else if(faceChoice == 16) //Josiah B
    {
      stroke(20);fill(255);ellipse(X+5,Y-20, 20, 20);strokeWeight(3);line(X+5,Y-10,X+5,Y+23);line(X+5,Y+23,X+0,Y+50);line(X+5, Y+23, X+20,Y+50);line(X+4, Y-1,X-10,Y+10);line(X+4, Y-1, X+30, Y+10);
    }
    else if(faceChoice == 17) //Kaylei H
    {
      fill(#FC0F0F);rect(X-80,Y-80,160,160);fill(0);rect(X-50,Y-50,30,30);fill(0);ellipse(X+25,Y-36,30,30);fill(#0902F5);triangle(X+5,Y-5,X-5,Y+20,X+15,Y+20);fill(#1AFFC4); ellipse(X-35,Y+40,15,15);ellipse(X+40,Y+40,15,15);fill(#BF2CF5);rect(X-23,Y+30,50,20);
    }
    else if(faceChoice == 18) //Zachery J
    {
      fill(254,255,0);ellipse (X+0,Y+0,200,200);fill(0);rect (X-78,Y-32,48,8);rect(X+12,Y-32,48,8);rect (X-52,Y+40,104,8);  
    }
    else if(faceChoice == 19) //Sage S
    {
      fill(255,255,0);rect(X-85,Y-85,170,170);fill(0,255,0);rect(X-50,Y-50,100,100);fill(0);rect(X-25,Y-25,50,50);fill(255,255,255);triangle(X-1,Y-26,X-26,Y+22,X+22,Y+21);
    }
    else if(faceChoice == 20) //Shayne A
    {
      stroke(0);fill (238,234,222);ellipse(X+0,Y+0,120,160);noStroke();fill(0);ellipse(X+25,Y-20,30,20);ellipse(X-35,Y-20,30,20);ellipse(X+0,Y+10,15,15);ellipse(X-10,Y+30,15,15);ellipse(X-10,Y+50,15,15);ellipse(X-10,Y+70,15,15);ellipse(X+10,Y+30,15,15);ellipse(X+10,Y+50,15,15);ellipse(X+10,Y+70,15,15);ellipse(X+0,Y-60,10,10);ellipse(X-25,Y-40,10,10);ellipse(X-25,Y-60,10,10);ellipse(X-40,Y-40,10,10);ellipse(X-30,Y-50,10,10);    ellipse(X+25,Y-40,10,10);ellipse(X+25,Y-50,10,10);ellipse(X+25,Y-60,10,10);fill(178,14,14);triangle(X-25,Y-5, X-25,Y+5, X-55,Y+5 );triangle(X+15,Y+5, X+15, Y-5, X+45,Y+5);triangle(X-20,Y-40, X+0,Y-10, X+20,Y-40);
    }
    else if(faceChoice == 21) //No name
    {
      fill(225,98,0);rect(X-50,Y-50,100,100);fill(0,255,240);rect(X+17.5,Y-37.5,15,15);rect(X-32.5,Y-37.5,15,15);fill(255,0,243);rect(X-2.5,Y-5,5,5);fill(255,0,0);ellipse(X,Y+30,42.5,35);
    }
    else if(faceChoice == 22) //James K
    {
    fill(250);ellipse(X,Y,200,200);if(mousePressed){fill(166,16,30);}else{fill(0);}ellipse(X,Y-10,195,190);fill(250);ellipse(X,Y-20,200,185);fill(166,16,30);triangle(X-40,Y-20,X-45,Y+50,X-50,Y+50);fill(0);ellipse(X-40,Y-10,50,100);ellipse(X+40,Y-10,50,100);if(mousePressed){fill(166,16,30);ellipse(X-40,Y-10,20,40);ellipse(X+40,Y-10,20,40);}
    }
    else if(faceChoice == 23) //Bennett R
    {
      noStroke();fill(#FF9100);ellipse(X+0,Y+0,150,150);triangle(X-100,Y+0,X+0,Y-50,X+0,Y+50);triangle(X+100,Y+0,X+0,Y-50,X+0,Y+50);triangle(X-80,Y-50,X+0,Y-50,X+0,Y+50);triangle(X-80,Y+50,X+0,Y-50,X+0,Y+50);triangle(X+80,Y-50,X+0,Y-50,X+0,Y+50);triangle(X+80,Y+50,X+0,Y-50,X+0,Y+50);triangle(X+0,Y-100,X-50,Y+0,X+50,Y+0);triangle(X+0,Y+100,X-50,Y+0,X+50,Y+0);fill(255);ellipse(X-30,Y-20,50,50);ellipse(X+30,Y-20,60,60);fill(0);ellipse(X+30,Y-20,20,20);ellipse(X-30,Y-20,30,30);ellipse(X+0,Y+30,40,20);
    }
    else if(faceChoice == 24) //Logan B
    {
      noStroke();fill(186,157,121);ellipse(X+0,Y+0,150,200);fill(255);circle(X-25,Y-25,25);circle(X+25,Y-25,25);fill(61,183,228);circle(X-25,Y-25,20);circle(X+25,Y-25,20);fill(0);rect(X-50,Y+50,100,3);fill(255);triangle(X-50,Y+51,X-40,Y+51,X-45,Y+63);fill(198,120,86);ellipse(X+0,Y+50,50,150);
    }
    else if(faceChoice == 25) //Zane T
    {
      noStroke();fill(255, 0, 0);ellipse(X,Y,150,150);rect(X-75,Y+10,50,100);rect(X+25,Y+10,50,100);fill(200,200,200);rect(X-43,Y-25,85,45);
    }
    else if(faceChoice == 26) //Kevin T
    {
      stroke(0);fill(123, 200, 238);ellipse(X +0, Y+0, 100, 140);fill(88, 137, 128);triangle(X-30, Y-40, X-20, Y-15, X-10,Y-40);rect(X+10, Y-40, 20, 20);rect(X+20, Y-20, 0, 90);fill(28, 16, 27);rect(X-10,Y +0, 20, 20);fill(59, 20, 3);ellipse(X+0, Y+40, 60, 20);fill(123, 200, 238); ellipse(X+0,  Y+40, 40, 10);
    }
    else if(faceChoice == 27) //Avery H
    {
      fill(255,255,0);circle(X+0,Y+0,140);fill(0);circle(X-30,Y-30,20);circle(X+30,Y-30,20);fill(255);rect(X-50,Y+20,96,30);fill(255,0,0);rect(X-12,Y-20,25,150);
    }
  }
}
