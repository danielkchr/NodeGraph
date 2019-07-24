/*
  Daniel Kucherenko
  Assigment 2
  25/08/2017
*/

final int MAX = 10000;       //max number of circles
final float DIA = 20;        //diameter of the circle
final int DASH_SIZE = 10;  //length of one dash

float[] x = new float[MAX]; //stores x coordinate of vertices
float[] y = new float[MAX]; //stores y coordinate of vertices
color[] c = new color[MAX]; //stores colour of vertices

int n = 0;       //number of circles added so far
int locked = -1; //index of clicked item, -1 otherwise
float timer = 0; //timer for double click
float maxD = 0;  //maximum distance
float minD = 0;  //minimum distance

void setup() {
  size(400, 400);
  background(255);
}

void draw() {
  background(255); //clear background
  drawGraph();     //draw lines
  noStroke();      //remove stroke for circles
  
  //draw circles
  for (int current = 0; current < n; current++) {
    fill(c[current]);                            //set the color from array
    ellipse(x[current], y[current], DIA, DIA);   //draw ellipse with coordinates from the arrays
  }
}

/*
 Part of TASK A
 draw the graph, connecting every generated vertex to every other vertex
 */
void drawGraph() {
  for (int i = 0; i < n; i++) {
    for (int k = i + 1; k < n; k++) {
       calcDist();                                       //calculates max and min distance
       strokeWeight(setWeight(x[i], y[i], x[k], y[k]));  //sets stroke weight from fucntion setWeight and coordinates of two circles
       //if smallest then draw dashed line with red color, otherwise normal line
       if (dist(x[i], y[i], x[k], y[k]) == minD) { 
         stroke(255, 0, 0);
         dashedLine(x[i], y[i], x[k], y[k]);
       } else {
         stroke(150);
         line(x[i], y[i], x[k], y[k]);
       }
    }
  }
}

void calcDist() {
  minD = dist(x[0], y[0], x[n - 1], y[n - 1]); //sets min to distance between first and last circle
  for (int i = 0; i < n; i++) {
    for (int k = i + 1; k < n; k++) {
      float d = dist(x[i], y[i], x[k], y[k]);
       if (d > maxD) {
         maxD = d; //if current larger then max, change max to current
       }
       
       if (d < minD) {
         minD = d; //if current smaller then min, change min to current
       }
    }
  }
}

/*
 mouseClicked procedure:
 
 Part of TASK A
 store the location where mouse is clicked
 (and thereby a vertex is to be generated) in 
 x[n] and y[n], and the color (based on index)
 in c[n] and increase the value of n, since 
 another vertex has been added.
 
 Part of TASK D
 in the HD version, you will need to simulate a 
 double-click. concept - if the user clicks
 in the same vertex within quarter of a second (250 milliseconds)
 that vertex should be removed from the graph.
 */
void mouseClicked() {
  //if not clicked on circle, make new
  if (isOver(mouseX, mouseY) == -1) {
    //check is still less then max number of circles
    if (n < MAX) {
      x[n] = mouseX;
      y[n] = mouseY;
      c[n] = getColor(n);
      n++;
    }
  } else {
    //if previous click was made less than quarter of second ago and clicked on circle, remove this circle
    if (millis() - timer <= 250) {
      int index = isOver(mouseX, mouseY);
      //move all element of the array, when remove
      for (int i = index; i < n - 1; i++) {
        x[i] = x[i + 1];
        y[i] = y[i + 1];
        c[i] = c[i + 1];
      }
      n--;
    }
  }
  timer = millis(); //always set timer to current time, when clicked
}

/*
 Part of Task B
 write a function weight that is used to compute weight 
 for a line to be drawn between two points (x1, y1) and (x2, y2). 
 
 let distance between the two points be d.
 let distance between the furthest possible points be maxD.
 formula is to return the lower of 5 and maxD/d
 FUNCTION HEADER TO BE WRITTEN BY STUDENTS
 */
 int setWeight(float x1, float y1, float x2, float y2) {
   float d = dist(x1, y1, x2, y2);
   if (5 < maxD/d) {
     return 5;
   }
   return int(maxD/d);
 }


//Part of TASK C
void mousePressed() {
  //pick up the vertex in which mouse is pressed
  if (isOver(mouseX, mouseY) != -1) {
    locked = isOver(mouseX, mouseY);
  }
}

//Part of TASK C
void mouseDragged() {
  //drag the "picked up" circle
  if (locked != -1) {
    x[locked] = mouseX;
    y[locked] = mouseY;
  }
}

//Part of TASK C
void mouseReleased() {
  //make the drop
  locked = -1; //-1 is the out of circles
}

/*
Part of TASK A
 write a function that when passed an index idx,
 returns color(255, 0, 0) if idx is divisible by 3
 returns color(0, 255, 0) if idx leaves a remainder of 1 when divided by 3
 returns color(0, 0, 255) if idx leaves a remainder of 2 when divided by 3
 */
color getColor(int idx) {
  if (idx % 3 == 0) { 
    return color(255, 0, 0);
  } else if (idx % 3 == 1) {
    return color(0, 255, 0);
  }
  return color(0, 0, 255);
}

/*
suggested helper function
 Useful for Tasks C, D
 write a function that returns the index of the circle 
 in which mouse is pressed/ clicked, 
 return -1 if mouse pressed is not pressed inside any circle
 FUNCTION HEADER TO BE WRITTEN BY STUDENTS
 */
int isOver(int xpos, int ypos) {
  for (int current = 0; current < n; current++) {
    if (dist(x[current], y[current], xpos, ypos) < DIA) {
      return current;
    }
  }
  return -1;
}

/*
 IMPORTANT: unassessed
 draw a dashed line from (x1, y1) to (x2, y2) with steps dashes.
 FUNCTION HEADER TO BE WRITTEN BY STUDENTS
 */
 void dashedLine(float x1, float y1, float x2, float y2) {
   int n = int(dist(x1, y1, x2, y2))/DASH_SIZE;
   float dx = (x2 - x1)/n;
   float dy = (y2 - y1)/n;
   for (int i = 0; i < n - 1; i++) {
     //draw only even preiods
     if (i % 2 == 0) {
       line(round(x1 + dx * i), round(y1 + dy * i), round(x1 + dx * (i + 1)), round(y1 + dy * (i + 1)));
     }
   }
 }