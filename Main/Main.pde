PImage footOutline, footLogo;
List<UIButton> buttons;
Graph graph;
HelmetVisual helmetVisual;

static DataProcessor dataProcessor;

PImage helmetLogo, accidentLogo;
boolean crashDetected = false;
boolean showSOSPopup = false;
boolean showHelpPopup = false;

UIButton sosButton;
UIButton yesButton;
UIButton noButton;
UIButton exitButton;

String title = "Smart Helmet";
String scrollingMessage = "Help is on the way";
float messageX;

void setup() {
    size(480, 853);
    textFont(createFont("Arial", 100), 100);

    helmetLogo = loadImage("helmet.png");
    accidentLogo = loadImage("crash.png");

    buttons = new ArrayList<>();
    buttons.add(new UIButton(.025 * width, height - 210, .45 * width, 200, "Day Mode", color(220, 220, 220)));
    buttons.add(new UIButton(.525 * width, height - 210, .45 * width, 200, "Back", color(220, 220, 220)));

    UIButton settingsBtn = new UIButton(.78 * width, .12 * height, 80, 80, "Settings", color(175, 175, 175));
    buttons.add(settingsBtn);
    settingsBtn.setImage("helmet.png");

    graph = new Graph();
    helmetVisual = new HelmetVisual();
    dataProcessor = new DataProcessor();
    DataConnection.prepare(this, dataProcessor);

    sosButton = new UIButton(width * 0.35, height * 0.5, width * 0.3, 50, "SOS", color(255, 100, 100));
    yesButton = new UIButton(width * 0.3, height * 0.5, width * 0.15, 50, "YES", color(100, 255, 100));
    noButton = new UIButton(width * 0.55, height * 0.5, width * 0.15, 50, "NO", color(255, 100, 100));
    exitButton = new UIButton(width * 0.35, height - 100, width * 0.3, 50, "EXIT", color(255, 255, 100));

    messageX = width;
    frameRate(60);
}

void draw() {
    if (crashDetected) {
        drawCrashMode();
    } else {
        drawMainScreen();
        if (showSOSPopup) {
            drawSOSPopup();
        } else if (showHelpPopup) {
            drawHelpPopup();
        }
    }
}

void drawMainScreen() {
    background(240);

    drawTopBar();

    for (UIButton button : buttons) {
        button.draw();
    }

    DataConnection.update();
    helmetVisual.draw();
}

void drawTopBar() {
    push();
    fill(32, 92, 122);
    rect(0, 0, width, .1 * height);

    fill(255, 255, 255);
    textSize(.05 * height);
    textAlign(CENTER, CENTER);
    text(title, .5 * width, .05 * height);

    PImage iconToShow = crashDetected ? accidentLogo : helmetLogo;
    image(iconToShow, .02 * width, .01 * height, .12 * width, .08 * height);

    pop();
}

void drawSOSPopup() {
    fill(200);
    rect(width * 0.2, height * 0.3, width * 0.6, height * 0.4, 10);

    fill(0);
    textSize(24);
    textAlign(CENTER, CENTER);
    text("SOS", width * 0.5, height * 0.4);

    sosButton.draw();
}

void drawHelpPopup() {
    fill(200);
    rect(width * 0.15, height * 0.3, width * 0.7, height * 0.4, 10);

    fill(0);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("Are you hurt?\nDial for Help", width * 0.5, height * 0.4);

    yesButton.draw();
    noButton.draw();
}

void drawCrashMode() {
    background(255, 0, 0); 
    fill(255);
    textSize(30);
    textAlign(CENTER, CENTER);
    text(scrollingMessage, messageX, height / 2);
    messageX -= 2;
    if (messageX < -textWidth(scrollingMessage)) {
        messageX = width; 
    }

    drawTopBar();
    exitButton.draw();
}

void mousePressed() {
    if (showSOSPopup) {
        if (sosButton.isClicked(mouseX, mouseY)) {
            showSOSPopup = false;
            showHelpPopup = true; 
        }
    } else if (showHelpPopup) {
        if (yesButton.isClicked(mouseX, mouseY)) {
            println("Calling for Help...");
            crashDetected = true; 
            title = "Crash Mode"; 
            showHelpPopup = false;
        } else if (noButton.isClicked(mouseX, mouseY)) {
            println("No help needed.");
            showHelpPopup = false;
        }
    } else if (crashDetected) {
        if (exitButton.isClicked(mouseX, mouseY)) {
            println("Exiting Crash Mode...");
            crashDetected = false;
            title = "Smart Helmet";
        }
    } else {
        for (int i = 0; i < buttons.size(); i++) {
            UIButton button = buttons.get(i);

            if (button.isClicked(mouseX, mouseY)) {
                if (i == 0) {
                    println("day night mode");
                } else if (i == 2) {
                    println("clicked settings");
                    showSOSPopup = true;
                }
            }
        }
    }
}

void serialEvent(Serial p) {
    DataConnection.onSerialEvent(p);
}
