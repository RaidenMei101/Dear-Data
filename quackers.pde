void setup() {

  size(500,500);

  noStroke();
  background(#05ccff); 
  fill(0,150,0);
  rect(0,250,500,250);
  duck();
}

  void duck() {
  translate(35, 0);
  fill(#ff9c05);
  arc(55,140,100,75,HALF_PI,TWO_PI,PIE);

  fill(#ff9c05);
  rect(140,300,60,150);
  fill(#ff9c05);
  rect(300,300,60,150);

  fill(#FFEE05);

  circle(150,150,200);
  ellipse(250,260,350,250);

  fill(0);
  circle(115,130,15);

  fill(#ff9c05);
  rect(50,400,150,60);

  fill(#ff9c05);
  rect(210,400,150,60);
}

void draw(){
}
