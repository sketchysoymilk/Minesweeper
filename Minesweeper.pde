import de.bezier.guido.*;
private boolean no = false;
private final static int NUM_ROWS = 20;
private final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    // make the manager
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        buttons[r][c] = new MSButton(r,c);
      }
    }
    for(int i = 0; i < 30; i++){
    setMines();
    }
}
public void setMines()
{
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[row][col])){
     mines.add(buttons[row][col]);
    }
}

public void draw ()
{
    background(0);
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    int freeSpaces = 0;
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            if (!buttons[r][c].clicked && !mines.contains(buttons[r][c])) {
                freeSpaces++;
            }
        }
    }
    return freeSpaces == 0;
}
public void displayLosingMessage()
{
    for (int i = 0; i < mines.size(); i++) {
        MSButton bombs = mines.get(i);
        if (!bombs.isFlagged()) {
            bombs.setLabel(":(");
            bombs.clicked = true;
        }
    }
    no = true;
}
public void displayWinningMessage()
{
   for (int i = 0; i < mines.size(); i++) {
        MSButton bombs = mines.get(i);
        if (bombs.isFlagged()) {
            bombs.setLabel(":)");
            bombs.clicked = false;
        }
    }
}
public boolean isValid(int row, int col)
{
  if(row < NUM_ROWS && row >= 0 && col < NUM_COLS && col >= 0)
    return true;
  else
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row-1; r <= row + 1; r++){
    for(int c = col-1; c <= col + 1; c++){
      if(r != row || c != col){
      if((isValid(r,c) == true && mines.contains(buttons[r][c]))){
        numMines++;
      }
      }
    }
  }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
   
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col;
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed ()
    {
      if(!no){
        clicked = true;
        if(mouseButton == RIGHT){
          if(flagged == true)
          flagged = false;
          else{
          flagged = true;
          clicked = false;
          }
        }
        else if(mines.contains(this)){
        displayLosingMessage();
        }
        else if(countMines(myRow, myCol) > 0){
          setLabel(countMines(myRow, myCol));
        }
        else{
          for(int r = myRow-1; r <= myRow+1; r++){
            for(int c = myCol-1; c <= myCol+1; c++){
              if(isValid(r,c) == true && !buttons[r][c].clicked && !buttons[r][c].flagged)
              buttons[r][c].mousePressed();
            }
          }
            }
      }
        }
    public void draw ()
    {    
      stroke(192,192,192);
        if (flagged)
            fill(0,255,0);
        else if( clicked && mines.contains(this) )
             fill(255,153,153);
        else if(clicked)
            fill(255);
        else
            fill(204,255,153);

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
