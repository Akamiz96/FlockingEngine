public class FlockingEngine {
  public int numBoids;
  public Boid[] boids;
  //--------------------------------------------------------------------------------
  public float visionRange;
  //--------------------------------------------------------------------------------
  public float coh_Weight;
  public float sep_Weight;
  public float ali_Weight;
  public FlockingEngine() {
    this.boids = null;
    this.numBoids = 0;
    this.visionRange = 0;
  }

  public FlockingEngine(int numBoids) {
    this.numBoids = numBoids;
    this.boids = new Boid[numBoids];
    this.visionRange = 0;
  }
  public FlockingEngine(int numBoids, float visionRange) {
    this.numBoids = numBoids;
    this.boids = new Boid[numBoids];
    this.visionRange = visionRange;
  }

  public void setRandomBoidsInBox(float A) {
    for (int i=0; i<numBoids; i++) {
      PVector p = new PVector((float) random(-A/2, A/2), 
      (float) random(-A/2, A/2), 
      (float) random(-A/2, A/2));
      PVector v = new PVector((float) random(-1, 1), 
      (float) random(-1, 1), 
      (float) random(-1, 1));
      v.normalize();
      boids[i] = new Boid(p, v);
    }
    float obesos = numBoids * 0.15;
    for(int i = 0; i<obesos; i++){
      boids[i].obesidad = true;
    }
    for (int i=0; i<numBoids; i++) {
      if(random(0,100) <= 30){
        boids[i].miopia = true;
      }
    }
  }

  public void setRandomBoidsInSphere(float A) {
    for (int i=0; i<numBoids; i++) {
      float r = (float) random(A*0.1, A);
      float theta = (float) random(0, TWO_PI); 
      float phi = (float) random(0, PI);
      PVector p = new PVector(r*cos(theta)*sin(phi), 
      r*sin(theta)*sin(phi), 
      r*cos(phi));
      PVector v = new PVector((float) random(-1, 1), 
      (float) random(-1, 1), 
      (float) random(-1, 1));
      v.normalize();
      boids[i] = new Boid(p, v);
    }
  }
  public void updateFlock(float dt) {
    for (int i=0; i<numBoids; i++) {
      boids[i].addForce(resultingForce(i),dt);
      boids[i].update(dt);
    }
  } 
  public void setParameters(float aliW,float sepW,float cohW){
    ali_Weight = aliW;
    sep_Weight = sepW;
    coh_Weight = cohW;
  }
  public PVector resultingForce(int i){
   PVector resultingForce = new PVector();
   if(!boids[i].obesidad)
   {
     resultingForce.add(PVector.mult(alignmentForce(i),ali_Weight));
     resultingForce.add(PVector.mult(separationForce(i),sep_Weight));
     resultingForce.add(PVector.mult(cohesionForce(i),coh_Weight));
   }
   else
   {
     resultingForce.add(PVector.mult(alignmentForce(i),(ali_Weight - (ali_Weight * 0.5))));
     resultingForce.add(PVector.mult(separationForce(i),(sep_Weight - (sep_Weight * 0.5))));
     resultingForce.add(PVector.mult(cohesionForce(i),(coh_Weight - (coh_Weight * 0.5))));
   }
   return resultingForce;
  }
  public PVector alignmentForce(int i){
   PVector centroid = new PVector();
   int vecinos = 0;
   float vision = this.visionRange;
   if(boids[i].miopia)
     vision = vision - (vision * 0.3);
   for(int j = 0; j < boids.length; j++) {
     if(j != i) {
       if(PVector.dist(boids[i].v, boids[j].v) < vision) {
         centroid.add(boids[j].v);
         vecinos++;
       }
     }
   }
   centroid.div(vecinos);
   centroid.normalize();
   return centroid;
  }
  public PVector separationForce(int i){
   PVector centroid = new PVector();
   float vision = this.visionRange;
   if(boids[i].miopia)
     vision = vision - (vision * 0.3);
   for(int j = 0; j < boids.length; j++) {
     if(j != i) {
       if(PVector.dist(boids[i].p, boids[j].p) < vision) {
         PVector point = new PVector(boids[j].p.x, boids[j].p.y, boids[j].p.z);
         point.sub(boids[i].p);
         centroid.add(point);
       }
     }
   }
   centroid.mult(-1);
   centroid.normalize();
   return centroid;
  }
  public PVector cohesionForce(int i){
   PVector centroid = new PVector();
   int vecinos = 0;
   float vision = this.visionRange;
   if(boids[i].miopia)
     vision = vision - (vision * 0.3);
   for(int j = 0; j < boids.length; j++) {
     if(j != i) {
       if(PVector.dist(boids[i].p, boids[j].p) < vision) {
         centroid.add(boids[j].p);
         vecinos++;
       }
     }
   }
   centroid.div(vecinos);
   centroid.normalize();
   return centroid;
  }
  public void boundaryControl(int type, float boxSize) {
    for (int i=0; i<numBoids; i++) {
      switch(type) {
      case 1:
        loopInside(boids[i], boxSize); 
        break;
      case 2:
        takeToPoint(boids[i], new PVector(0, 0, 0), boxSize);
        break;
      default:
        reflectBoid(boids[i], boxSize);
        break;
      };
    }
  }
  public void reflectBoid(Boid b, float boxSize) {
    if (b.p.x > boxSize/2 || b.p.x<-boxSize/2) {
      b.v.x *= -1;
    }
    if (b.p.y > boxSize/2 || b.p.y<-boxSize/2) {
      b.v.y *= -1;
    }
    if (b.p.z > boxSize/2 || b.p.z<-boxSize/2) {
      b.v.z *= -1;
    }
  }
  public void takeToPoint(Boid b, PVector pos, float boxSize) {
    if (max(abs(b.p.x), abs(b.p.y), abs(b.p.z))>boxSize/2) {
      b.p = pos;
    }
  }
  public void loopInside(Boid b, float boxSize) {
    if (b.p.x > boxSize/2 || b.p.x<-boxSize/2) {
      b.p.x *= -1;
    }
    if (b.p.y > boxSize/2 || b.p.y<-boxSize/2) {
      b.p.y *= -1;
    }
    if (b.p.z > boxSize/2 || b.p.z<-boxSize/2) {
      b.p.z *= -1;
    }
  }
}