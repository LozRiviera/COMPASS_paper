// Processing Sketch for eLife
/*
* Receiving a simple string of values from the arduino and saving to a text file with a UTC (iso8601) encoding
* Light data are mapped to a background and the activity of each channel displayed as histograms.
* Press 'x' to stop logging and save file
*/
import processing.serial.*;
import java.util.Date;
import java.text.SimpleDateFormat;
PFont font1; //allows for printing text
PFont font2; //allows for printing text
PrintWriter output;
SimpleDateFormat fnameFormat= new SimpleDateFormat("yyMMdd_HHmm"); // define date and time formatfor filename
SimpleDateFormat timeFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"); // and for timestamps of incomming data
String fileName;

Serial myPort; // Create objects from Serial class
short portIndex= 1; // select the com port, 0 is the first port (Macs normally use 0, windows machines 1, or highest)
String dataIn = null;
String HEADER = "D"; //Data HEADER
short LF = 10; // ASCII linefeed indicator
color off = color(150,150,150);
color on = color(250, 250, 158);

// for plotting data from the arduino (channels 1 to 6 plus LDR)
int Light = 0;
int PollCount = 0; // counter for plotting hourly activity
int HourCount = 0; // hour counter for plotting daily activity
float LightBar = 0;
float LightBar2 = 0;
float[] ActivBar = new float[7];
float[] ActivBar2 = new float[7];
int HourTotalLight = 0;
float[] HourTotalActivity = new float[7];

void setup()
{
size(1100, 540); // set window size
smooth();
// create some fonts to use in plotting window
font1 = createFont("Arial bold", 32, true);
font2 = createFont("Arial", 48, true);
// Draw backround elements and scalebars
background(255);
fill(150);
for (int i=0; i<6;i++){
  rect(10, 40+(80*i) , 760, 70, 10); // 1hr left-hand rounded rectangle
  line(40, 55+(80*i), 40, 105+(80*i)); // 1hr graphs y axis
  }
for (int i=0; i<6;i++){
  rect(800, 40+(80*i) , 290, 70, 10);// 24hr right-hand rounded rectangle
  line(830, 55+(80*i), 830, 105+(80*i)); // 24hr graphs y axis
  }
for (int i=0; i<6;i++){
  fill(0);
  textAlign(RIGHT);
  text("0", 40, 105+(80*i)); //1hr 0 axis label
  text("100", 40, 55+(80*i)); //1hr 100
  text("0", 830, 105+(80*i)); //24hr 0
  text("100", 830, 55+(80*i)); //24hr 100
  }
textAlign(CENTER);
textFont(font1, 32);
text("last hr activity", 380, 30);
text("24hr activity", 920, 30);
textFont(font2, 16);
text("press x to stop recording and save to file", width/2, height-10);

// check output from list of connections and change portIndex if needed.
println(Serial.list());
String portName = Serial.list()[portIndex]; // Open whatever serial port is connected to the Arduino.
println(Serial.list()); // check output from list of connections and change portIndex if needed.
println(" Connecting to -> " + Serial.list()[portIndex]);
myPort = new Serial(this, portName, 57600);
myPort.bufferUntil(LF);
delay(1);
Date now = new Date();
fileName = fnameFormat.format(now);
output = createWriter(fileName + ".csv"); // save the file in the sketch folder
println("Time \t PIR1 \t PIR2 \t PIR3 \t PIR4 \t PIR5 \t PIR6 \t LDR");
output.println("Time,header,PIR1,PIR2,PIR3,PIR4,PIR5,PIR6,LDR"); // headers to file as comma-delimited
}

void draw()
{}

void serialEvent(Serial myPort) {
dataIn = myPort.readString(); // read data from the port:
String timeString = timeFormat.format(new Date());
println(timeString + "," + dataIn); // tell us who sent what:
output.println(timeString+ "," +dataIn); //save sent message:

String incomingValues[] = dataIn.split(","); // take message and split into and array of values
if(incomingValues[0].equals(HEADER)) // If data header is present and correct, convert light, then pir values into integers
{ int Light = Integer.parseInt(incomingValues[7]);
float LightBar = map(Light, 0, 1024, 0, 255);
fill(LightBar);
stroke(LightBar);
for (int j=1; j<7; j++) {
  fill(LightBar);
  stroke(LightBar);
  rect(41+2*PollCount, 55+(80*(j-1)), 5, 50); // lightlevel for all
  fill (on);
  
  //plot activity as bar with height as activity and colour based on LDR values
  ActivBar[j] = Float.parseFloat(incomingValues[j]);
  rect(41+2*PollCount, 105+(80*(j-1)), 5 ,-(ActivBar[j]/2));
  HourTotalActivity[j] = HourTotalActivity[j] + ActivBar[j];
  }
HourTotalLight = HourTotalLight + Light;
output.flush(); // Writes outstanding data to the file
PollCount ++;
if (PollCount >359){
  float LightBar2 = map(HourTotalLight, 0, (360*1024), 0, 255);
  fill(LightBar2);
  stroke(LightBar2);
  for (int k=1; k<7; k++) {
    fill(LightBar2);
    stroke(LightBar2);
    rect(832 + (9*HourCount), 55+(80*(k-1)), 14 ,50);
    fill (on);
    ActivBar2[k] = map(HourTotalActivity[k], 0, 36000, 0, 50);
    rect(832 + (9*HourCount), 105+(80*(k-1)), 14 ,-ActivBar2[k]);
    HourTotalLight = 0;
    HourTotalActivity[k] =0;
    }
  HourCount ++;
  PollCount = 0;
  }
if (HourCount >23){
  HourCount = 0;
  }
}
}
void keyPressed() {
if (key == 'x' || key == 'X') {
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  exit(); // Stops the program
  }
}
