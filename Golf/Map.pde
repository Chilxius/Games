class Map
{
  Tile [][] tiles = new Tile[14][14];
  float holeX,holeY,ballX,ballY;
  int par;
  
  public Map()
  {
    fillWithBlankTiles();
    holeX=675;
    holeY=675;
    ballX=50;
    ballY=50;
  }
  
  public void fillWithBlankTiles()
  {
    for(int i = 0; i < tiles.length; i++)
      for(int j = 0; j < tiles[0].length; j++)
        tiles[i][j]= new Tile();
  }
  
  public void fillWithRandomTiles()
  {
    for(int i = 0; i < tiles.length; i++)
      for(int j = 0; j < tiles[0].length; j++)
        tiles[i][j] = new Tile('?');
  }
  
  public void drawMap() //assumes a 700x700 map
  {
    for(int i = 0; i < tiles.length; i++)
      for(int j = 0; j < tiles[0].length; j++)
        tiles[i][j].drawTile(i*50,j*50);
    noFill();
    stroke(200);
    strokeWeight(7);
    square(0,0,700);
  }
  
  public TileType terrain( float x, float y )
  {
    if(x>width/50 || y>height/50)
      return TileType.BLOCK;
    return tiles[int(x)][int(y)].type;
  }
  
  //Lovelace forgive me, for I have sinned.
  //An ugly method, but should make building maps a lot easier
  public void buildMap(char aa,char ab,char ac,char ad,char ae,char af,char ag,char ah,char ai,char aj,char ak,char al,char am,char an,
                       char ba,char bb,char bc,char bd,char be,char bf,char bg,char bh,char bi,char bj,char bk,char bl,char bm,char bn,
                       char ca,char cb,char cc,char cd,char ce,char cf,char cg,char ch,char ci,char cj,char ck,char cl,char cm,char cn,
                       char da,char db,char dc,char dd,char de,char df,char dg,char dh,char di,char dj,char dk,char dl,char dm,char dn,
                       char ea,char eb,char ec,char ed,char ee,char ef,char eg,char eh,char ei,char ej,char ek,char el,char em,char en,
                       char fa,char fb,char fc,char fd,char fe,char ff,char fg,char fh,char fi,char fj,char fk,char fl,char fm,char fn,
                       char ga,char gb,char gc,char gd,char ge,char gf,char gg,char gh,char gi,char gj,char gk,char gl,char gm,char gn,
                       char ha,char hb,char hc,char hd,char he,char hf,char hg,char hh,char hi,char hj,char hk,char hl,char hm,char hn,
                       char ia,char ib,char ic,char id,char ie,char iF,char ig,char ih,char ii,char ij,char ik,char il,char im,char in,
                       char ja,char jb,char jc,char jd,char je,char jf,char jg,char jh,char ji,char jj,char jk,char jl,char jm,char jn,
                       char ka,char kb,char kc,char kd,char ke,char kf,char kg,char kh,char ki,char kj,char kk,char kl,char km,char kn,
                       char la,char lb,char lc,char ld,char le,char lf,char lg,char lh,char li,char lj,char lk,char ll,char lm,char ln,
                       char ma,char mb,char mc,char md,char me,char mf,char mg,char mh,char mi,char mj,char mk,char ml,char mm,char mn,
                       char na,char nb,char nc,char nd,char ne,char nf,char ng,char nh,char ni,char nj,char nk,char nl,char nm,char nn )
  {
    tiles[0][0].setType(aa); tiles[1][0].setType(ab); tiles[2][0].setType(ac); tiles[3][0].setType(ad); tiles[4][0].setType(ae); tiles[5][0].setType(af); tiles[6][0].setType(ag); tiles[7][0].setType(ah); tiles[8][0].setType(ai); tiles[9][0].setType(aj); tiles[10][0].setType(ak); tiles[11][0].setType(al); tiles[12][0].setType(am); tiles[13][0].setType(an); 
    tiles[0][1].setType(ba); tiles[1][1].setType(bb); tiles[2][1].setType(bc); tiles[3][1].setType(bd); tiles[4][1].setType(be); tiles[5][1].setType(bf); tiles[6][1].setType(bg); tiles[7][1].setType(bh); tiles[8][1].setType(bi); tiles[9][1].setType(bj); tiles[10][1].setType(bk); tiles[11][1].setType(bl); tiles[12][1].setType(bm); tiles[13][1].setType(bn); 
    tiles[0][2].setType(ca); tiles[1][2].setType(cb); tiles[2][2].setType(cc); tiles[3][2].setType(cd); tiles[4][2].setType(ce); tiles[5][2].setType(cf); tiles[6][2].setType(cg); tiles[7][2].setType(ch); tiles[8][2].setType(ci); tiles[9][2].setType(cj); tiles[10][2].setType(ck); tiles[11][2].setType(cl); tiles[12][2].setType(cm); tiles[13][2].setType(cn);
    tiles[0][3].setType(da); tiles[1][3].setType(db); tiles[2][3].setType(dc); tiles[3][3].setType(dd); tiles[4][3].setType(de); tiles[5][3].setType(df); tiles[6][3].setType(dg); tiles[7][3].setType(dh); tiles[8][3].setType(di); tiles[9][3].setType(dj); tiles[10][3].setType(dk); tiles[11][3].setType(dl); tiles[12][3].setType(dm); tiles[13][3].setType(dn);
    tiles[0][4].setType(ea); tiles[1][4].setType(eb); tiles[2][4].setType(ec); tiles[3][4].setType(ed); tiles[4][4].setType(ee); tiles[5][4].setType(ef); tiles[6][4].setType(eg); tiles[7][4].setType(eh); tiles[8][4].setType(ei); tiles[9][4].setType(ej); tiles[10][4].setType(ek); tiles[11][4].setType(el); tiles[12][4].setType(em); tiles[13][4].setType(en);
    tiles[0][5].setType(fa); tiles[1][5].setType(fb); tiles[2][5].setType(fc); tiles[3][5].setType(fd); tiles[4][5].setType(fe); tiles[5][5].setType(ff); tiles[6][5].setType(fg); tiles[7][5].setType(fh); tiles[8][5].setType(fi); tiles[9][5].setType(fj); tiles[10][5].setType(fk); tiles[11][5].setType(fl); tiles[12][5].setType(fm); tiles[13][5].setType(fn);
    tiles[0][6].setType(ga); tiles[1][6].setType(gb); tiles[2][6].setType(gc); tiles[3][6].setType(gd); tiles[4][6].setType(ge); tiles[5][6].setType(gf); tiles[6][6].setType(gg); tiles[7][6].setType(gh); tiles[8][6].setType(gi); tiles[9][6].setType(gj); tiles[10][6].setType(gk); tiles[11][6].setType(gl); tiles[12][6].setType(gm); tiles[13][6].setType(gn);
    tiles[0][7].setType(ha); tiles[1][7].setType(hb); tiles[2][7].setType(hc); tiles[3][7].setType(hd); tiles[4][7].setType(he); tiles[5][7].setType(hf); tiles[6][7].setType(hg); tiles[7][7].setType(hh); tiles[8][7].setType(hi); tiles[9][7].setType(hj); tiles[10][7].setType(hk); tiles[11][7].setType(hl); tiles[12][7].setType(hm); tiles[13][7].setType(hn);
    tiles[0][8].setType(ia); tiles[1][8].setType(ib); tiles[2][8].setType(ic); tiles[3][8].setType(id); tiles[4][8].setType(ie); tiles[5][8].setType(iF); tiles[6][8].setType(ig); tiles[7][8].setType(ih); tiles[8][8].setType(ii); tiles[9][8].setType(ij); tiles[10][8].setType(ik); tiles[11][8].setType(il); tiles[12][8].setType(im); tiles[13][8].setType(in);
    tiles[0][9].setType(ja); tiles[1][9].setType(jb); tiles[2][9].setType(jc); tiles[3][9].setType(jd); tiles[4][9].setType(je); tiles[5][9].setType(jf); tiles[6][9].setType(jg); tiles[7][9].setType(jh); tiles[8][9].setType(ji); tiles[9][9].setType(jj); tiles[10][9].setType(jk); tiles[11][9].setType(jl); tiles[12][9].setType(jm); tiles[13][9].setType(jn);
    tiles[0][10].setType(ka);tiles[1][10].setType(kb);tiles[2][10].setType(kc);tiles[3][10].setType(kd);tiles[4][10].setType(ke);tiles[5][10].setType(kf);tiles[6][10].setType(kg);tiles[7][10].setType(kh);tiles[8][10].setType(ki);tiles[9][10].setType(kj);tiles[10][10].setType(kk);tiles[11][10].setType(kl);tiles[12][10].setType(km);tiles[13][10].setType(kn);
    tiles[0][11].setType(la);tiles[1][11].setType(lb);tiles[2][11].setType(lc);tiles[3][11].setType(ld);tiles[4][11].setType(le);tiles[5][11].setType(lf);tiles[6][11].setType(lg);tiles[7][11].setType(lh);tiles[8][11].setType(li);tiles[9][11].setType(lj);tiles[10][11].setType(lk);tiles[11][11].setType(ll);tiles[12][11].setType(lm);tiles[13][11].setType(ln);
    tiles[0][12].setType(ma);tiles[1][12].setType(mb);tiles[2][12].setType(mc);tiles[3][12].setType(md);tiles[4][12].setType(me);tiles[5][12].setType(mf);tiles[6][12].setType(mg);tiles[7][12].setType(mh);tiles[8][12].setType(mi);tiles[9][12].setType(mj);tiles[10][12].setType(mk);tiles[11][12].setType(ml);tiles[12][12].setType(mm);tiles[13][12].setType(mn);
    tiles[0][13].setType(na);tiles[1][13].setType(nb);tiles[2][13].setType(nc);tiles[3][13].setType(nd);tiles[4][13].setType(ne);tiles[5][13].setType(nf);tiles[6][13].setType(ng);tiles[7][13].setType(nh);tiles[8][13].setType(ni);tiles[9][13].setType(nj);tiles[10][13].setType(nk);tiles[11][13].setType(nl);tiles[12][13].setType(nm);tiles[13][13].setType(nn);
  }
  
  void setLevel( int l ) //chooses level based on l
  {
    switch (l)
    {
      case 1:
buildMap(' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','s','s','s','s',
         ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','s','s','s',
         ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','s','s',
         ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','s',
         ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
         ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
         ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
         ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
         ' ',' ',' ',' ',' ',' ',' ',' ',' ','^','^','^','^','^',
         ' ',' ',' ',' ',' ',' ',' ',' ','<','<','^','^','^','^',
         ' ',' ',' ',' ',' ',' ',' ',' ','<','<',' ',' ',' ','s',
         'B',' ',' ',' ',' ',' ',' ',' ','<','<',' ',' ','s','s',
         'B','B',' ',' ',' ',' ',' ','s','<','<',' ','s','s','s',
         'B','B','B',' ',' ',' ',' ','s','<','<','s','s','s','s');
         ballX = 50; ballY = 50; holeX = 575; holeY = 575; par = 2; break;
      case 2:
buildMap('s','s','s','s','s','s','s','s','s','s','s','s','s','s',
         's',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','s',
         's',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','s',
         's',' ',' ',' ',' ','^','^','^','^',' ',' ',' ',' ','s',
         's',' ',' ',' ',' ','^','^','^','^',' ',' ',' ',' ','s',
         's',' ',' ',' ','<','<','^','^','>','>',' ',' ',' ','s',
         's',' ',' ',' ','<','<','s','s','>','>',' ',' ',' ','s',
         's',' ',' ',' ','<','<','s','s','>','>',' ',' ',' ','s',
         's',' ',' ',' ','<','<','v','v','>','>',' ',' ',' ','s',
         's',' ',' ',' ',' ','v','v','v','v',' ',' ',' ',' ','s',
         's',' ',' ',' ',' ','v','v','v','v',' ',' ',' ',' ','s',
         's',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','s',
         's',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','s',
         's','s','s','s','s','s','s','s','s','s','s','s','s','s');
         ballX = 650; ballY = 50; holeX = 350; holeY = 350; par = 2; break;
      case 3:
buildMap('s','B','s','B','s','B','s','B','s','B','s','B','s','B',
         'B',' ',' ',' ',' ','<','<','<','<',' ',' ',' ',' ','s',
         's',' ',' ',' ','<','<','<','<','<','<',' ',' ',' ','B',
         'B',' ',' ','<','<','<','<','<','<','<','<',' ',' ','s',
         's',' ','v','<','<','<','<','<','<','<','<','<',' ','B',
         'B','v','v','<','<',' ','B','s',' ','<','<','<','<','s',
         's','v','v','v',' ',' ','s','B',' ',' ','^','^','^','B',
         'B','v','v','v',' ',' ','B','s',' ',' ','^','^','^','s',
         's','v','v','v',' ',' ','s','B',' ',' ','^','^','^','B',
         'B','v','v','v',' ',' ','B','s',' ',' ','^','^','^','s',
         's','>','v','<',' ',' ','s','B',' ',' ','^','^','^','B',
         'B','>',' ','<',' ','s','B','s','B',' ','^','^','^','s',
         's',' ',' ',' ','s','B','s','B','s','B',' ',' ',' ','B',
         'B','s','B','s','B','s','B','s','B','s','B','s','B','s');
         ballX = 575; ballY = 575; holeX = 125; holeY = 575; par = 3; break;
      case 4:
buildMap(' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','B','^',
         ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','B','^',
         's','s','s','B','s',' ',' ',' ',' ',' ',' ',' ','B','^',
         's','s','s','s','s','B','>','<','B','>','>','>','s','^',
         's','s','s','s','s','B','>','<','B','>','>','>','s','^',
         's','s','s','s','s','B','>','<','B','>','>','>','s','>',
         'B','s','B','s','B','B','>','<','B','>','>','>','s','>',
         's','s','s','s','s','B','>','<','B','>','>','>','s','>',
         's','s','s','s','s','B','>','<','B','>','>','>','s','>',
         's','s','s','s','s','B','>','<','B','>','>','>','s','v',
         's','B','s','s','s','B','B','B','B','>','>','>','s','v',
         's','s','s','s','s','<','<','>','>','v','v','v','B','v',
         ' ',' ',' ',' ',' ','<','<','>','>',' ',' ',' ','B','v',
         ' ',' ',' ',' ',' ','<','<','>','>',' ',' ',' ','B','v');
         ballX = 350; ballY = 625; holeX = 350; holeY = 450; par = 4; break;
      case 5:
buildMap(' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
         ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
         's','v','s','v','s','v','s','v','s','v','B',' ',' ',' ',
         'v','B','v','v','v','v','v','v','v','v','B',' ',' ',' ',
         'v','v','v','v','v','v','v','v','v','v','B',' ',' ',' ',
         'v','v','v','v','v','v','v','v','v','v','B',' ',' ',' ',
         'v','v','v','v','v','v','v','v','B','v','B',' ',' ',' ',
         'v','v','v','v','v','v','v','v','v','v','B',' ',' ',' ',
         'v','v','v','v','v','v','v','v','v','v','B',' ',' ',' ',
         'v','v','v','v','B','v','v','v','v','v','B',' ',' ',' ',
         'v','v','v','v','v','v','v','v','v','v','B',' ',' ',' ',
         'v','v','v','v','v','v','v','v','v','v','B',' ',' ',' ',
         ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
         ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
         ballX = 50; ballY = 650; holeX = 50; holeY = 50; par = 4; break;
      case 6:
buildMap('s','B',' ',' ','B','B','B','B',' ','B','B','s','s','B',
         's','B',' ',' ','B','B','B',' ',' ',' ','B','B','s','s',
         's','B',' ',' ','B','B',' ',' ',' ',' ',' ','B','B','s',
         'B','B',' ',' ','B','B',' ',' ','B',' ',' ',' ','B','B',
         'B',' ',' ',' ','B','B',' ',' ','B','B',' ',' ',' ','B',
         '>',' ',' ',' ','B','B',' ',' ','B','B','B',' ',' ','<',
         '>',' ',' ',' ','B','B',' ',' ','B','B','B',' ',' ','<',
         '>',' ',' ',' ','B','B',' ',' ','B','B','B',' ',' ','<',
         'B',' ',' ',' ','B','B','B','B','B','B',' ',' ',' ','B',
         'B','B',' ',' ',' ','B','B','B','B',' ',' ',' ','B','B',
         's','B','B',' ',' ',' ','B','B',' ',' ',' ','B','B','s',
         's','s','B','B',' ',' ',' ',' ',' ',' ','B','B','s','s',
         'B','s','s','B','B',' ',' ',' ',' ','B','B','s','s','B',
         'B','B','s','s','B','B',' ',' ','B','B','s','s','B','B');
         ballX = 350; ballY = 350; holeX = 150; holeY = 75; par = 7; break;
      case 7:
buildMap('s','s',' ',' ',' ',' ',' ','>','>','>','>','s','s','s',
         's','s',' ',' ',' ',' ',' ','>','>','>','>','s','s','s',
         's','s',' ','B','B','B','B',' ',' ',' ',' ','s','s','s',
         'B',' ',' ',' ',' ',' ','B',' ',' ',' ',' ',' ',' ',' ',
         ' ','B',' ',' ',' ',' ','<','B',' ',' ','>','v',' ',' ',
         ' ',' ','B',' ',' ',' ','<','B',' ',' ','^','<',' ',' ',
         ' ',' ',' ','B',' ',' ','<','B','>','v',' ',' ',' ',' ',
         ' ',' ',' ','B',' ',' ','<','B','^','<',' ',' ','>','v',
         ' ',' ',' ','B',' ',' ','<','B',' ',' ',' ',' ','^','<',
         ' ',' ','B',' ',' ',' ','<','B',' ',' ','>','v',' ',' ',
         ' ','B',' ',' ',' ',' ','B','B',' ',' ','^','<',' ',' ',
         'B',' ',' ',' ',' ','B','v','v',' ',' ',' ',' ',' ',' ',
         's','s',' ',' ','B','B','>','<',' ',' ',' ',' ',' ','s',
         's','s',' ','B','B','B','>','<',' ',' ',' ',' ','s','s');
         ballX = 75; ballY = 650; holeX = 350; holeY = 650; par = 4; break;
      case 8:
buildMap('B','B',' ',' ',' ',' ',' ','B',' ',' ',' ',' ','v',' ',
         'B',' ',' ',' ',' ',' ',' ','B',' ',' ',' ','>','s','<',
         ' ',' ',' ',' ',' ',' ',' ','B',' ',' ',' ',' ','^',' ',
         ' ',' ',' ','B','>','>','s','B',' ',' ','B','B','B','B',
         ' ',' ',' ','B','>','>','s','B',' ',' ','B','s','s','s',
         ' ',' ',' ','B','>','>','s','B',' ',' ','B','^','^','^',
         ' ',' ',' ','B','>','>','s','B',' ',' ','B','^','^','^',
         ' ',' ',' ','B','s','<','<','B',' ',' ',' ',' ','^','^',
         ' ',' ',' ','B','s','<','<','B',' ',' ',' ',' ',' ','^',
         ' ',' ',' ','B','s','<','<','B','B','B',' ','v','v','v',
         ' ',' ',' ','B','s','<','<','B','B','B','B','v','v','v',
         ' ',' ',' ','B','s',' ',' ',' ',' ',' ',' ',' ',' ',' ',
         ' ',' ',' ','B','s','s',' ',' ',' ',' ',' ',' ',' ','s',
         ' ',' ',' ','B','s','s','s',' ',' ',' ',' ',' ','s','s');
         ballX = 75; ballY = 625; holeX = 625; holeY = 75; par = 7; break;
      case 9:
buildMap(' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
         ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
         ' ',' ',' ',' ',' ',' ','v','v',' ',' ',' ',' ',' ',' ',
         ' ',' ','B','B','B','B','v','v','B','B','B','B',' ',' ',
         ' ',' ','B','s','s','<','v','v','>','s','s','B',' ',' ',
         ' ',' ','B','s','s','<','<','>','>','s','s','B',' ',' ',
         ' ',' ','B','s','s','<','<','>','>','s','s','B',' ',' ',
         ' ',' ','B','s','s','<','<','>','>','s','s','B',' ',' ',
         ' ',' ','B','s','s','<','^','^','>','s','s','B',' ',' ',
         ' ',' ','B','s','s','<','^','^','>','s','s','B',' ',' ',
         ' ',' ','B','B','B','B','^','^','B','B','B','B',' ',' ',
         '>','>',' ',' ',' ',' ','^','^','B',' ',' ',' ','s','s',
         '>','>',' ',' ',' ',' ',' ',' ','^',' ',' ',' ','s','s',
         'B','B','B','B','B','B','b','b','B','B','B','B',' ',' ');
         ballX = 50; ballY = 600; holeX = 650; holeY = 600; par = 3; break;
      default:
    buildMap(' ',' ',' ',' ',' ','B','B','B','B',' ',' ',' ',' ',' ',
             ' ',' ',' ',' ',' ','B','B','B','B',' ',' ',' ',' ',' ',
             ' ',' ',' ',' ',' ','B','B','B','B',' ',' ',' ',' ',' ',
             ' ',' ',' ',' ',' ','B','B','B','B',' ',' ',' ',' ',' ',
             ' ',' ',' ',' ',' ','B','B','B','B',' ',' ',' ',' ',' ',
             ' ',' ',' ',' ',' ','B','B','B','B',' ',' ',' ',' ',' ',
             ' ',' ',' ',' ',' ','B','B','B','B',' ',' ',' ',' ',' ',
             ' ',' ',' ',' ',' ','B','B','B','B',' ',' ',' ',' ',' ',
             ' ',' ',' ',' ',' ','B','B','B','B',' ',' ',' ',' ',' ',
             ' ',' ',' ',' ',' ','B','B','B','B',' ',' ',' ',' ',' ',
             ' ',' ',' ',' ',' ','B','B','B','B',' ',' ',' ',' ',' ',
             ' ',' ',' ',' ',' ','B','B','B','B',' ',' ',' ',' ',' ',
             ' ',' ',' ',' ',' ','B','B','B','B',' ',' ',' ',' ',' ',
             ' ',' ',' ',' ',' ','B','B','B','B',' ',' ',' ',' ',' ');
             ballX = 50; ballY = 50; holeX = -50; holeY = -50; par = 0; break;
    }
  }
}
