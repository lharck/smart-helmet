import processing.serial.*;
import java.util.Random;

static class DataConnection {
  private static Serial myPort;
  private static Boolean DEBUG_MODE = false;
  private static DataProcessor processor;
  private static Random rand;

  public static void prepare(PApplet app, DataProcessor dataProcessor) {
    println("Preparing data connection");
    print("    Devices: ");
    println(Serial.list());
    
    if (!DEBUG_MODE) {
      DEBUG_MODE = Serial.list().length <= 0;
    } else {
      println("Debug mode forcibly enabled, to turn it off, change the initial definition of DEBUG_MODE to false");
    }
    if (DEBUG_MODE) {
      println("Enabling debug mode, if this is a mistake, check your connections!");
    } else {
      println("Disabling debug mode, if this is a mistake, you can force it off by changing the initial definition of DEBUG_MODE to true");
      String whichPort = Serial.list()[0];
      myPort = new Serial(app, whichPort, 115200);
      myPort.bufferUntil('\n');
    }
    
    processor = dataProcessor;
    
    rand = new Random();
  }
  
  public static void update() {
    if (DEBUG_MODE) {
      processor.updateFSRReadings(rand.nextFloat() * 1023.0, rand.nextFloat() * 1023.0, rand.nextFloat() * 1023.0, rand.nextFloat() * 1023.0);
      processor.updateAcceleration(rand.nextFloat() * 20.0, rand.nextFloat() * 20.0, rand.nextFloat() * 20.0);
      processor.updateRotationalVelocity(rand.nextFloat() * 360.0, rand.nextFloat() * 360.0, rand.nextFloat() * 360.0);
      
      if (rand.nextFloat() < 0.05) {
        processor.updateFSRReadings(5.0, 5.0, 5.0, 5.0);
      }
    }
  }
  
  public static void onSerialEvent(Serial p) {
    String in = p.readString();
    
    String[] dataPoints = in.split(",");
    try {
      // fsr values 1-4 (int)
      processor.updateFSRReadings((float) Integer.parseInt(dataPoints[0]), (float) Integer.parseInt(dataPoints[1]), (float) Integer.parseInt(dataPoints[2]), (float) Integer.parseInt(dataPoints[3]));
    } catch (Exception e) {
      // Ignore invalid parsing, must be incomplete input line
    }
    
    try {
      // acceleration xyz (float)
      processor.updateAcceleration(Float.parseFloat(dataPoints[4]), Float.parseFloat(dataPoints[5]), Float.parseFloat(dataPoints[6]));
    } catch (Exception e) {
      // Ignore invalid parsing, must be incomplete input line
    }
    
    try {
      // rotational velocity xyz (float)
      processor.updateRotationalVelocity(Float.parseFloat(dataPoints[7]), Float.parseFloat(dataPoints[8]), Float.parseFloat(dataPoints[9]));
    } catch (Exception e) {
      // Ignore invalid parsing, must be incomplete input line
    }
  }
}
