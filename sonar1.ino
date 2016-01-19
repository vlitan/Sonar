#include <NewPing.h>
#include <Servo.h>

#define TRIGGER_PIN   10
#define ECHO_PIN      11
#define SERVO_PIN     9

#define MAX_DISTANCE 100

#ifdef SERVO_PIN
Servo   servo;
#endif
NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE);
 
void setup() {
  Serial.begin(9600);
  #ifdef SERVO_PIN
  servo.attach(SERVO_PIN);
  servo.write(90);
  #endif
}

void loop() {
  delay(6);
  //write value
  Serial.write(sonar.ping_cm());
  #ifdef SERVO_PIN
  if (Serial.available() > 0)
  {
    //read angle
    servo.write(Serial.read());
    Serial.flush();
  }
  #endif
}
