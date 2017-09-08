public class Boid{
 public PVector p;
 public PVector v;
 public float R;
 public boolean miopia;
 public boolean obesidad;
 
 public Boid(){
  this.p = new PVector();
  this.v = new PVector();
  this.R = 0;
  this.miopia = false;
  this.obesidad = false;
 }
 public Boid(PVector p){
  this.p = p;
  this.v = new PVector();
  this.R = 0;
  this.miopia = false;
  this.obesidad = false;
 } 
 public Boid(PVector p, PVector v){
  this.p = p;
  this.v = v;
  this.R = 0;
  this.miopia = false;
  this.obesidad = false;
 }
 public Boid(PVector p, PVector v, float R){
  this.p = p;
  this.v = v;
  this.R = R;
  this.miopia = false;
  this.obesidad = false;
 }
 public void update(float dt){
  p.add(PVector.mult(v,dt));
  v.mult(0.99);
 }
 public void addForce(PVector F, float dt){
  v.add(PVector.mult(F,dt));
 }
} 