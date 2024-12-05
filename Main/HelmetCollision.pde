class HelmetCollision {
    
    int avgThreshold = 1000;
    int[] pressures = {0,0,0,0};
    int NUM_SENSORS = 4;
    
    PImage warningImg = loadImage("warning.png");
    
    // gives room for tweaking if one sensor is more finicky than the others
    int[] collisionThresholds = {avgThreshold, avgThreshold, avgThreshold, avgThreshold};
    
    HelmetCollision() {
        
    }
    
    // check if theres a collision at the sensor
    boolean isCollidingAt(int sensorNum) {
        return (pressures[sensorNum] > collisionThresholds[sensorNum]);
    }
    
    boolean isCollision(){
        for(int i = 0; i < NUM_SENSORS; i++){
            if(isCollidingAt(i)){
                 return true;   
            }
        }
        
        return false;
    }
    
    // gets whether there is a collision at each sensor
    boolean[] getCollisions(){
        return new boolean[]{isCollidingAt(0), isCollidingAt(1), isCollidingAt(2), isCollidingAt(3)};
    }
    
    // sets a pressure state
    void updatePressure(int sensorNum, int newVal){
        pressures[sensorNum] = newVal;
    }
    
    void draw(){
        if(isCollision()){
            drawCollision();
        }
    }
    
    void drawCollision(){
        push();
        imageMode(CENTER);
        image(warningImg, width/2, height/2);
        pop();
    }
    
}
