String[] lines;

float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;

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

int numtype = 3;

String[] type;
float[] petalLength;
float[] irisMean = new float[3];
float[] irisMedian = new float[3];

PFont plotFont;

float barWidth = 75;

void setup() {
  size(720, 405);
  
  lines = loadStrings("iris.data.txt");
  
  type = new String[lines.length];
  petalLength = new float[lines.length];
  
  for(int row = 0; row < lines.length; row++)
    {
      String[] pieces = split(lines[row], TAB);
      petalLength[row] = float(pieces[2]);
      type[row] = pieces[4];
      //println(petalLength[row]);
      
      if(petalLength[row] > dataMax)
        {
          dataMax = petalLength[row];
        }
      /*if(petalLength[row] < dataMin)
        {
          dataMin = petalLength[row];
        }*/ 
      rowCount = row;  
    }
  
  dataMin = 0;
  dataMax = ceil(dataMax); 
    
  findMean();    //find the mean of the dataset 
  findMedian();  //find the median of the dataset

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
  drawLengthLabels();

  noStroke();
  fill(#5679C1);
  drawDataBars();
  
  drawTypeLabels();
  drawLegend();
}

void findMean() {
  float sumS = 0;
  float sumVC = 0;
  float sumVG = 0;
  int numS = 0;
  int numVC = 0;
  int numVG = 0;
  
  for(int row = 0; row < rowCount; row ++)
  {
    if(type[row].equals("Iris-setosa")==true) {
      sumS += petalLength[row];
      numS += 1;
    } else if(type[row].equals("Iris-versicolor")==true) {
      sumVC += petalLength[row];
      numVC += 1;
    } else {
      sumVG += petalLength[row];
      numVG += 1;
    }
  }
  numSetosa = numS;
  numVersicolor = numVC;
  numVirginica = numVG;
  
  irisMean[0] = sumS/numS;
  irisMean[1] = sumVC/numVC;
  irisMean[2] = sumVG/numVG;
}

void findMedian() {
  float[] orderS = new float[numSetosa];
  float[] orderVC = new float[numVersicolor];
  float[] orderVG = new float[numVirginica];
  int numS = 0;
  int numVC = 0;
  int numVG = 0;
  
  for(int row = 0; row < rowCount; row ++)
  {
    if(type[row].equals("Iris-setosa")==true) {
      orderS[numS] = petalLength[row];
      numS += 1;
    } else if(type[row].equals("Iris-versicolor")==true) {
      orderVC[numVC] = petalLength[row];
      numVC += 1;
    } else {
      orderVG[numVG] = petalLength[row];
      numVG += 1;
    }
  }
  
  orderS = sort(orderS);
  orderVC = sort(orderVC);
  orderVG = sort(orderVG);
  
  if((numS-1) % 2 == 0)  //odd number of type
  {
    irisMedian[0] = orderS[(numS-1)/2];
  }else {
    irisMedian[0] = (orderS[(numS/2)] + orderS[(numS/2)-1])/2;
  }
  
  if((numVC-1) % 2 == 0)  //odd number of type
  {
    irisMedian[1] = orderVC[(numVC-1)/2];
  }else {
    irisMedian[1] = (orderVC[(numVC/2)] + orderVC[(numVC/2)-1])/2;
  }
  
  if((numVG-1) % 2 == 0)  //odd number of type
  {
    irisMedian[2] = orderVG[(numVG-1)/2];
  }else {
    irisMedian[2] = (orderVG[(numVG/2)] + orderVG[(numVG/2)-1])/2;
  }

}

void drawTitle() {
  fill(0);
  textSize(20);
  textAlign(CENTER);
  String title = "Iris Petal Length";
  text(title, plotX1 + (plotW/2), plotY1 - 10);
}

void drawAxisLabels() {
  fill(0);
  textSize(13);
  textLeading(15);
  
  textAlign(CENTER, CENTER);
  text("Petal\n Length (cm)", labelX, (plotY1+plotY2)/2);
  textAlign(CENTER);
  text("Iris type", (plotX1+plotX2)/2, labelY);
}

void drawTypeLabels() {
  fill(0);
  textSize(10);
  textAlign(CENTER);
  
  // Use thin, gray lines to draw the grid
  stroke(255);
  strokeWeight(1);
  
  float x = plotW/4;
  text("Setosa", plotX1 + x, plotY2 + textAscent() + 10);
  text("Versicolor", plotX1 + 2*x, plotY2 + textAscent() + 10);
  text("Virginica", plotX1 + 3*x, plotY2 + textAscent() + 10);    
}

void drawLengthLabels() {
  fill(0);
  textSize(10);
  textAlign(RIGHT);
  
  stroke(128);
  strokeWeight(1);

  for (float v = dataMin; v <= dataMax; v += yIntervalMinor)
  {
    if (v % yIntervalMinor == 0) 
    {     // If a tick mark
      float y = map(v, dataMin, dataMax, plotY2, plotY1);  
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

void drawDataBars() {
  noStroke();
  rectMode(CORNERS);
  
  float x = plotW/4;
  for (int j = 0; j < 3; j++)
  {
      float value = irisMean[j];
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      rect((plotX1 + (j+1)*x)-barWidth/2, y,(plotX1 + (j+1)*x), plotY2);
  }
  
  fill(192,0,0);
  for (int j = 0; j < 3; j++)
  {
      float value = irisMedian[j];
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      rect((plotX1 + (j+1)*x), y,(plotX1 + (j+1)*x)+barWidth/2, plotY2);
  }
} 

void drawLegend() {
  noStroke();
  rectMode(CORNERS);
  
  textAlign(LEFT,CENTER);
  
  fill(#5679C1);
  rect(plotX2 + 10,plotY1 + 50, plotX2 + 15, plotY1 + 55);
  fill(192,0,0);
  rect(plotX2 + 10,plotY1 + 65, plotX2 + 15, plotY1 + 70);
  
  fill(0);
  float textOffset = textAscent()/2;
  text("Mean", plotX2 + 17, plotY1 + 52.5);
  text("Median", plotX2 + 17, plotY1 + 67.5);
   
}

