import com.cketcham.osceleton.*;

import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import controlP5.*;

int NUM_PARTICLES = 40;
int NUM_PEOPLE = 32;

float DRAG = 0.05f;
float ATTRACTION = 0.8f;
float RADIUS = 350;

ControlP5 cp5;

VerletPhysics2D physics;
AttractionBehavior[] attractors = new AttractionBehavior[NUM_PEOPLE * 2];
Vec2D[] hands = new Vec2D[NUM_PEOPLE * 2];

OSCeletonWrapper osceleton;

void setup() {
  size(800, 560, P3D);

  cp5 = new ControlP5(this);

  cp5.addSlider("DRAG")
    .setPosition(10, 500)
      .setRange(0, 0.5f);

  cp5.addSlider("ATTRACTION")
    .setPosition(10, 520)
      .setRange(0.0f, 2.0f);

  cp5.addSlider("RADIUS")
    .setPosition(10, 540)
      .setRange(0.0f, 350.0f);

  osceleton = new OSCeletonWrapper(this, 12345);

  physics = new VerletPhysics2D();
  physics.setDrag(DRAG);
  physics.setWorldBounds(new Rect(0, 0, width, height));
}

float oldAttraction = 0.0f;
float oldDrag = 0.0f;
float oldRadius = 0.0f;

// Sets up attraction to hands
void setupHandGravity(Skeleton sk) {
  // If a parameter changed, we need to remove the old settings
  // so we can set new ones.
  if (oldAttraction != ATTRACTION || oldRadius != RADIUS) {
    oldAttraction = ATTRACTION;
    oldRadius = RADIUS;
    removeHandGravity(sk);
  }

  // If attraction hasn't been setup yet, initialize it
  if (attractors[sk.getUser()] == null) {
    hands[sk.getUser()] = new Vec2D(sk.get("l_hand").x, sk.get("l_hand").y);
    hands[sk.getUser() + NUM_PEOPLE] = new Vec2D(sk.get("r_hand").x, sk.get("r_hand").y);
    attractors[sk.getUser()] = new AttractionBehavior(hands[sk.getUser()], RADIUS, ATTRACTION);
    attractors[sk.getUser() + NUM_PEOPLE] = new AttractionBehavior(hands[sk.getUser() + NUM_PEOPLE], RADIUS, ATTRACTION);
    physics.addBehavior(attractors[sk.getUser()]);
    physics.addBehavior(attractors[sk.getUser() + NUM_PEOPLE]);
  } 
  // Update the attraction coordinates for the particles
  else {
    hands[sk.getUser()].set(sk.get("l_hand").x, sk.get("l_hand").y);
    hands[sk.getUser() + NUM_PEOPLE].set(sk.get("r_hand").x, sk.get("r_hand").y);
  }
}

// Removes attraction to hands
void removeHandGravity(Skeleton sk) {
  if (attractors[sk.getUser()] != null) {
    physics.removeBehavior(attractors[sk.getUser()]);
    physics.removeBehavior(attractors[sk.getUser() + NUM_PEOPLE]);
    attractors[sk.getUser()] = null;
    attractors[sk.getUser() + NUM_PEOPLE] = null;
  }
}

void addParticle() {
  VerletParticle2D p = new VerletParticle2D(Vec2D.randomVector().scale(5).addSelf(width / 2, 0));
  physics.addParticle(p);
  // add a negative attraction force field around the new particle
  physics.addBehavior(new AttractionBehavior(p, 20, -1.2f, 0.01f));
}

void draw() {
  background(192);

  // First draw all the particles
  noStroke();
  physics.setDrag(DRAG);
  if (physics.particles.size() < NUM_PARTICLES) {
    addParticle();
  }
  physics.update();
  for (VerletParticle2D p: physics.particles) {
    fill(76, 150, 130 + random(40, 80), random(100, 120));
    ellipse(p.x, p.y, random(22, 28), random(22, 28));
  }

  fill(255);
  for (Skeleton sk : osceleton.getSkeletons()) {
    if (sk != null) {
      if (sk.isVisible()) {

        // Draw an elipse for each joint
        HashMap < String, Joint > joints = sk.getJointSet();
        for (String name: joints.keySet()) {
          Joint j = joints.get(name);
          fill(255);
          ellipse(j.x, j.y, 15, 15);
        }

        // Setup attraction to hands
        setupHandGravity(sk);
      } 
      else {
        // The skeleton is no longer visible so remove the attraction
        removeHandGravity(sk);
      }
    }
  }
}

