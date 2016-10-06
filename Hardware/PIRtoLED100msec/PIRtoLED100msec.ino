// This sketch can be used establish the degree of movement required to activate the PIR sensor
// and would also be useful in checking that no cross-talk exists between cages. 

// The first section is for commands that are provided once at the point where the board is turned on, or reset.
const int ledpin = 13;  // change if connecting LED to a 
const int PIRpin = 2;
int PIRstate = 0;

void setup() {
  pinMode(PIRpin, INPUT);     //  define PIR as input
  pinMode(ledpin, OUTPUT);    //  and LED as an  output
}

// This next section is the one that runs in a loop constantly,taking a reading every 100 milliseconds and acting on it

void loop(){
 
 PIRstate = digitalRead(PIRpin);
 if (PIRstate == HIGH) {     
       
    digitalWrite(ledpin, HIGH);  // if PIR is active, turn LED on: 
  } 
  else {
    digitalWrite(ledpin, LOW); // otherwise turn LED off:
  }
  delay(100);  // delay for 100msec
}

