/**********************
* Bennett Ritchie     *
* Burger Shop Game    *
**********************/

final int maxBurgerSize = 15, menuSize = 20;
String menu[] = new String[menuSize];
String ingredient[] = new String[11];
int menuCheck[] = new int[menuSize];
int score = 0, currentItem = 0, currentOrder = 0;
float squish = 50, orderUpOffset = 0;
float position[] = new float[maxBurgerSize];
int item[] = new int[maxBurgerSize];
int parsedBurger[] = new int[maxBurgerSize];
int parsedMenu[] = new int[maxBurgerSize];
char parsedMenuChar[] = new char[maxBurgerSize];
boolean itemActive[] = new boolean[maxBurgerSize];
int burgerState = 1; //0 = waiting, 1 = bottom bun, 2 = free click, 3 = top bun
int clicked = 0;
boolean takeBurger = false;

void setup()
{
  size(1100,900);
  noStroke();
  rectMode(CENTER);
  setupItems();
  setupMenu();
}

void draw()
{
  background(155);
  drawTopHUD();
  drawTable();
  drawBurger();
  drawOrder();
  if(burgerState == 0
  && !takeBurger
  && position[currentItem-1]>=700-squish*currentItem-1)
  {
    delay(1000);
    if(checkBurger())
      println("Good Job!");
    takeBurger = true;
  }
}

void drawOrder()
{
  rectMode(CORNER);
  textSize(15);
  fill(0,127);
  rect(10,10,150,80);
  fill(230);
  rect(13,13,150,80);
  fill(0);
  text(menu[currentOrder],15,30);
  rectMode(CENTER);
}

boolean checkBurger()
{
  //for(int i = 0; i < str(menuCheck[currentOrder]).length(); i++ ) //Testing
  //{
  //  print(  menuCheck[currentOrder]/int(pow(10,i)) );
  //  print("   "+ round( menuCheck[currentOrder]/pow(10,i) ) ); 
  //  println("   "+ int( menuCheck[currentOrder]/pow(10,i) )%10 ); 
  //}
  
  for(int i = 0; i < currentItem; i++)  //Places the created burger's items' IDs in an array
    parsedBurger[i] = item[i]-1;
  for(int i = 0; i <= str(menuCheck[currentOrder]).length(); i++) //Places the menu's IDs in an array
    parsedMenu[i] = menuCheck[currentOrder]/int(pow(10,i))%10; //pow() function is cast as int to avoid rounding errors
    
  //for(int i = 0; i < parsedMenu.length; i++)
  //  print(parsedMenu[i]);  //Testing

  for(int i = 0; i < str(menuCheck[currentOrder]).length(); i++) //Cycles through the menu item's parts
  {
    for(int j = 0; j < currentItem; j++)  //Cycles through the current burger
    {
      //println(parsedBurger[j] + " " + parsedMenu[i]); //Testing
      if( parsedBurger[j] == parsedMenu[i] )
      {
        parsedBurger[j] = 0;  //If a match is found, removes that item from the temporary menu item array
        parsedMenu[i] = 0;
        //j=currentItem;
      }
    }
  }
  
  //for(int i = 0; i < parsedBurger.length; i++)
  //  print(parsedBurger[i]);
  
  for(int i = 0; i < parsedMenu.length; i++)
  {
    if( //(parsedBurger[i]>0 && parsedBurger[i]<10 ) 
      (parsedMenu[i]>0 && parsedMenu[i]<10))
    {
      println("Needs " + ingredient[parsedMenu[i]]);  //If all items from the menu item were not matched,
      return false;                                   //returns false and informs player of what they lacked
    }
  }
  return true;    //Returns true if burger was successful
  
}

void reset()
{
  burgerState = 1;
  orderUpOffset = 0;
  currentItem = 0;
  squish = 50;
  takeBurger = false;
  setupItems();
  //currentOrder++; //Testing - reaches an error state
  //println(menuCheck[currentOrder]); //Testing
  currentOrder = int( random(menuSize) );
}

void drawTable()
{
  rectMode(CORNER);
  fill(255);
  rect(0,700,width,100);
  fill(255,0,0,127);
  for(int i = 0; i < width; i+=50)
    rect(0+i,700,25,100);
  rect(0,700,width,25);
  rect(0,750,width,25);
  rectMode(CENTER);
}

void setupItems()
{
  for(int i = 0; i < maxBurgerSize; i++)
  {
    position[i] = 0;
    item[i] = 0;
    itemActive[i] = false;
    parsedBurger[i] = 0;
    parsedMenu[i] = 0;
    parsedMenuChar[i] = '0';
  }
  ingredient[0] = "Top Bun";
  ingredient[1] = "Katchup";
  ingredient[2] = "Mustard";
  ingredient[3] = "Tomato";
  ingredient[4] = "Pickle";
  ingredient[5] = "Beef";
  ingredient[6] = "Lettuce";
  ingredient[7] = "Cheese";
  ingredient[8] = "Onions";
  ingredient[9] = "Bacon";
  ingredient[10] = "Bottom Bun";
}

void setupMenu() //1 kat, 2 mus, 3 tom, 4 pic,
{                //5 pat, 6 let, 7 che, 8 oni, 9 bac
  menu[0] = "Cheeseburger";
  menuCheck[0] = 57;
  menu[1] = "BLT";
  menuCheck[1] = 936;
  menu[2] = "Burger with katchup";
  menuCheck[2] = 51;
  menu[3] = "Saucey burger";
  menuCheck[3] = 125;
  menu[4] = "Tear-jerker";
  menuCheck[4] = 882;
  menu[5] = "Plant-lover's";
  menuCheck[5] = 3468;
  menu[6] = "Double";
  menuCheck[6] = 55;
  menu[7] = "Green machine";
  menuCheck[7] = 4466;
  menu[8] = "Triple 'merica burger";
  menuCheck[8] = 999555777;
  menu[9] = "Quad stacker";
  menuCheck[9] = 5555;
  menu[10] = "Red double";
  menuCheck[10] = 11559;
  menu[11] = "Soggy Sandwich";
  menuCheck[11] = 1267;
  menu[12] = "Crispy King";
  menuCheck[12] = 59986;
  menu[13] = "Aporkalypse";
  menuCheck[13] = 99999;
  menu[14] = "Supreme";
  menuCheck[14] = 123456789;
  menu[15] = "Super cheesy double";
  menuCheck[15] = 77755;
  menu[16] = "Chef's Choice";
  menuCheck[16] = 0;
  menu[17] = "Bright sunny burger";
  menuCheck[17] = 22775;
  menu[18] = "Tomato Tower";
  menuCheck[18] = 3333333;
  menu[19] = "Fixin's Fanatic";
  menuCheck[19] = 533446688;
} //Change menuSize to add more

void drawBurger()
{
  if(takeBurger)
    orderUpOffset+=9;
  for(int i = 0; i < maxBurgerSize; i++)
  {
    if(itemActive[i])
    {
      if(position[i]<700-squish*i)
        position[i]+=5;
      drawShape(item[i],position[i],i);
    }
  }
  if(orderUpOffset>width+100)
  {
    reset();
  }
}

void drawShape( int i, float y, int switcher)
{
  if( i == 1 )
  {
    fill(#DEA53A);
    arc(width/2+orderUpOffset,y+15,300,240,PI,2*PI);
  }
  else if( i == 2 )
  {
    fill(#C82922); //Heinz Red
    ellipse(width/2+50+orderUpOffset,y,175,20);
    ellipse(width/2-50+orderUpOffset,y,175,20);
  }
  else if( i == 3 )
  {
    fill(#ffdb58 ); //Mustard yellow
    ellipse(width/2+orderUpOffset,y,250,20);
  }
  else if( i == 4 )
  {
    fill(150,0,0);
    stroke(200,0,0);
    strokeWeight(5);
    for(int j = 5; j > 0; j-- )
    {
      ellipse(width/2+80+orderUpOffset,y+4*j,120,10);
      ellipse(width/2-80+orderUpOffset,y+4*j,120,10);
    }
  }
  else if( i == 5 )
  {
    fill(0,150,0);
    stroke(0,200,0);
    strokeWeight(5);
    for(int j = 3; j > 0; j-- )
    {
      ellipse(width/2+100+orderUpOffset,y+3*j,75,8);
      ellipse(width/2-100+orderUpOffset,y+3*j,75,8);
      ellipse(width/2+orderUpOffset,y+3*j,75,8);
    }
  }
  else if( i == 6 )
  {
    fill(#4D370D); //Burger brown
    rect(width/2+orderUpOffset,y,330,60,50);
  }
  else if( i == 7 )
  {
    fill(0,185,0);
    //strokeWeight(2);
    //stroke(180,220,180);
    //rect(width/2+orderUpOffset,y-14,280,20,50);
    //rect(width/2+orderUpOffset,y-7,310,20,50);
    rect(width/2+orderUpOffset,y-5,340,20,50);
    arc(width/2+orderUpOffset,y,100,50,0,PI);
    arc(width/2+110+orderUpOffset,y,120,50,0,PI);
    arc(width/2-110+orderUpOffset,y,120,50,0,PI);
  }
  else if( i == 8 )
  {
    fill(250,250,0);
    triangle(width/2+orderUpOffset,y+15,width/2-150+orderUpOffset,y-15,width/2+150+orderUpOffset,y-15);
    triangle(width/2+180+orderUpOffset,y+15,width/2+150+orderUpOffset,y-15,width/2+orderUpOffset,y-15);
    triangle(width/2-180+orderUpOffset,y+15,width/2-150+orderUpOffset,y-15,width/2+orderUpOffset,y-15);
  }
  else if( i == 9 )
  {
    fill(220);
    stroke(#B443AD);
    strokeWeight(5);
    for(int j = 3; j > 0; j-- )
    {
      ellipse(width/2+100+orderUpOffset,y+3*j,75,8);
      ellipse(width/2-100+orderUpOffset,y+3*j,75,8);
      ellipse(width/2+orderUpOffset,y+3*j,75,8);
    }
  }
  else if( i == 10 )
  {
    stroke(#BC483B);
    strokeWeight(5);
    noFill();
    for( int j = 9; j > 0; j-- )
    {
      if( switcher % 2 == 0 )
      {
        arc(width/2-150+orderUpOffset,y-j*2+9,100,30,PI,2*PI);
        arc(width/2-50+orderUpOffset,y-j*2+9,100,30,0,PI);
        arc(width/2+50+orderUpOffset,y-j*2+9,100,30,PI,2*PI);
        arc(width/2+150+orderUpOffset,y-j*2+9,100,30,0,PI);
      }
      else
      {
        arc(width/2-150+orderUpOffset,y-j*2+9,100,30,0,PI);
        arc(width/2-50+orderUpOffset,y-j*2+9,100,30,PI,PI*2);
        arc(width/2+50+orderUpOffset,y-j*2+9,100,30,0,PI);
        arc(width/2+150+orderUpOffset,y-j*2+9,100,30,PI,PI*2);
      }
    }
  }
  else if( i == 11 )
  {
    fill(#DEA53A);
    rect(width/2+orderUpOffset,y,300,60,10);
  }
  
  noStroke();
}

void mousePressed()
{
  if(buttonClicked())
  {
    //rect(500,500,75,75); //Testing
    if(isLegal(clicked))
    {
      //print(clicked); //Testing
      //printClicked(clicked); //Testing
      item[currentItem] = clicked;
      
      if(item[currentItem]==1)
        squish=15;
      itemActive[currentItem]=true;
      currentItem++;
      if(currentItem==1)
        burgerState=2;
      if(currentItem==maxBurgerSize-1) //Ready for top bun
        burgerState=3;
      if(clicked == 1)
        burgerState=0;
    }
  }
  //print(squish); //Testing
}

//Checks to see if the clicked button was a legal choice
boolean isLegal( int button )
{ 
  //if(burgerState==2)
    //print("Burger 2"); //Testing
  if(burgerState==1)
  {
    if(button == 11)
    {
      return true;
    }
  }

  else if(burgerState==3)
  {
    if(button==1)
    {
      return true;
    }
  }
       
  else if(burgerState==2)
  {
    //if(button!=11)
    {
      return true;
    }
  }

  return false;
}

void printClicked(int i) //For testing
{
  if(i==1)  print("Top Bun");
  if(i==2)  print("Katchup");
  if(i==3)  print("Mustard");
  if(i==4)  print("Tomato");
  if(i==5)  print("Pickle");
  if(i==6)  print("Patty");
  if(i==7)  print("Lettuce");
  if(i==8)  print("Cheese");
  if(i==9)  print("Onion");
  if(i==10) print("Bacon");
  if(i==11) print("Bottom Bun");
}

boolean buttonClicked()
{
  for(int i = 1; i <= 11; i++)
  {
    if(dist(mouseX,mouseY,100*i-50,50)<30)
    {
      clicked = i;
      fill(200,0,0,175);
      return true;
    }
  }
  return false;
}

void drawTopHUD()
{
  fill(50);  //Top and bottom bars
  rect(width/2,50,width,100);
  
  //Buttons
  for(int i = 1; i <= 11; i++)
  {
    fill(100,0,0);
    ellipse(100*i-50,50,70,70);
    fill(200);
    ellipse(100*i-50,50,60,60);
  }
  
  //Top Bun
  fill(#DEA53A); //Bread Brown
  arc(50,55,50,40,PI,2*PI);
  
  //Ketsup
  stroke(#C82922); //Heinz Red
  strokeWeight(10);
  line(130,50,160,30);
  line(160,30,140,70);
  line(140,70,165,55);
  
  //Mustard
  stroke(#ffdb58 ); //Mustard yellow
  strokeWeight(10);
  line(230,50,260,30);
  line(260,30,240,70);
  line(240,70,265,55);
  
  //Tomato
  stroke(200,0,0);
  strokeWeight(7);
  fill(150,0,0);
  ellipse(350,50,47,47);
  line(327,50,372,50);
  line(338,70,361,30);
  line(338,30,361,70);
  
  //Pickle  (x = 450)
  stroke(0,150,0);
  strokeWeight(5);
  fill(0,200,0);
  ellipse(450,50,40,40);
  stroke(0,190,0);
  strokeWeight(1);
  line(441,40,458,40);
  line(439,45,462,45);
  line(437,50,462,50);
  line(439,55,460,55);
  line(441,60,458,60);
  
  //Burger
  strokeWeight(1);
  stroke(#1C1405);
  fill(#4D370D); //Burger brown
  ellipse(550,50,55,55);
  strokeWeight(3);
  line(538,30,562,30);
  line(533,40,567,40);
  line(530,50,570,50);
  line(533,60,567,60);
  line(538,70,562,70);
  
  //Lettuce (x=650)
  strokeWeight(1);
  stroke(180,220,180);
  fill(0,185,0);
  translate(650,50);
  for(int i = 0; i < 8; i++)
  {
    rotate(-QUARTER_PI);
    arc(10,0,35,35,0,PI);
  }
  translate(-650,-50);

  //cheese (750,50)
  fill(200,200,0);
  stroke(150,150,0);
  quad(730,30,730,60,745,70,745,40);
  rectMode(CORNER);
  rect(745,39,25,30);
  rectMode(CENTER);
  triangle(730,30,768,40,745,40);
  
  //onion (850,50)
  stroke(#B443AD);
  fill(255);
  ellipse(850,40,30,30);
  ellipse(850,41,30,30);
  ellipse(850,42,30,30);
  ellipse(850,42,20,20);
  ellipse(854,50,30,30);
  ellipse(854,51,30,30);
  ellipse(854,52,30,30);
  ellipse(854,52,20,20);
  ellipse(848,60,30,30);
  ellipse(848,61,30,30);
  ellipse(848,62,30,30);
  ellipse(848,62,20,20);
  ellipse(848,62,10,10);
  
  //bacon
  noStroke();
  translate(950,50);
  rotate(-QUARTER_PI);
  fill(#BC483B);
  rect(0,0,50,20);
  fill(#C6BF9C);
  rect(0,0,50,7);
  rotate(QUARTER_PI);
  translate(-950,50);
  
  //bottom bun
  fill(#DEA53A); //Bread Brown
  rect(1050,-48,50,15);
  rect(1050,-45,50,15,10);
  
  //Crossouts
  stroke(255,0,0);
  noFill();
  strokeWeight(8);
  
  if(burgerState == 0)  //0 = waiting, 1 = bottom bun, 2 = free click, 3 = top bun
    for(int i = 1; i <= 11; i++)
    {
      ellipse(100*i-50,-50,57,57);
      line(100*i-70,-70,100*i-30,-30);
    }
    else if(burgerState == 1)
    {
      for(int i = 1; i <= 10; i++)
      {
        ellipse(100*i-50,-50,57,57);
        line(100*i-70,-70,100*i-30,-30);
      }
     }
   //else if(burgerState == 2)
   //{
   //   ellipse(1050,-50,57,57);
   //   line(1030,-70,1070,-30);
   //}
   else if(burgerState == 3)
   {
     for(int i = 2; i <= 11; i++)
     {
       ellipse(100*i-50,-50,57,57);
       line(100*i-70,-70,100*i-30,-30);
     }
   }
  noStroke();
}
