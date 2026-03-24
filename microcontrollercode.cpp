#include <Wire.h>
#include <MPU6050.h>

MPU6050 mpu;

// -------- PIN DEFINITIONS --------
#define SOIL_PIN A0
#define VIB_PIN  A1

#define LED_PIN 7
#define BUZZER_PIN 8

// -------- NORMALIZATION SETTINGS --------
// adjust according to your sensor readings
const int M_MIN = 200;     // dry value
const int M_MAX = 800;     // wet value

const float T_MAX = 45.0;  // dangerous tilt angle (degrees)

const int V_MAX = 1023;    // max ADC value

// -------- TIMING --------
unsigned long previousMillis = 0;
bool toggleState = false;

void setup() {
  Serial.begin(9600);   // also used by HC-05

  pinMode(LED_PIN, OUTPUT);
  pinMode(BUZZER_PIN, OUTPUT);

  Wire.begin();
  mpu.initialize();

  Serial.println("System Started...");
}

// ---------- GET TILT ----------
float getTiltAngle() {
  int16_t ax, ay, az;
  mpu.getAcceleration(&ax, &ay, &az);

  float axf = ax / 16384.0;
  float ayf = ay / 16384.0;
  float azf = az / 16384.0;

  float angle = atan2(ayf, azf) * 180.0 / PI;
  return angle;
}

// ---------- NORMALIZE ----------
float normalize(float value, float minVal, float maxVal) {
  float n = (value - minVal) / (maxVal - minVal);
  if (n < 0) n = 0;
  if (n > 1) n = 1;
  return n;
}

void loop() {

  // ===== READ SENSORS =====
  int moistureRaw = analogRead(SOIL_PIN);
  int vibrationRaw = analogRead(VIB_PIN);
  float tilt = getTiltAngle();

  // ===== NORMALIZATION =====
  float Mn = normalize(moistureRaw, M_MIN, M_MAX);
  float Tn = abs(tilt) / T_MAX;
  if (Tn > 1) Tn = 1;

  float Vn = (float)vibrationRaw / V_MAX;
  if (Vn > 1) Vn = 1;

  // ===== RISK EQUATION =====
  float R = 0.40 * Mn +
            0.35 * Tn +
            0.25 * Vn;

  // ===== RISK LEVEL =====
  String riskLevel;

  if (R < 0.3) {
    riskLevel = "LOW";
    digitalWrite(LED_PIN, LOW);
    digitalWrite(BUZZER_PIN, LOW);
  }

  else if (R < 0.6) {
    riskLevel = "MEDIUM";

    // blinking + buzzer toggle
    if (millis() - previousMillis > 500) {
      previousMillis = millis();
      toggleState = !toggleState;
      digitalWrite(LED_PIN, toggleState);
      digitalWrite(BUZZER_PIN, toggleState);
    }
  }

  else {
    riskLevel = "HIGH";

    // continuous alert
    digitalWrite(LED_PIN, HIGH);
    digitalWrite(BUZZER_PIN, HIGH);
  }

  // ===== SERIAL + BLUETOOTH OUTPUT =====
  Serial.print("Moisture: ");
  Serial.print(moistureRaw);
  Serial.print("  Mn=");
  Serial.print(Mn, 2);

  Serial.print(" | Tilt: ");
  Serial.print(tilt, 2);
  Serial.print("  Tn=");
  Serial.print(Tn, 2);

  Serial.print(" | Vibration: ");
  Serial.print(vibrationRaw);
  Serial.print("  Vn=");
  Serial.print(Vn, 2);

  Serial.print(" | Risk=");
  Serial.print(R, 2);

  Serial.print(" | LEVEL: ");
  Serial.println(riskLevel);

  delay(300);
}