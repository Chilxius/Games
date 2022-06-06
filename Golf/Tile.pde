class Tile
{
  TileType type;
  
  public Tile()
  {
    type = TileType.FLAT;
  }
  
  public Tile( char t )
  {
    setType(t);
  }
  
  public void setType( char t )
  {
    if(t=='?') //random tile type
    {
      switch (int(random(6)))
      {
        case 0:  type = TileType.TILT_LEFT;  break;
        case 1:  type = TileType.TILT_RIGHT; break;
        case 2:  type = TileType.TILT_UP;    break;
        case 3:  type = TileType.TILT_DOWN;  break;
        case 4:  type = TileType.SAND;       break;
        default: type = TileType.FLAT;       break;
      }
    }
    else if(t=='l'||t=='<')
      type = TileType.TILT_LEFT;
    else if(t=='r'||t=='>')
      type = TileType.TILT_RIGHT;
    else if(t=='u'||t=='^')
      type = TileType.TILT_UP;
    else if(t=='d'||t=='v')
      type = TileType.TILT_DOWN;
    else if(t=='s')
      type = TileType.SAND;
    else if(t=='B' || t=='#')
      type = TileType.BLOCK;
    else
      type = TileType.FLAT;
  }
  
  public void drawTile( int x, int y ) //top left corner of tile
  {
    noStroke();
    if(type == TileType.SAND)
      fill(215,200,100);
    else if(type == TileType.BLOCK)
      fill(200);
    else
      fill(0,150,30);
    rect(x,y,50,50);
    
    stroke(127,127);
    strokeWeight(4);
    if(type == TileType.TILT_LEFT)
    {
      line(x+36,y+12,x+12,y+25);
      line(x+36,y+36,x+12,y+25);
    }
    else if(type == TileType.TILT_RIGHT)
    {
      line(x+12,y+12,x+36,y+25);
      line(x+12,y+36,x+36,y+25);
    }
    else if(type == TileType.TILT_UP)
    {
      line(x+12,y+36,x+25,y+12);
      line(x+36,y+36,x+25,y+12);
    }
    else if(type == TileType.TILT_DOWN)
    {
      line(x+12,y+12,x+25,y+36);
      line(x+36,y+12,x+25,y+36);
    }
  }
}

private enum TileType
{
  FLAT, TILT_LEFT, TILT_RIGHT,
  TILT_UP, TILT_DOWN, SAND, BLOCK
}
