String[] lines;

float sepalDataMin = MAX_FLOAT;
float sepalDataMax = MIN_FLOAT;
float petalDataMin = MAX_FLOAT;
float petalDataMax = MIN_FLOAT;


float plotX1, plotY1;
float plotX2, plotY2;
float labelX, labelY;
float plotW;

int rowCount;
int numSetosa;
int numVersicolor;
int numVirginica;

int yInterval = 1;
float yIntervalMinor = 0.5;

int xInterval = 1;
float xIntervalMinor = 0.5;

int numtype = 3;

String[] type;
float[] sepalLength;
float[] petalLength;

PFont plotFont;


void setup() {
  size(720, 405);
  
  lines = loadStrings("iris.data.txt");
  
  type = new String[lines.length];
  sepalLength = new float[lines.length];
  petalLength = new float[lines.length];
  
  for(int row = 0; row < lines.length; row++)
    {
      String[] pieces = split(lines[row], TAB);
      sepalLength[row] = float(pieces[0]);
      petalLength[row] = float(pieces[2]);
      type[row] = pieces[4];
      
      //println(petalLength[row]);
      
      if(petalLength[row] > petalDataMax)
        {
          petalDataMax = petalLength[row];
        }
        
      if(petalLength[row] < petalDataMin)
        {
          petalDataMin = petalLength[row];
        }
        
      if(sepalLength[row] > sepalDataMax)
        {
          sepalDataMax = sepalLength[row];
        }
        
      if(sepalLength[row] < sepalDataMin)
        {
          sepalDataMin = sepalLength[row];
        }
        
      rowCount = row;  
    }
  
  sepalDataMin = floor(sepalDataMin)-1;
  sepalDataMax = ceil(sepalDataMax)+1;
  petalDataMin = floor(petalDataMin)-1;
  petalDataMax = ceil(petalDataMax)+1;
    

  // Corners of the plotted time series
  plotX1 = 120; 
  plotX2 = width - 80;
  labelX = 50;
  plotY1 = 60;
  plotY2 = height - 70;
  labelY = height - 25;
  
  plotW = plotX2 - plotX1;
  
  plotFont = createFont("SansSerif", 20);
  textFont(plotFont);

  smooth();
}


void draw(){
  background(200);
  
  fill(255);
  rectMode(CORNERS);
  noStroke();
  rect(plotX1,plotY1,plotX2,plotY2);
  
  drawTitle();
  drawAxisLabels();
  drawPetalLengthLabels();

  noStroke();
  fill(#5679C1);
  drawDataBars();
  
  drawSepalLengthLabels();
  drawLegend();
}

void drawTitle() {
  fill(0);
  textSize(18);
  textAlign(CENTER,BOTTOM);
  String title = "Iris Petal Length Vs. Sepal length";
  text(title, plotX1 + (plotW/2), plotY1 - 10);
}

void drawAxisLabels() {
  fill(0);
  textSize(13);
  textLeading(15);
  
  textAlign(CENTER, CENTER);
  text("Petal\n Length (cm)", labelX, (plotY1+plotY2)/2);
  textAlign(CENTER);
  text("Sepal Length", (plotX1+plotX2)/2, labelY);
}

void drawSepalLengthLabels() {
  fill(0);
  textSize(10);
  textAlign(CENTER);
  
  stroke(128);
  strokeWeight(1);
  
  for (float v = sepalDataMin; v <= sepalDataMax; v += xIntervalMinor)
  {
    if (v % xIntervalMinor == 0) 
    {     // If a tick mark
      float x = map(v, sepalDataMin, sepalDataMax, plotX1, plotX2);  
      if (v % xInterval == 0)
      {       
        // If a major tick mark
        text(floor(v), x, plotY2 + textAscent() + 10);
        line(x, plotY2 + 4, x, plotY2);     // Draw major tick
      } 
      else 
      {
        line(x, plotY2 +2, x, plotY2);     // Draw minor tick
      }
    }
  }    
}

void drawPetalLengthLabels() {
  fill(0);
  textSize(10);
  textAlign(RIGHT);
  
  stroke(128);
  strokeWeight(1);

  for (float v = petalDataMin; v <= petalDataMax; v += yIntervalMinor)
  {
    if (v % yIntervalMinor == 0) 
    {     // If a tick mark
      float y = map(v, petalDataMin, petalDataMax, plotY2, plotY1);  
      if (v % yInterval == 0)
      {       
        // If a major tick mark
        float textOffset = textAscent()/2;  // Center vertically
        text(floor(v), plotX1 - 10, y + textOffset);
        line(plotX1 - 4, y, plotX1, y);     // Draw major tick
      } 
      else 
      {
        line(plotX1 - 2, y, plotX1, y);     // Draw minor tick
      }
    }
  }
}

void drawLegend() {
  noStroke();
  rectMode(CORNERS);
  
  textAlign(LEFT,CENTER);
  
  fill(0,0,192);
  rect(plotX2 + 10,plotY1 + 50, plotX2 + 15, plotY1 + 55);
  fill(0,192,0);
  rect(plotX2 + 10,plotY1 + 65, plotX2 + 15, plotY1 + 70);
  fill(192,0,0);
  rect(plotX2 + 10,plotY1 + 80, plotX2 + 15, plotY1 + 85);
  
  fill(0);
  float textOffset = textAscent()/2;
  text("Setosa", plotX2 + 17, plotY1 + 52.5);
  text("Versicolor", plotX2 + 17, plotY1 + 67.5);
  text("Virginica", plotX2 +17, plotY1 + 82.5);
}

void drawDataBars() {
  noStroke();
  
  
  for(int row = 0; row < rowCount; row++)
  {
    float xvalue = sepalLength[row];
    float yvalue = petalLength[row];
    
    float x = map(xvalue, sepalDataMin, sepalDataMax, plotX1, plotX2);
    float y = map(yvalue, petalDataMin, petalDataMax, plotY2, plotY1);
    
    if(type[row].equals("Iris-setosa") == true){
      fill(0,0,192);
    }else if(type[row].equals("Iris-versicolor") == true){
      fill(0,192,0);
    }else {
      fill(192,0,0);
    }
    
    ellipse(x,y,5,5);   
  }  
}
