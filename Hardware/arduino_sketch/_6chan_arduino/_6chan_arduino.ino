//This sketch provides an example of a simple system of 6 digital inputs for PIRs and 1 channel for envirnomental light.
//This data is sent every 10seconds across a serial (USB) connection, as a comma-separated string of values.
// The sketch is written longhand, in an attempt to improve clarity.  Use of arrays for values and counters to improve brevity and flexibility:
// http://arduino.cc/en/Reference/For  for details on arrays  and
// http://arduino.cc/en/Reference/While  for other timing options



String ID = "D";  // data header
int LDRPin = A2;
int PIR1 = 2;
int PIR2 = 3;
int PIR3 = 5;
int PIR4 = 6;
int PIR5 = 7;
int PIR6 = 8;

int PIRCounter1 = 0;  //acitivty counter for PIR1
int PIRCounter2 = 0;  //acitivty counter for PIR2
int PIRCounter3 = 0;  //acitivty counter for PIR3
int PIRCounter4 = 0;  //acitivty counter for PIR4
int PIRCounter5 = 0;  //acitivty counter for PIR5
int PIRCounter6 = 0;  //acitivty counter for PIR6
int LoopCounter = 0; //loopcounter for activity


void setup() {

  Serial.begin(57600);
  // give time for startup
  delay(5000);
  // provide data labels for serial monitor on the computer, separated by commas. commented out as this is better included in Processing sketch
  //Serial.println("Time,ID,PIR1,PIR2,PIR3,PIR4,PIR5,PIR6,LDR");
}

// This next section is the one that runs in a loop constantly, taking readings every tenth of a second
void loop() {

  // read all the input pins:
  int PIRState1 = digitalRead(PIR1);
  int PIRState2 = digitalRead(PIR2);
  int PIRState3 = digitalRead(PIR3);
  int PIRState4 = digitalRead(PIR4);
  int PIRState5 = digitalRead(PIR5);
  int PIRState6 = digitalRead(PIR6);
  if (LoopCounter < 100) { // measurements will keep looping until 10 sec is up (100 x 100 msec)
    // if the state is high, increment the relevent PIRcounter
    if (PIRState1 == HIGH) {
      // e.g. if the current state of PIR1 is HIGH then add 1 to the PIR1 counter:
      PIRCounter1++;
    }
    if (PIRState2 == HIGH) {
      PIRCounter2++;
    }
    if (PIRState3 == HIGH) {
      PIRCounter3++;
    }
    if (PIRState4 == HIGH) {
      PIRCounter4++;
    }
    if (PIRState5 == HIGH) {
      PIRCounter5++;
    }
    if (PIRState6 == HIGH) {
      PIRCounter6++;
    }
    delay(100);  // wait 100msec before polling inputs again.  This timing can be varied to ensure consistent 10sec updates.
    LoopCounter++;
  }
  else {

    //send HEADER indicating data follows
    Serial.print(ID);
    // separate with a comma
    Serial.print(",");
    // send total activity for PIR counters, separated by commas
    Serial.print(PIRCounter1);
    Serial.print(",");
    Serial.print(PIRCounter2);
    Serial.print(",");
    Serial.print(PIRCounter3);
    Serial.print(",");
    Serial.print(PIRCounter4);
    Serial.print(",");
    Serial.print(PIRCounter5);
    Serial.print(",");
    Serial.print(PIRCounter6);
    Serial.print(",");
    // read Light-dependant resistor (LDR) connected to analog pin 2 and send resulting number
    Serial.print(analogRead(2));
    Serial.print(",");
    Serial.print('\n'); // new line (linefeed) character
    LoopCounter = 0; // reset your loops
    PIRCounter1 = 0; // and your individual counters
    PIRCounter2 = 0;
    PIRCounter3 = 0;
    PIRCounter4 = 0;
    PIRCounter5 = 0;
    PIRCounter6 = 0;
  }
}
