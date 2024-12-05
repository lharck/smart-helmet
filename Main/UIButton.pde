class UIButton {
    float xPos, yPos, xSize, ySize;
    String Text;
    boolean disabled;
    int hoverColor, textColor;
    color buttonColor;
    float cornerRadius;
    boolean shadow;
    PImage btnImage; 
    
    UIButton(float initXPos, float initYPos, float initXSize, float initYSize, String Text) {  
        this(initXPos, initYPos, initXSize, initYSize, Text, color(255)); 
    }

    UIButton(float initXPos, float initYPos, float initXSize, float initYSize, String Text, color initButtonColor) {  
        xPos = initXPos;
        yPos = initYPos;
        xSize = initXSize;
        ySize = initYSize;
        this.Text = Text;
        buttonColor = initButtonColor;
        hoverColor = lerpColor(buttonColor, color(200), 0.5); 
        textColor = color(0); 
        cornerRadius = 10; 
        shadow = false;  
        disabled = false;

        setRoundedCorners(10);
        setShadow(false);
    }

    void setDisabled(boolean isDisabled) { disabled = isDisabled; }
    void setHoverColor(int newHoverColor) { hoverColor = newHoverColor; }
    void setTextColor(int newTextColor) { textColor = newTextColor; }
    void setRoundedCorners(float newCornerRadius) { cornerRadius = newCornerRadius; }
    void setShadow(boolean hasShadow) { shadow = hasShadow; }

    void draw() {
         push();
        fill(disabled ? 150 : isHovered(mouseX, mouseY) ? hoverColor : buttonColor);
        stroke(_darken(this.buttonColor,-50));
        fill(buttonColor);
        rect(xPos, yPos, xSize, ySize, cornerRadius);
        
        if (shadow && !disabled) {
            fill(0, 50); rect(xPos + 5, yPos + 5, xSize, ySize, cornerRadius);
        }
        
        if(btnImage!=null){
            image(btnImage, xPos +(.15*xSize), yPos + (.15*ySize), .75*xSize, .75*ySize);
        } else {
            fill(textColor);
            textSize(20); textAlign(CENTER, CENTER); text(this.Text, xPos + xSize / 2, yPos + ySize / 2);
        }
        pop();
    }
    
    
    void setImage(String imageLocation){
        btnImage = loadImage(imageLocation);
    }
 

    color _darken(color c, float amount) {
      float r = red(c);
      float g = green(c);
      float b = blue(c);
      
      r = max(0, r - amount);
      g = max(0, g - amount);
      b = max(0, b - amount);
      
      return color(r, g, b);
    }
    boolean isClicked(float mouseX, float mouseY) { return !disabled && mouseX > xPos && mouseX < xPos + xSize && mouseY > yPos && mouseY < yPos + ySize; }
    boolean isHovered(float mouseX, float mouseY) { return mouseX > xPos && mouseX < xPos + xSize && mouseY > yPos && mouseY < yPos + ySize; }
}
