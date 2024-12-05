import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;

class DataProcessor {
  private float[] fsrReadings = new float[4];
  private List<float[]> oldFSRReadings = new ArrayList<>();
  // Stores XYZ acceleration
  private float[] acceleration = new float[3];
  private List<float[]> oldAccelerationReadings = new ArrayList<>();
  // Stores XYZ rotational velocity
  private float[] rotationalVelocity = new float[3];

  private float stepLength, strideLength, cadence, speed;
  private int stepCount;

  private float[] stepValues = new float[5];
  private int startTime;

  public DataProcessor() {
    for (int i = 0; i < fsrReadings.length; i++) {
      fsrReadings[i] = 0.0;
    }
    for (int i = 0; i < acceleration.length; i++) {
      acceleration[i] = 0.0;
    }
    for (int i = 0; i < rotationalVelocity.length; i++) {
      rotationalVelocity[i] = 0.0;
    }

    stepLength = 1.66; // feet
    strideLength = 3.33; // feet
    startTime = millis();
    // cadence = steps/min
    // speed = mph
    // stepCount = step count
    cadence = speed = 0;
    stepCount = 0;
  }
  
  private boolean canBeConsideredOffGround(float[] fsrData) {
    return (fsrData[0] <= 10.0 && fsrData[1] <= 10.0 && fsrData[2] <= 10.0 && fsrData[3] <= 10.0);
  }

  public void setFSRReadings(float[] newFSRReadings) {
    boolean wasOffGround = canBeConsideredOffGround(fsrReadings);
    fsrReadings = newFSRReadings;

    oldFSRReadings.add(Arrays.copyOf(fsrReadings, fsrReadings.length));

    if (oldFSRReadings.size() > 300) {
      oldFSRReadings.remove(0);
    }

    recalculateStepMode();
    
    if (wasOffGround && !canBeConsideredOffGround(fsrReadings)) {
      stepCount += 2;
      int currTime = millis();
      int timeDiff = currTime - startTime;
      float timeDiffSeconds = ((float) timeDiff) / 1000.0;
      float timeDiffMinutes = timeDiffSeconds / 60.0;
      cadence = stepCount / timeDiffMinutes;
      float feetTraveled = stepLength * stepCount;
      float milesTraveled = feetTraveled / 5280.0;
      float timeDiffHours = timeDiffMinutes / 60.0;
      speed = milesTraveled / timeDiffHours;
    }
  }

  public void setAcceleration(float[] newAcceleration) {
    acceleration = newAcceleration;

    oldAccelerationReadings.add(Arrays.copyOf(acceleration, acceleration.length));

    if (oldAccelerationReadings.size() > 60) {
      oldAccelerationReadings.remove(0);
    }

    recalculateIsMoving();
  }

  public void setRotationVelocity(float[] newRotVel) {
    rotationalVelocity = newRotVel;
  }


  private int currentStepMode = 0;

  private void recalculateStepMode() {
    float totalMFP = 0.0;

    for (int i = 0; i < oldFSRReadings.size(); ++i) {
      totalMFP += ((oldFSRReadings.get(i)[0] + oldFSRReadings.get(i)[2]) * 100.0)/(oldFSRReadings.get(i)[2] + oldFSRReadings.get(i)[0] + oldFSRReadings.get(i)[1] + oldFSRReadings.get(i)[3] + 0.001);
    }

    totalMFP /= ((float)oldFSRReadings.size());

    int indexInStepModes = 0;
    while (indexInStepModes < 4) {
      if (totalMFP >= stepValues[indexInStepModes] && totalMFP <= stepValues[indexInStepModes + 1]) {
        float distanceFromLeft = Math.abs(totalMFP - stepValues[indexInStepModes]);
        float distanceFromRight = Math.abs(stepValues[indexInStepModes] - totalMFP);
        if (distanceFromLeft < distanceFromRight) {
          currentStepMode = indexInStepModes;
          return;
        } else {
          currentStepMode = indexInStepModes + 1;
          return;
        }
      } else {
        indexInStepModes++;
      }
    }
    currentStepMode = 4;
  }

  Boolean isMoving = false;

  private void recalculateIsMoving() {
    float totalAcceleration = 0.0;

    for (int i = 0; i < oldAccelerationReadings.size(); ++i) {
      float x = oldAccelerationReadings.get(i)[0];
      float y = oldAccelerationReadings.get(i)[1];
      float z = oldAccelerationReadings.get(i)[2];
      totalAcceleration += Math.sqrt((x * x) + (y * y) + (z * z));
    }

    totalAcceleration /= oldAccelerationReadings.size();

    isMoving = (Math.abs(totalAcceleration - 9.81) >= 1.0);
  }

  public void updateFSRReadings(float val0, float val1, float val2, float val3) {
    boolean wasOffGround = canBeConsideredOffGround(fsrReadings);
    fsrReadings[0] = val0;
    fsrReadings[1] = val1;
    fsrReadings[2] = val2;
    fsrReadings[3] = val3;

    oldFSRReadings.add(Arrays.copyOf(fsrReadings, fsrReadings.length));

    if (oldFSRReadings.size() > 300) {
      oldFSRReadings.remove(0);
    }

    recalculateStepMode();
    
    if (wasOffGround && !canBeConsideredOffGround(fsrReadings)) {
      stepCount += 2;
      int currTime = millis();
      int timeDiff = currTime - startTime;
      float timeDiffSeconds = ((float) timeDiff) / 1000.0;
      float timeDiffMinutes = timeDiffSeconds / 60.0;
      cadence = stepCount / timeDiffMinutes;
      float feetTraveled = stepLength * stepCount;
      float milesTraveled = feetTraveled / 5280.0;
      float timeDiffHours = timeDiffMinutes / 60.0;
      speed = milesTraveled / timeDiffHours;
    }
  }

  public void updateAcceleration(float x, float y, float z) {
    acceleration[0] = x;
    acceleration[1] = y;
    acceleration[2] = z;

    oldAccelerationReadings.add(Arrays.copyOf(acceleration, acceleration.length));

    if (oldAccelerationReadings.size() > 60) {
      oldAccelerationReadings.remove(0);
    }

    recalculateIsMoving();
  }

  public void updateRotationalVelocity(float x, float y, float z) {
    rotationalVelocity[0] = x;
    rotationalVelocity[1] = y;
    rotationalVelocity[2] = z;
  }

  public float[] getFSRReadings() {
    return fsrReadings;
  }

  public float[] getAcceleration() {
    return acceleration;
  }

  public float[] getRotationalVelocity() {
    return rotationalVelocity;
  }

  public int getCurrentStepMode() {
    return currentStepMode;
  }

  public Boolean getIsMoving() {
    return isMoving;
  }

  public String getCurrentStepModeIdentifier() {
    switch (currentStepMode) {
    case 0:
      return "heel walking";
    case 1:
      return "tip-toeing";
    case 2:
      return "in-toe walking";
    case 3:
      return "walking normally";
    case 4:
      return "out-toe walking";
    default:
      return "walking normally";
    }
  }

  public String getIsMovingIdentifier() {
    return isMoving ? "in motion" : "standing still";
  }
}
