class Graph {
  int bufferSize = 100;
  ArrayList<Float>[] dataBuffers;
  color[] colors;

  Graph() {
    dataBuffers = new ArrayList[4];
    colors = new color[4];
    
    colors[0] = color(255, 0, 0); 
    colors[1] = color(255, 255, 0); 
    colors[2] = color(0, 255, 0);  
    colors[3] = color(0, 0, 255); 

    for (int i = 0; i < 4; i++) {
      dataBuffers[i] = new ArrayList<Float>();
      for (int j = 0; j < bufferSize; j++) {
        dataBuffers[i].add(0.0);
      }
    }
  }

  void display(float[] fsrData) {
    int startX = 340, startY = 200, graphWidth = 200, graphHeight = 200;
    for (int i = 0; i < 4; i++) {
      int x = startX + (i % 2) * (graphWidth + 20);
      int y = startY + (i / 2) * (graphHeight + 20);
      updateBuffer(i, fsrData[i]); 
      
      //drawScrollingGraph(x, y, graphWidth, graphHeight, dataBuffers[i], DataConnection.getSectionLabel(i), colors[i]);
    }
  }

  void displaySection(float[] fsrData, int section) {
    int startX = 335, startY = 200, graphWidth = 400, graphHeight = 400; 
    int x = startX;
    int y = startY;

    updateBuffer(section - 1, fsrData[section - 1]); 

    //drawScrollingGraph(x, y, graphWidth, graphHeight, dataBuffers[section - 1], DataConnection.getSectionLabel(section - 1), colors[section - 1]);
  }

  void updateBuffer(int index, float value) {
    if (dataBuffers[index].size() >= bufferSize) {
      dataBuffers[index].remove(0);
    }
    dataBuffers[index].add(value);
  }

  void drawScrollingGraph(int x, int y, int w, int h, ArrayList<Float> dataBuffer, String title, color graphColor) {
    pushStyle();

    int titleMargin = 25; 

    fill(0, 0, 0, 50); 
    noStroke();
    rect(x + 5, y + 5, w, h, 10); 

    for (int i = 0; i < h; i++) {
      float inter = map(i, 0, h, 1.0, 0.9); 
      fill(255 * inter, 255 * inter, 255);  
      noStroke();
      rect(x, y + i, w, 1); 
    }

    stroke(180); 
    strokeWeight(1);
    noFill();
    rect(x, y, w, h, 10);

    fill(153, 153, 153, 255);
    noStroke();
    rectMode(CENTER);
    rect(x + w / 2, y + titleMargin / 2, textWidth(title) + 15, titleMargin - 5, 8);

    fill(graphColor);
    textAlign(CENTER, CENTER);
    textSize(18); 
    text(title, x + w / 2, y + titleMargin / 2);

    stroke(180); 
    line(x, y + h, x + w, y + h);

    noFill();
    stroke(graphColor);
    strokeWeight(2.5);

    beginShape();
    for (int i = 0; i < dataBuffer.size(); i++) {
      float value = dataBuffer.get(i);
      float xPos = map(i, 0, dataBuffer.size() - 1, x, x + w);
      float yPos = y + h - value * (h - titleMargin) / 1023;
      vertex(xPos, yPos);
    }
    endShape();

    popStyle();
  }

}
