PImage footOutline, footLogo;
List<UIButton> buttons;
Graph graph;
HelmetVisual helmetVisual;

static DataProcessor dataProcessor;
PImage helmetLogo;

UIButton exitButton;
int currentSection = 0;


void setup() {
    size(480, 853);

    textFont(createFont("Arial", 100), 100);
    helmetLogo = loadImage("helmet.png");

    buttons = new ArrayList<>();
    buttons.add(new UIButton(.025*width, height-210, .45*width, 200, "Day Mode", color(220,220,220)));
    buttons.add(new UIButton(.525*width, height-210, .45*width, 200, "Back", color(220,220,220)));
    
    UIButton settingsBtn = new UIButton(.78*width, .12*height, 80, 80, "Settings", color(175,175,175));
    buttons.add(settingsBtn);
    settingsBtn.setImage("helmet.png");


    graph = new Graph();
    helmetVisual = new HelmetVisual();
    dataProcessor = new DataProcessor();
    DataConnection.prepare(this, dataProcessor);
    
    frameRate(60);
}


void draw() {
    drawMainScreen();
}

void updatePressures() {
    float fsrReadings[] = dataProcessor.getFSRReadings();
}

void drawMainScreen() {
    background(240);

    drawTopBar();
    //graph.drawScrollingGraph(100, 100, 200, 200, "title", color(0,10,100));

    for (UIButton button : buttons) {
        button.draw();
    }

    DataConnection.update();
    updatePressures();
    helmetVisual.draw();
}

void mousePressed() {
    for (int i = 0; i < buttons.size(); i++) {
        UIButton button = buttons.get(i);
        
        if (button.isClicked(mouseX, mouseY)) {
            // clicked day night mode
            if(i == 0){  
                println("day night mode");
                
            // Clicked settings
            } else if(i == 2){ 
                println("clicked settings");   
            }
        }
    }
}


void drawTopBar() {
    push();
    fill(32, 92, 122);
    rect(0, 0, width, .1 * height);
    textSize(.05 * height);
    textAlign(CENTER, CENTER);
    textFont(createFont("Arial Bold", 100), 100);

    String appName = "Smart Helmet";
    fill(255, 255, 255);
    textSize(.05 * height);
    textAlign(CENTER, CENTER);
    text(appName, .5 * width, .05 * height);

    image(helmetLogo, .02 * width, .01 * height, .12 * width, .08 * height);
   
    pop();
}

void serialEvent(Serial p) {
    DataConnection.onSerialEvent(p);
}
