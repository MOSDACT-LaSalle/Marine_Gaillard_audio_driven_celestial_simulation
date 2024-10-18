/*---------------------------------
 Name: Marine Gaillard  
 Date: October 2024  
 Title: Cosmic Harmony - Audio-Visual Synchronization  

 Description: 
 This Processing sketch creates a dynamic audio-visual experience by combining various space-themed visual elements that react to music. The visuals include planets with rings, orbiting planets, kaleidoscopic particles, rotating axes, nebulae, shooting stars, and more. Users can interact with the sketch using keyboard inputs to toggle different visual modes and effects.  

 Features: 
 - Planets with realistic textures and rings.  
 - Orbiting planets with adjustable ring sizes to avoid overlap with orbits.  
 - Kaleidoscopic particles that can be toggled on and off.  
 - Rotating axes that can be toggled on and off.  
 - Visual elements synchronized with audio amplitude.  
 - Ability to restart the animation and activate random visual modes.  
 - Interactive controls via keyboard inputs.  

 Instructions: 
 - Place the `Toxicity.mp3` audio file inside the `data` folder of your sketch.  
 - Ensure the Minim library is installed in your Processing IDE.  
 - Run the sketch and use the following keys to interact:  
   - '1': Use planets from the first code without axes.  
   - '2': Display orbiting planets without axes.  
   - '3': Display orbiting planets with axes.  
   - '4': Display planets from the first code with rings and axes.  
   - '5': Toggle planet appearance between realistic and amplitude-based colors.  
   - '6': Toggle display of rings only.  
   - '7': Toggle the kaleidoscope effect on and off.  
   - '8': Toggle the rotating axes on and off.  
   - '9': Activate random visual elements synchronized with the music.  
   - '0': Restart the animation from the beginning.  

 Links:  
 https://github.com/Mgbaronne/Marine_Gaillard_audio_driven_celestial_simulation  
---------------------------------*/

// ================== Imports ==================
import ddf.minim.*;
import java.util.ArrayList;

// ================== Global Declarations ==================

// Minim and Audio
Minim minim;
AudioPlayer song;
AudioBuffer songBuffer;

// Lists for planets, particles, and effects
ArrayList<Planet> planets = new ArrayList<Planet>(); // From first code
ArrayList<OrbitingPlanet> orbitingPlanets = new ArrayList<OrbitingPlanet>(); // From second code

ArrayList<RingParticle> ringParticles = new ArrayList<RingParticle>();
ArrayList<RingParticle> explosionParticles = new ArrayList<RingParticle>();
ArrayList<BackgroundStar> stars = new ArrayList<BackgroundStar>();
ArrayList<NebulaParticle> nebulaParticles = new ArrayList<NebulaParticle>();
ArrayList<ShootingStar> shootingStars = new ArrayList<ShootingStar>();
ArrayList<GalaxyParticle> galaxyParticles = new ArrayList<GalaxyParticle>();

// Control variables for planet
float planetBrightness = 150;
float pulseSpeed = 1;  // Static speed for pulse effect, not tied to music
float zoom = 0; 
boolean exploded = false;
int phase = 1;

// Variables to manage phase transitions
int transitionDuration = 300; 
int phase2Start, phase3Start;

// Flow Field System
ArrayList<FlowParticle> flowParticles = new ArrayList<FlowParticle>(); 
ArrayList<FlowKaleidoscopeParticle> flowKaleidoscopeParticles = new ArrayList<FlowKaleidoscopeParticle>(); 
int numFlowParticles = 600;            
int numFlowKaleidoscopeParticles = 400;    
PVector flowCenter;                    
float phaseAngleFlow = 0;              
int phaseDurationFlow = 600;           
float zoomFlow = 1;                    
float zoomSpeedFlow = 0.001;           

// Variables from second code
ArrayList<KaleidoParticle> kaleidoscopeParticles = new ArrayList<KaleidoParticle>();
ArrayList<FlickerStar> whiteStars = new ArrayList<FlickerStar>();
ArrayList<FlickerStar> redStars = new ArrayList<FlickerStar>();

int numWhiteStars = 500;
int numRedStars = 100;
int symmetry = 8;

boolean showKaleidoscope = true;
boolean showPlanets = false;
boolean showAxes = false;

// New variables for toggling planet appearances and rings
int planetMode = 1; // 1 for planets from first code, 2 for OrbitingPlanet, 3 for planets with rings and axes
boolean togglePlanetAppearance = false; // For key '5'
boolean showRingsOnly = false;          // For key '6'

float[] orbitRadiusArray = {60, 120, 200, 300, 420, 550, 690, 850};
float[] orbitSpeedArray = {0.006, 0.004, 0.003, 0.0025, 0.002, 0.0015, 0.001, 0.0008};
float[] ringRotationSpeed = {0.01, 0.015, 0.02};

boolean syncWithMusic = false; // For syncing rotations and pulsations with music
int mode5State = 0; // For cycling modes with key '5'

// ================== Setup Function ==================
void setup() {
  fullScreen(P3D);
  smooth();

  // Initialize Minim and load the song
  minim = new Minim(this);
  song = minim.loadFile("Toxicity.mp3");

  if (song == null) {
    println("Error: Could not load the song. Make sure Toxicity.mp3 is in the data folder.");
    exit(); // Stop if the file is not found
  }

  song.play();
  songBuffer = song.mix; // Use the audio buffer for amplitude analysis

  // Initialize planets from first code
  planets.add(new Planet(200, 60)); 
  planets.add(new Planet(300, 50)); 
  planets.add(new Planet(400, 70)); 

  // Initialize orbiting planets from second code
  orbitingPlanets.add(new OrbitingPlanet(200, 60));
  orbitingPlanets.add(new OrbitingPlanet(300, 40));
  orbitingPlanets.add(new OrbitingPlanet(400, 80));

  // Nebula particles
  for (int i = 0; i < 2000; i++) {
    nebulaParticles.add(new NebulaParticle());
  }

  // Shooting stars
  for (int i = 0; i < 20; i++) {
    shootingStars.add(new ShootingStar());
  }

  // Background stars from first code
  for (int i = 0; i < 300; i++) {
    stars.add(new BackgroundStar());
  }

  // Background white stars from second code
  for (int i = 0; i < numWhiteStars; i++) {
    whiteStars.add(new FlickerStar(false)); // false for white star
  }

  // Background red stars
  for (int i = 0; i < numRedStars; i++) {
    redStars.add(new FlickerStar(true)); // true for red star
  }

  // Ring particles
  for (int i = 0; i < 500; i++) {
    ringParticles.add(new RingParticle());
  }

  // Galaxy particles
  for (int i = 0; i < 100; i++) {
    galaxyParticles.add(new GalaxyParticle(width / 2, height / 2));
  }

  // Flow particles
  for (int i = 0; i < numFlowParticles; i++) {
    flowParticles.add(new FlowParticle());
  }

  // Flow Kaleidoscope particles
  for (int i = 0; i < numFlowKaleidoscopeParticles; i++) {
    flowKaleidoscopeParticles.add(new FlowKaleidoscopeParticle());
  }

  // Kaleidoscope particles from second code
  for (int i = 0; i < 500; i++) {
    kaleidoscopeParticles.add(new KaleidoParticle(random(width / 2), random(height / 2), random(1, 4)));
  }

  flowCenter = new PVector(width / 2, height / 2); 
  phase2Start = transitionDuration; 
  phase3Start = phase2Start + transitionDuration; 
}

// ================== Draw Function ==================
void draw() {
  background(0, 30); // Use trailing effect
  lights();

  // Depth zoom effect, not tied to audio
  zoom = sin(frameCount * 0.01) * 100;
  translate(width / 2, height / 2, zoom);

  // Combine rotations
  rotateY(frameCount * 0.01);

  // Get the average amplitude from the audio buffer
  float amplitude = getAverageAmplitude();

  // Background stars from first code
  for (BackgroundStar star : stars) {
    star.update();
    star.display();
  }

  // Flickering white stars
  for (FlickerStar star : whiteStars) {
    star.update(amplitude);
    star.display();
  }

  // Flickering red stars
  for (FlickerStar redStar : redStars) {
    redStar.update(amplitude);
    redStar.display();
  }

  // Nebula particles
  for (NebulaParticle p : nebulaParticles) {
    p.update();
    p.display();
  }

  // Shooting stars
  for (ShootingStar s : shootingStars) {
    s.update();
    s.display();
  }

  // Kaleidoscope effect from second code
  if (showKaleidoscope) {
    drawKaleidoscopeParticles(amplitude);
  }

  // Flow field and kaleidoscope from first code
  if (exploded) {
    displayFlowField();
    displayFlowKaleidoscope();
  }

  // Manage planet phases from first code
  if (frameCount < phase2Start) {
    if (planetMode == 1 || planetMode == 3) {
      displayRealisticPlanet();
    }
  } else if (frameCount < phase3Start) {
    if (planetMode == 1 || planetMode == 3) {
      displayMarsLikePlanet();
    }
  } else {
    if (!exploded && (planetMode == 1 || planetMode == 3)) {
      displayGlowingPlanet();
    }

    // Ring particles
    for (RingParticle p : ringParticles) {
      p.update();
      p.display();
    }

    controlPulse();  // This will use static values, not audio-driven

    // Explosion particles
    if (exploded) {
      for (RingParticle p : explosionParticles) {
        p.update();
        p.display();
      }
    }
  }

  // Galaxy particles
  for (int i = galaxyParticles.size() - 1; i >= 0; i--) {
    GalaxyParticle p = galaxyParticles.get(i);
    p.update();
    p.display();
    if (p.isOffScreen()) {
      galaxyParticles.remove(i);
    }
  }

  // Planets from first code
  if (planetMode == 1 || planetMode == 3) {
    for (Planet planet : planets) {
      planet.update();
      planet.displayWithRings(amplitude, planetMode == 3 || showAxes || showRingsOnly); // Pass whether to display rings and axes
    }
  }

  // Orbiting planets from second code
  if (planetMode == 2 && showPlanets) {
    for (OrbitingPlanet planet : orbitingPlanets) {
      planet.update();
      planet.display(amplitude);
    }
  }

  // Rotating axes from second code
  if (showAxes) {
    drawRotatingAxes(amplitude);
  }
}

// Function to calculate average amplitude from audio buffer
float getAverageAmplitude() {
  float total = 0;
  for (int i = 0; i < songBuffer.size(); i++) {
    total += abs(songBuffer.get(i));
  }
  return total / songBuffer.size();
}

// Function to switch between phases
void keyPressed() {
  if (key == '1') {
    planetMode = 1; // Use planets from first code
    showPlanets = false; // Not showing orbiting planets
    showAxes = false;
  }
  if (key == '2') {
    planetMode = 2; // Use orbiting planets
    showPlanets = true; // Show orbiting planets
    showAxes = false;
  }
  if (key == '3') {
    planetMode = 2; // Use orbiting planets
    showPlanets = true; // Show orbiting planets
    showAxes = true;  // Show axes
  }
  if (key == '4') {
    planetMode = 3; // New mode: planets with rings and axes
    showPlanets = false; // Use planets from first code
    showAxes = true;  // Show rotating axes
  }
  if (key == '5') {
    togglePlanetAppearance = !togglePlanetAppearance; // Toggle planet appearance
  }
  if (key == '6') {
    showRingsOnly = !showRingsOnly; // Toggle display of rings only
  }
  if (key == '7') {
    showKaleidoscope = !showKaleidoscope; // Toggle the kaleidoscope particles
  }
  if (key == '8') {
    showAxes = !showAxes; // Toggle axes on and off
  }
  if (key == '0') {
    restartAnimation(); // Restart animation from the beginning
  }
  if (key == '9') {
    activateRandomVisuals(); // Activate random visual elements synced with music
  }
}

// Function to restart the animation
void restartAnimation() {
  // Reset variables to their initial states
  frameCount = 0;
  exploded = false;
  planetBrightness = 150;
  pulseSpeed = 1;
  phase = 1;
  planetMode = 1;
  showPlanets = false;
  showAxes = false;
  showRingsOnly = false;
  togglePlanetAppearance = false;
  showKaleidoscope = true;
  syncWithMusic = false;
  mode5State = 0;

  // Reinitialize planets
  planets.clear();
  planets.add(new Planet(200, 60)); 
  planets.add(new Planet(300, 50)); 
  planets.add(new Planet(400, 70)); 

  orbitingPlanets.clear();
  orbitingPlanets.add(new OrbitingPlanet(200, 60));
  orbitingPlanets.add(new OrbitingPlanet(300, 40));
  orbitingPlanets.add(new OrbitingPlanet(400, 80));

  // Reinitialize particles
  ringParticles.clear();
  for (int i = 0; i < 500; i++) {
    ringParticles.add(new RingParticle());
  }

  explosionParticles.clear();

  // Reinitialize other particles if necessary
  // (Add code here if other particles need resetting)
}

// Function to activate random visual elements synced with music
void activateRandomVisuals() {
  // Randomly select visual elements to display, synchronized with music
  planetMode = int(random(1, 4)); // Randomly select planet mode 1, 2, or 3
  showPlanets = (planetMode == 2);
  showAxes = random(1) > 0.5; // Randomly decide to show axes or not
  showRingsOnly = random(1) > 0.5;
  togglePlanetAppearance = random(1) > 0.5;
  showKaleidoscope = random(1) > 0.5;

  // Optionally, set syncWithMusic to true to sync rotations and pulsations
  syncWithMusic = true;
}

// Draw kaleidoscope particles from second code
void drawKaleidoscopeParticles(float amplitude) {
  pushMatrix();
  translate(0, 0); // Keep kaleidoscope particles in the center
  
  for (int i = 0; i < symmetry; i++) {
    rotate(TWO_PI / symmetry); // Rotate by a fraction of the full circle
    for (KaleidoParticle p : kaleidoscopeParticles) {
      p.update(amplitude);
      p.display(amplitude);
    }
  }
  popMatrix();
}

// Draw rotating axes from second code
void drawRotatingAxes(float amplitude) {
  for (int i = 0; i < orbitRadiusArray.length; i++) {
    float orbitThickness = map(orbitRadiusArray[i], orbitRadiusArray[0], orbitRadiusArray[orbitRadiusArray.length - 1], 1, 4);
    stroke(255, 150); // Clear white orbit lines
    strokeWeight(orbitThickness);
    noFill();
    
    // Rotate orbits, adding precise chaos
    pushMatrix();
    float rotationSpeedX = orbitSpeedArray[i] * (1 + i * 0.5);
    float rotationSpeedY = orbitSpeedArray[i] * (1 + (orbitRadiusArray.length - i) * 0.5);
    if (syncWithMusic) {
      rotationSpeedX *= (1 + amplitude);
      rotationSpeedY *= (1 + amplitude);
    }
    rotateX(frameCount * rotationSpeedX); // Rotate with amplitude influence if syncWithMusic
    rotateY(frameCount * rotationSpeedY); // Rotate around Y axis with amplitude

    // Draw the main ellipse representing the orbit path
    ellipse(0, 0, orbitRadiusArray[i] * 3.5, orbitRadiusArray[i] * 2.8); // Larger and more stretched
    popMatrix();
  }
}

// Function to generate color based on amplitude mapped to hue
int colorFromAmplitude(float hueValue) {
  colorMode(HSB, 255); // Set color mode to HSB
  int col = color(hueValue, 200, 255); // Opaque color
  colorMode(RGB, 255); // Reset to RGB for other uses
  return col;
}

// ================== Planet Display and Phases ==================
void displayRealisticPlanet() {
  float planetSize = 250;
  float detail = 100;

  for (float lat = -HALF_PI; lat < HALF_PI; lat += PI / detail) {
    beginShape(TRIANGLE_STRIP);
    for (float lon = 0; lon <= TWO_PI + PI / detail; lon += PI / detail) {
      for (int i = 0; i < 2; i++) {
        float currentLat = lat + (i * PI / detail);
        float r = planetSize / 2;

        float noiseValue = noise(currentLat * 3, lon * 3 + frameCount * 0.005);
        float craterDepth = noise(currentLat * 5, lon * 5);

        float red = map(noiseValue, 0, 1, 180, 255);
        float green = map(noiseValue, 0, 1, 60, 140);
        float blue = map(noiseValue, 0, 1, 30, 80);

        if (craterDepth > 0.6) {
          red *= 0.8;
          green *= 0.6;
          blue *= 0.6;
        }

        fill(red, green, blue);

        float z = sin(currentLat) * r;
        float xy = cos(currentLat) * r;
        float vx = cos(lon) * xy;
        float vy = sin(lon) * xy;

        vertex(vx, vy, z);
      }
    }
    endShape();
  }
}

void displayMarsLikePlanet() {
  float planetSize = 250;
  float detail = 100;

  for (float lat = -HALF_PI; lat < HALF_PI; lat += PI / detail) {
    beginShape(TRIANGLE_STRIP);
    for (float lon = 0; lon <= TWO_PI + PI / detail; lon += PI / detail) {
      for (int i = 0; i < 2; i++) {
        float currentLat = lat + (i * PI / detail);
        float r = planetSize / 2;

        float noiseValue = noise(currentLat * 2 + frameCount * 0.01, lon * 2 + frameCount * 0.01);
        float darkMatterEffect = noise(currentLat * 5 + frameCount * 0.02, lon * 5 + frameCount * 0.02);

        float red = map(noiseValue, 0, 1, 200, 255);
        float green = map(noiseValue, 0, 1, 0, 50);
        float blue = 0;

        if (darkMatterEffect > 0.5) {
          red *= 0.4;
          green *= 0.2;
        }

        fill(red, green, blue);

        float z = sin(currentLat) * r;
        float xy = cos(currentLat) * r;
        float vx = cos(lon) * xy;
        float vy = sin(lon) * xy;

        vertex(vx, vy, z);
      }
    }
    endShape();
  }
}

void displayGlowingPlanet() {
  noStroke();
  float planetSize = 250;

  fill(255, 0, 0, planetBrightness);  // Use a static brightness effect
  sphere(planetSize);
}

// Control the pulse without syncing with music
void controlPulse() {
  planetBrightness += pulseSpeed;
  if (planetBrightness > 255 || planetBrightness < 100) {
    pulseSpeed *= -1;
  }

  // Explosion trigger based on brightness level
  if (planetBrightness > 250 && !exploded) {
    triggerExplosion();
    exploded = true;
  }
}

void triggerExplosion() {
  float planetSize = 250;

  for (int i = 0; i < 1000; i++) {
    explosionParticles.add(new RingParticle(random(-planetSize, planetSize), random(-planetSize, planetSize), random(-planetSize, planetSize)));
  }
}

// ================== Flow Field and Kaleidoscope ==================
void displayFlowField() {
  pushMatrix();
  translate(flowCenter.x, flowCenter.y);
  rotate(phaseAngleFlow);
  
  for (FlowParticle fp : flowParticles) {
    fp.update();
    fp.display();
  }
  
  phaseAngleFlow += 0.001;
  popMatrix();
}

void displayFlowKaleidoscope() {
  pushMatrix();
  translate(flowCenter.x, flowCenter.y);
  rotate(phaseAngleFlow);
  
  for (FlowKaleidoscopeParticle kp : flowKaleidoscopeParticles) {
    kp.update();
    kp.display();
  }
  
  phaseAngleFlow += 0.001;
  popMatrix();
}

// ================== Classes for Objects ==================

// Planet class from first code, modified to include rings and axes
class Planet {
  float orbitRadius;
  float planetSize;
  float angle;
  float speed;
  PShape ringShape;

  Planet(float orbitRadius, float size) {
    this.orbitRadius = orbitRadius;
    this.planetSize = size;
    angle = random(TWO_PI);
    speed = random(0.01, 0.03);
    ringShape = createRing(planetSize * 0.8, planetSize * 1.2, 60); // Adjusted ring sizes
  }

  void update() {
    angle += speed;
  }

  void display() {
    displayWithRings(0, false); // Default display without rings and axes
  }

  void displayWithRings(float amplitude, boolean showRingsAndAxes) {
    pushMatrix();
    float x = cos(angle) * orbitRadius;
    float y = sin(angle) * orbitRadius;
    translate(x, y);

    // Apply rotation if rings and axes are to be shown
    if (showRingsAndAxes) {
      rotateX(frameCount * ringRotationSpeed[0] * (1 + amplitude)); // Rotate around X axis
      rotateY(frameCount * ringRotationSpeed[1] * (1 + amplitude)); // Rotate around Y axis
      rotateZ(frameCount * ringRotationSpeed[2] * (1 + amplitude)); // Rotate around Z axis
    }

    // Draw rings if enabled
    if (showRingsAndAxes || showRingsOnly) {
      pushMatrix();
      stroke(255, 150 + amplitude * 100);
      shape(ringShape);
      popMatrix();
    }

    if (!showRingsOnly) {
      if (togglePlanetAppearance) {
        // New appearance: color variation based on amplitude
        float hue = map(amplitude, 0, 0.3, 0, 255); // Map amplitude to hue
        int planetColor = colorFromAmplitude(hue);
        noStroke();
        fill(planetColor, 200);
        sphereDetail(40);
        float pulseSize = planetSize * (1 + amplitude * 0.3);
        sphere(pulseSize);
      } else {
        // Original appearance
        noStroke();
        float detail = 80;

        for (float lat = -HALF_PI; lat < HALF_PI; lat += PI / detail) {
          beginShape(TRIANGLE_STRIP);
          for (float lon = 0; lon <= TWO_PI + PI / detail; lon += PI / detail) {
            for (int i = 0; i < 2; i++) {
              float currentLat = lat + (i * PI / detail);
              float r = planetSize / 2;

              float noiseValue = noise(currentLat * 5, lon * 5); 
              float craterDepth = noise(currentLat * 10, lon * 10);

              float red = map(noiseValue, 0, 1, 180, 255);
              float green = map(noiseValue, 0, 1, 60, 140);
              float blue = map(noiseValue, 0, 1, 30, 80);

              if (craterDepth > 0.6) {
                red *= 0.7;
                green *= 0.7;
                blue *= 0.7;
              }

              fill(red, green, blue);

              float z = sin(currentLat) * r;
              float xy = cos(currentLat) * r;
              float vx = cos(lon) * xy;
              float vy = sin(lon) * xy;

              vertex(vx, vy, z);
            }
          }
          endShape();
        }
      }
    }

    popMatrix();
  }

  // Function to create a ring shape
  PShape createRing(float innerRadius, float outerRadius, int detail) {
    PShape ring = createShape();
    ring.beginShape(QUAD_STRIP);
    ring.noFill();
    ring.stroke(255, 150); // Semi-transparent ring color

    // Create the ring as a series of quads
    for (int i = 0; i <= detail; i++) {
      float theta = map(i, 0, detail, 0, TWO_PI);
      float cosTheta = cos(theta);
      float sinTheta = sin(theta);

      float xOuter = cosTheta * outerRadius;
      float yOuter = sinTheta * outerRadius;
      float xInner = cosTheta * innerRadius;
      float yInner = sinTheta * innerRadius;

      ring.vertex(xOuter, yOuter, 0);
      ring.vertex(xInner, yInner, 0);
    }
    
    ring.endShape(CLOSE);
    return ring;
  }
}

// OrbitingPlanet class from second code, adjusted rings
class OrbitingPlanet {
  float orbitRadius;
  float planetSize;
  float angle;
  float speed;
  PShape ringShape;

  OrbitingPlanet(float orbitRadius, float size) {
    this.orbitRadius = orbitRadius;
    this.planetSize = size;
    angle = random(TWO_PI);
    speed = random(0.01, 0.03); // Random orbit speed

    // Adjust ring sizes based on orbitRadius and planetSize to avoid overlap with orbit path
    float maxRingRadius = orbitRadius - planetSize / 2 - 10; // Ensure ring does not touch orbit path, with some space
    float ringOuterRadius = planetSize * 1.5;
    if (planetSize / 2 + ringOuterRadius > maxRingRadius) {
      ringOuterRadius = maxRingRadius - planetSize / 2;
    }
    float ringInnerRadius = ringOuterRadius * 0.8;
    ringShape = createRing(ringInnerRadius, ringOuterRadius, 60); // Adjusted ring sizes
  }

  void update() {
    angle += speed; // Update orbit angle
  }

  void display(float amplitude) {
    pushMatrix();
    // Orbit around center of the screen
    float x = cos(angle) * orbitRadius; // Orbit x position
    float y = sin(angle) * orbitRadius; // Orbit y position
    translate(x, y);
    
    // Apply color variation based on amplitude
    float hue = map(amplitude, 0, 0.3, 0, 255); // Map amplitude to hue (red to blue to purple)
    int planetColor = colorFromAmplitude(hue);
    
    // Set fill color for the planet
    noStroke();
    fill(planetColor, 200); // Use the calculated color with transparency

    // Draw the planet as a 3D sphere
    sphereDetail(40); // Higher sphere detail level for smoothness
    sphere(planetSize * (1 + amplitude * 0.3)); // Vary size based on amplitude

    // Draw rings with variations
    drawRings(amplitude);

    popMatrix();
  }

  // Function to draw rings with rotation
  void drawRings(float amplitude) {
    pushMatrix();
    rotateX(frameCount * ringRotationSpeed[0] * (1 + amplitude)); // Rotate around X axis
    rotateY(frameCount * ringRotationSpeed[1] * (1 + amplitude)); // Rotate around Y axis
    rotateZ(frameCount * ringRotationSpeed[2] * (1 + amplitude)); // Rotate around Z axis
    stroke(255, 150 + amplitude * 100); // Vary ring transparency based on amplitude
    shape(ringShape); // Draw ring shape
    popMatrix();
  }

  // Function to create a ring shape
  PShape createRing(float innerRadius, float outerRadius, int detail) {
    PShape ring = createShape();
    ring.beginShape(QUAD_STRIP);
    ring.noFill();
    ring.stroke(255, 150); // Semi-transparent ring color

    // Create the ring as a series of quads
    for (int i = 0; i <= detail; i++) {
      float theta = map(i, 0, detail, 0, TWO_PI);
      float cosTheta = cos(theta);
      float sinTheta = sin(theta);

      float xOuter = cosTheta * outerRadius;
      float yOuter = sinTheta * outerRadius;
      float xInner = cosTheta * innerRadius;
      float yInner = sinTheta * innerRadius;

      ring.vertex(xOuter, yOuter, 0);
      ring.vertex(xInner, yInner, 0);
    }
    
    ring.endShape(CLOSE);
    return ring;
  }

  // Generate color based on amplitude mapped to hue
  int colorFromAmplitude(float hueValue) {
    colorMode(HSB, 255); // Set color mode to HSB
    int col = color(hueValue, 200, 255); // Opaque color
    colorMode(RGB, 255); // Reset to RGB for other uses
    return col;
  }
}

// BackgroundStar class
class BackgroundStar {
  PVector position;
  float brightness;
  float flickerSpeed;

  BackgroundStar() {
    position = new PVector(random(-width, width), random(-height, height), random(-500, 500));
    brightness = random(100, 255);
    flickerSpeed = random(0.01, 0.05);
  }
  
  void update() {
    brightness += sin(frameCount * flickerSpeed) * 5;
    brightness = constrain(brightness, 100, 255);
  }
  
  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    noStroke();
    fill(255, brightness);
    ellipse(0, 0, 2, 2);
    popMatrix();
  }
}

// FlickerStar class
class FlickerStar {
  PVector position;
  float brightness;
  float twinkleSpeed;
  float size;
  boolean isRed;

  FlickerStar(boolean isRed) {
    position = new PVector(random(-width, width), random(-height, height), random(-1000, 1000));
    brightness = isRed ? random(50, 180) : random(100, 255);
    twinkleSpeed = random(0.005, 0.02);
    size = isRed ? random(1, 2) : random(1, 3); // Smaller size for red stars
    this.isRed = isRed;
  }
  
  void update(float amplitude) {
    // Flickering effect based on audio amplitude
    brightness += sin(frameCount * twinkleSpeed) * amplitude * 100;
    brightness = constrain(brightness, 30, 255);
  }
  
  void display() {
    noStroke();
    fill(isRed ? color(255, 0, 0, brightness) : color(255, brightness));
    pushMatrix();
    translate(position.x, position.y, position.z);
    ellipse(0, 0, size, size);
    popMatrix();
  }
}

// NebulaParticle class
class NebulaParticle {
  PVector position, velocity;
  float size;
  color c;
  float zSpeed;

  NebulaParticle() {
    position = new PVector(random(-width, width), random(-height, height), random(-500, 500));
    velocity = PVector.random3D().mult(0.5);
    size = random(1, 3);
    c = lerpColor(color(100, 50, 150, 50), color(255, 100, 50, 200), random(1));
    zSpeed = random(-0.5, 0.5);
  }

  void update() {
    position.add(velocity);
    position.z += zSpeed;
    if (position.x > width || position.x < -width || position.y > height || position.y < -height || position.z > 500 || position.z < -500) {
      position = new PVector(random(-width, width), random(-height, height), random(-500, 500));
    }
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    noStroke();
    fill(c);
    ellipse(0, 0, size, size);
    popMatrix();
  }
}

// ShootingStar class
class ShootingStar {
  PVector position, speed;
  float size;
  color c;

  ShootingStar() {
    reset();
  }

  void reset() {
    position = new PVector(random(-width, width), random(-height, height), random(-500, 500));
    speed = new PVector(random(10, 30), random(10, 30), random(-5, 5));
    size = random(2, 5);
    c = color(255, 50, 50, random(150, 255)); 
  }

  void update() {
    position.add(speed);
    if (position.x > width || position.y > height || position.z > 500 || position.z < -500) reset();
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    noStroke();
    fill(c);
    ellipse(0, 0, size, size);
    popMatrix();
  }
}

// GalaxyParticle class
class GalaxyParticle {
  PVector position;
  float angle;
  float radius;
  float speed;
  float size;
  float alpha;
  color starColor;
  float twinkleSpeed;

  GalaxyParticle(float x, float y) {
    position = new PVector(x, y);
    angle = random(TWO_PI);
    radius = random(5, 100);
    speed = random(0.01, 0.05);
    starColor = color(random(200, 255), random(200, 255), random(200, 255), random(100, 255));
    twinkleSpeed = random(0.05, 0.3);
    size = random(1.5, 3);
    alpha = 255;
  }

  void update() {
    angle += speed;
    radius += 0.1;
    position.x = width / 2 + cos(angle) * radius;
    position.y = height / 2 + sin(angle) * radius;
    alpha = 255 * noise(frameCount * twinkleSpeed);
  }

  void display() {
    noStroke();
    for (int i = 4; i > 0; i--) {
      fill(red(starColor), green(starColor), blue(starColor), alpha / (i * 0.9));
      ellipse(position.x, position.y, size * i, size * i);
    }
    fill(red(starColor), green(starColor), blue(starColor), alpha);
    ellipse(position.x, position.y, size, size);
  }

  boolean isOffScreen() {
    return radius > width / 2;
  }
}

// FlowParticle class
class FlowParticle {
  PVector position;
  PVector velocity;
  float size;
  color c;
  float lifespan;

  FlowParticle() {
    position = new PVector(random(-width, width), random(-height, height));
    velocity = PVector.random2D().mult(random(0.5, 2));
    size = random(1, 2); 
    c = color(255, 0, 0, 150);
    lifespan = 255;
  }

  void update() {
    position.add(velocity);
    lifespan -= 2;
    if (lifespan < 0) {
      reset();
    }
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);
    noStroke();
    fill(red(c), green(c), blue(c), lifespan);
    ellipse(0, 0, size, size);
    popMatrix();
  }

  void reset() {
    position = new PVector(random(-width / 2, width / 2), random(-height / 2, height / 2));
    velocity = PVector.random2D().mult(random(0.5, 2));
    lifespan = 255;
  }
}

// FlowKaleidoscopeParticle class
class FlowKaleidoscopeParticle {
  PVector position;
  PVector velocity;
  float size;
  color c;
  float angleOffset;
  float opacity;

  FlowKaleidoscopeParticle() {
    reset();
    size = random(1, 3);
    angleOffset = random(TWO_PI);
    opacity = 70;
  }

  void update() {
    position.add(velocity);
    
    if (position.mag() > width / 2) {
      reset();
    }
  }

  void display() {
    for (int i = 0; i < 8; i++) {
      pushMatrix();
      rotate(i * PI / 4); 
      fill(red(c), green(c), blue(c), opacity);
      ellipse(position.x, position.y, size, size);
      popMatrix();
    }
  }

  void reset() {
    position = new PVector(random(-width / 2, width / 2), random(-height / 2, height / 2));
    velocity = PVector.random2D().mult(random(0.1, 0.5)); 
    setColorBasedOnPhase();
    opacity = 70;
  }

  void adjustOpacity(float t) {
    opacity = map(t, 0, 1, 20, 70);
  }

  void setColorBasedOnPhase() {
    float phase = (frameCount % phaseDurationFlow) / float(phaseDurationFlow);
    if (phase < 0.33) {
      c = color(random(150, 200), random(150, 200), random(255), 100);
    } else if (phase < 0.66) {
      c = color(random(255), random(100, 150), random(100, 150), 100);
    } else {
      c = color(random(80, 130), random(80, 130), random(150, 200), 100);
    }
  }
}

// KaleidoParticle class
class KaleidoParticle {
  float x, y;
  float speedX, speedY;
  float size;
  int particleColor;

  KaleidoParticle(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
    speedX = random(-1, 1);
    speedY = random(-1, 1);
  }
  
  void update(float amplitude) {
    // Move particles
    x += speedX;
    y += speedY;

    // Size and color change based on amplitude
    size = 2 + amplitude * 5;
    particleColor = color(map(amplitude, 0, 0.3, 0, 255), random(50, 150), random(150, 255));
    
    // Bound particles within a certain radius to keep them around the center
    float maxRadius = width / 2;
    if (dist(0, 0, x, y) > maxRadius) {
      x = random(-maxRadius / 2, maxRadius / 2);
      y = random(-maxRadius / 2, maxRadius / 2);
    }
  }
  
  void display(float amplitude) {
    noStroke();
    fill(particleColor, 200); // Use calculated color with transparency
    ellipse(x, y, size, size);
  }
}

// RingParticle class
class RingParticle {
  PVector position;
  PVector velocity;
  float brightness;
  float size;

  RingParticle() {
    float angle = random(TWO_PI);
    float radius = 350;
    position = new PVector(cos(angle) * radius, sin(angle) * radius, random(-50, 50));
    velocity = PVector.random2D().mult(0.5); 
    brightness = random(150, 255);
    size = random(1, 3);
  }

  RingParticle(float x, float y, float z) {
    position = new PVector(x, y, z);
    velocity = PVector.random3D().mult(random(2, 5));
    brightness = random(200, 255); 
    size = random(2, 5); 
  }

  void update() {
    position.add(velocity);

    if (exploded) {
      brightness -= 2;
      brightness = max(brightness, 0);
    }
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    noStroke();
    fill(255, 0, 0, brightness); 
    ellipse(0, 0, size, size);
    popMatrix();
  }
}

// Stop audio properly when the sketch is closed
void stop() {
  song.close();
  minim.stop();
  super.stop();
}

