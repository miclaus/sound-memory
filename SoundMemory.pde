import ddf.minim.Minim;
import ddf.minim.AudioOutput;
import ddf.minim.signals.SineWave;


final int rows = 4;
final int cols = 4;
final int totalCards = rows * cols;

final int cardWidth = 100;
final int cardHeight = 100;
final int cardSpacing = 10;

final int winWidth = rows * (cardWidth + cardSpacing) + cardSpacing;
final int winHeight = cols * (cardHeight + cardSpacing) + cardSpacing;
final int winBottomHeight = 70;
final int winBottomTextSize = winBottomHeight / 2;

Card[][] cardArray = new Card[rows][cols];
Integer[] cardIds = new Integer[totalCards];

final color cardColor = color(0);
final color cardColorHover = color(30);
final color cardColorExposed = color(0, 230, 0);
final color cardColorExposedHover = color(0, 200, 0);

final int cardExposeTime = 1000; // ms (milliseconds)

boolean firstCard = true;
int firstCardRow;
int firstCardCol;
int firstCardSid;

Minim minim;
AudioOutput lineOut;
SineWave firstCardWave, secondCardWave;

String gameMessage = "press n for new game";


void setup() {
  size(winWidth, winHeight + winBottomHeight);
  
  noStroke();
  textSize(winBottomTextSize);
  textAlign(CENTER);
  
  minim = new Minim(this);
  lineOut = minim.getLineOut(Minim.STEREO);
  
  firstCardWave = new SineWave(0, 1, lineOut.sampleRate());
  firstCardWave.setPan(-1);
  
  secondCardWave = new SineWave(0, 1, lineOut.sampleRate());
  secondCardWave.setPan(1);
  
  lineOut.addSignal(firstCardWave);
  lineOut.addSignal(secondCardWave);
  
  newGame();
}

void newGame() {
  for (int i = 0; i < totalCards; i++) {
    cardIds[i] = ((i%2==0) ? i : i-1) / 2;
  }
  java.util.Collections.shuffle( java.util.Arrays.asList(cardIds) );
  
  for (int row = 0, c = 0; row < rows; row++) {
    for (int col = 0; col < cols; col++) {
      int sid = cardIds[c];
      c++;
      cardArray[row][col] = new Card(row, col, sid); 
    }
  }
}

void resetFrequencies() {
  firstCardWave.setFreq(0);
  secondCardWave.setFreq(0);
}

void draw() {
  background(230);
  
  fill(cardColor);
  text(gameMessage, cardSpacing, winHeight + cardSpacing, winWidth - cardSpacing, winHeight - cardSpacing);
  
  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < cols; col++) {
      cardArray[row][col].show();
    }
  }
}

void mousePressed() {
  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < cols; col++) {
      if ( cardArray[row][col].exists() && cardArray[row][col].isHover() ) {
        int currentCardSid = cardArray[row][col].getSid();
        
        if ( firstCard ) {
          // firstCard
          firstCardRow = row;
          firstCardCol = col;
          firstCardSid = currentCardSid;
          cardArray[firstCardRow][firstCardCol].expose(true);
          firstCardWave.setFreq( cardArray[firstCardRow][firstCardCol].getFreq() );
        }
        else {
          // secondCard (might also be the first card)
          if ( firstCardRow == row && firstCardCol == col ) {
            // secondCard is firstCard
            // do nothing ...
          }
          else {
            // secondCard
            cardArray[row][col].expose(true);
            secondCardWave.setFreq( cardArray[row][col].getFreq() );
            
            
            String exposeTimeAction = "expose";
            if ( firstCardSid == currentCardSid ) {
              exposeTimeAction = "exists";
            }
            
            cardArray[firstCardRow][firstCardCol].exposeTimeAction(exposeTimeAction);
            cardArray[row][col].exposeTimeAction(exposeTimeAction);
            
            int tempExposeTime = millis() + cardExposeTime;
            cardArray[firstCardRow][firstCardCol].exposeTime(tempExposeTime);
            cardArray[row][col].exposeTime(tempExposeTime);
          }
        }
        firstCard = ! firstCard;
      }
    }
  }
}

void mouseMoved() {
  color pixel = get(mouseX, mouseY);
  
  if ( pixel == cardColor
    || pixel == cardColorHover
    || pixel == cardColorExposed
    || pixel == cardColorExposedHover
  ) {
    cursor(HAND);
  } else {
    cursor(ARROW);
  }
}

void keyPressed() {
  if ( key == 'n' ) {
    newGame();
  }
}
