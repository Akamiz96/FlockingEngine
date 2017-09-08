public class GraphicalEngine {
  public float boidSize;
  public float boxSize;
  public color boidColor;

  public GraphicalEngine() {
    this.boidSize = 2;
    this.boxSize = 0;
  }

  public GraphicalEngine(float boxSize) {
    this.boidSize = 5;
    this.boxSize = boxSize;
  }

  public GraphicalEngine(float boidSize, float boxSize) {
    this.boidSize = 5;
    this.boxSize = boxSize;
  }

  public void plotBox() {
    noFill();
    stroke(255);
    box(boxSize);
  }
  public void plotBoid(Boid b, color col) {
    fill(col);
    noStroke();
    pushMatrix();
    translate(b.p.x, b.p.y, b.p.z);
    box(boidSize);
    popMatrix();
  }
  public void plotFlock(Boid[] bs) {
    for (int i=0; i<bs.length; i++) {
      if (bs[i].miopia && bs[i].obesidad)
        plotBoid(bs[i], color(255, 0, 0));
      else
      {
        if (bs[i].miopia)
          plotBoid(bs[i], color(0, 255, 0));
        else
        {
          if (bs[i].obesidad)
            plotBoid(bs[i], color(0, 0, 255));
          else
            plotBoid(bs[i], color(255, 255, 255));
          }
        }
      }
    }
  }  