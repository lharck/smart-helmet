class HelmetVisual {
    PImage rightTurnImg;
    PImage leftTurnImg;
    PImage breakImg;
    PImage helmetImage;
    
    int blinkTime = 500;
    boolean blinkTurnSignal = true;

    int imgSize = 300;
    String state = "leftTurn";
    
    int timeLastBlink = millis();
    
    HelmetVisual() {
        rightTurnImg = loadImage("rightTurn.png");
        leftTurnImg = loadImage("leftTurn.png");
        breakImg = loadImage("break.png");
        helmetImage = loadImage("helmetVisual.png");
    }

    void draw() {
        push();
        tint(color(100, 100, 100));
        image(helmetImage, .5 * width - (imgSize/2), .45 * height - (imgSize/2), imgSize, imgSize);

        if (state == "break") {
           tint(color(255, 0, 0));
           image(breakImg, .5 * width - (imgSize/2), .45 * height - (imgSize/2), imgSize, imgSize);
        } else if (state == "rightTurn") {
            drawTurn("rightTurn");
        } else if (state == "leftTurn") {
            drawTurn("leftTurn");
        }
        pop();
    }

    void drawTurn(String turnDirection) {
        if(millis()-timeLastBlink > blinkTime) {
            timeLastBlink = millis();
            blinkTurnSignal = !blinkTurnSignal;
            return;
        }
        
        if(blinkTurnSignal){return;}
        
        PImage turnImg = turnDirection == "rightTurn" ? rightTurnImg : leftTurnImg;
        
        tint(color(255, 123, 0));
        image(turnImg, .5 * width - (imgSize/2), .45 * height - (imgSize/2), imgSize, imgSize);
    }
}
