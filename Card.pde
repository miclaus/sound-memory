// ... and strive (to) perfection :)

public class Card {

  private int xPos;
  private int yPos;
  private int sid;
  private boolean isExposed;
  private boolean isExistent;
  private int exposeTime;
  private String exposeTimeAction;
  
  private final int minFreq = 200;
  private final int UNDEFINED = -1;

  public Card(int row, int col, int sid) {
    xPos = row*cardWidth + cardSpacing*(row+1);
    yPos = col*cardHeight + cardSpacing*(col+1);
    this.sid = sid;
    
    exposeTime = UNDEFINED;
    
    expose(false);
    exists(true);
  }
  
  public void show() {
    if(exposeTime != UNDEFINED) {
      if(millis() >= exposeTime) {
        if(exposeTimeAction == "expose") {
          expose(false);
        }
        else if(exposeTimeAction == "exists") {
          exists(false);
        }
        exposeTime = UNDEFINED;
        resetFrequencies();
      }
    }
    
    if(isExistent) {
      if(isHover()) {
        if(!isExposed) {
          fill(cardColorHover);
        } 
        else {
          fill(cardColorExposedHover);
        }
      } 
      else {
        if(!isExposed) {
          fill(cardColor);
        } 
        else {
          fill(cardColorExposed);
        }
      }
      rect(xPos, yPos, cardWidth, cardHeight);
    }
    // this else statement can be left out completely (looks better without)
    /*else {
      fill(255,0,0);
      rect(xPos, yPos, cardWidth, cardHeight);
    }*/
  }
  
  public int getSid() {
    return sid;
  }
  
  public int getFreq() {
    // return either the sound frequency or the frequency 0
    return (isExposed) ? minFreq*(sid+1) : 0;
  }
  
  public boolean isHover() {
    return (mouseX >= xPos && mouseX <= xPos+cardWidth && 
            mouseY >= yPos && mouseY <= yPos+cardHeight);
  }
  
  public void expose(boolean exposed) {
    isExposed = exposed;
  }
  public void exposeTime(int exposeTime) {
    this.exposeTime = exposeTime;
  }
  public void exposeTimeAction(String action) {
    // this works but has no checks
    //exposeTimeAction = action;
    
    // this is wrong since string have to be compared with .equals
    //exposeTimeAction = (action == "expose" || action == "exists") ? action : "expose";
    
    exposeTimeAction = (action.equals("expose") || action.equals("exists")) ? action : "expose";
  }
  
  public boolean exists() {
    return isExistent;
  }
  public void exists(boolean existence) {
    isExistent = existence;
  }
}

