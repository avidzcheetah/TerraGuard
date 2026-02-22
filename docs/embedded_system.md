# TerraGuard — Embedded System Documentation

## Microcontroller: ATmega328P (Bare-Metal)

The TerraGuard hardware node runs on the **Atmel ATmega328P** microcontroller — the same silicon used in the Arduino Uno but deployed here in bare-metal DIP-28 form to minimize cost and footprint.

| Parameter | Value |
|-----------|-------|
| Architecture | 8-bit AVR RISC |
| Clock Speed | 16 MHz (external crystal) |
| Flash Memory | 32 KB |
| SRAM | 2 KB |
| EEPROM | 1 KB |
| Supply Voltage | 4.5 – 5.5 V |
| ADC Resolution | 10-bit (0–1023) |
| I²C (TWI) | Hardware, pins A4/A5 |
| UART | Hardware, pins D0/D1 |
| Package | DIP-28 |

---

## Pin Connection Diagram

```
                       ATmega328P (DIP-28)
                       ┌──────────────────┐
               PC6/RST ┤ 1            28 ├ PC5 (A5) ──── MPU6050 SCL
     HC-05 TX → D0/RX  ┤ 2            27 ├ PC4 (A4) ──── MPU6050 SDA
     HC-05 RX ← D1/TX  ┤ 3            26 ├ PC3 (A3)
                    D2  ┤ 4            25 ├ PC2 (A2)
                    D3  ┤ 5            24 ├ PC1 (A1) ──── Shock Sensor A0
                    D4  ┤ 6            23 ├ PC0 (A0) ──── Moisture Sensor A0
                   VCC  ┤ 7    328P    22 ├ GND
                   GND  ┤ 8            21 ├ AREF
              XTAL1/D5  ┤ 9            20 ├ VCC (AVCC)
              XTAL2/D6  ┤ 10           19 ├ PB5 (D13) ─── Status LED
                    D7  ┤ 11           18 ├ PB4 (D12)
                    D8  ┤ 12           17 ├ PB3 (D11)
        Buzzer ← D8/PB0 ┤ 12           16 ├ PB2 (D10)
    Shock D0 → D2/PD2   ┤ 4            15 ├ PB1 (D9)
                        └──────────────────┘
```

---

## Detailed Pin Connections

### Power Rails

| ATmega328P Pin | Pin Name | Connected To |
|----------------|----------|--------------|
| Pin 7          | VCC      | +5V rail     |
| Pin 20         | AVCC     | +5V rail     |
| Pin 8          | GND      | GND rail     |
| Pin 22         | GND      | GND rail     |

> **Note:** AVCC must be connected to the +5V rail (cannot be left floating) for the ADC to function.

---

### Clock — 16 MHz Crystal Oscillator

| Component | Connection |
|-----------|------------|
| Crystal leg 1 | ATmega328P Pin 9 (XTAL1) |
| Crystal leg 2 | ATmega328P Pin 10 (XTAL2) |
| 22 pF capacitor C1 | XTAL1 → GND |
| 22 pF capacitor C2 | XTAL2 → GND |

The crystal + two 22 pF load capacitors form a Pierce oscillator. This drives the internal PLL-free clock at 16 MHz, matching the Arduino Uno fuse settings.

---

### Soil Moisture Sensor (Capacitive / Resistive)

| Sensor Pin | ATmega328P |
|------------|------------|
| VCC | +5V |
| GND | GND |
| A0 (analog out) | Pin 23 → ADC0 (A0) |

**Normalisation formula used in firmware:**
```
M_RAW  = ADC reading (0–1023)
M_MIN  = 200   (dry air value)
M_MAX  = 800   (submerged value)
Mn     = (M_RAW - M_MIN) / (M_MAX - M_MIN)   [clamped 0–1]
```

---

### Shock / Tap Sensor (SW-420 or equivalent)

| Sensor Pin | ATmega328P |
|------------|------------|
| V (VCC) | +5V |
| G (GND) | GND |
| D0 (digital) | Pin 4 → D2 (read as digital) |
| A0 (analog) | Pin 24 → ADC1 (A1) |

**Normalisation formula used in firmware:**
```
V_RAW  = ADC reading on A1 (0–1023)
V_MAX  = 1023
Vn     = V_RAW / V_MAX         [0–1]
```

The digital D0 pin is used as a fast interrupt trigger; the analog A0 pin captures magnitude.

---

### MPU-6050 (3-Axis Gyro + Accelerometer, I²C)

| MPU-6050 Pin | ATmega328P |
|--------------|------------|
| VCC | +5V |
| GND | GND |
| SDA | Pin 27 → A4 (hardware SDA) |
| SCL | Pin 28 → A5 (hardware SCL) |

**I²C address:** `0x68` (AD0 tied LOW)

**Tilt calculation from firmware:**
```
accelX, accelY, accelZ  ← MPU-6050 accelerometer raw
tilt_deg = atan2(accelX, sqrt(accelY² + accelZ²)) × 180/π
T_MAX    = 45.0°
Tn       = abs(tilt_deg) / T_MAX     [clamped 0–1]
```

---

### HC-05 Bluetooth Module (Serial UART)

| HC-05 Pin | ATmega328P |
|-----------|------------|
| VCC | +5V |
| GND | GND |
| TX | Pin 2 → D0 (hardware RX) |
| RX | Pin 3 → D1 (hardware TX) |

**UART Configuration:**
- Baud rate: **9600** bps
- Data bits: 8, Parity: None, Stop bits: 1 (8N1)
- HC-05 paired with the dashboard browser via the **Web Serial API**

> **Important:** The HC-05 RX pin expects 3.3 V logic. A voltage divider (2 kΩ + 3.3 kΩ) between D1 TX and the HC-05 RX pin is recommended to avoid damaging the module.

---

### Status LED

| Component | Connection |
|-----------|------------|
| Anode (+) | Pin 19 → D13 → 220 Ω resistor |
| Cathode (–) | GND |

The LED blinks once per transmission cycle to confirm the firmware is running.

---

### Buzzer (Active)

| Component | Connection |
|-----------|------------|
| (+) | Pin 14 → D8 |
| (–) | GND |

The buzzer sounds a 3-beep alarm pattern when `R ≥ 0.6` (HIGH risk).

---

## Serial Output Format

The firmware transmits one line every **2 seconds** over UART at 9600 baud:

```
Moisture: <raw>  Mn=<0.00> | Tilt: <deg>  Tn=<0.00> | Vibration: <raw>  Vn=<0.00> | Risk=<0.00> | LEVEL: <LOW|MEDIUM|HIGH>
```

**Example:**
```
Moisture: 612  Mn=0.69 | Tilt: 12.34  Tn=0.27 | Vibration: 308  Vn=0.30 | Risk=0.45 | LEVEL: MEDIUM
```

The dashboard's parser uses the following regex to extract values:
```regex
/Moisture:\s*(-?[\d.]+)\s+Mn=([\d.]+)\s*\|\s*Tilt:\s*(-?[\d.]+)\s+Tn=([\d.]+)\s*\|\s*Vibration:\s*(-?[\d.]+)\s+Vn=([\d.]+)\s*\|\s*Risk=([\d.]+)\s*\|\s*LEVEL:\s*(\w+)/
```

---

## Risk Classification Logic (Firmware)

The ATmega328P computes a **linear risk score** for display and buzzer control:

```
R = 0.40 × Mn  +  0.35 × Tn  +  0.25 × Vn    [clamped 0–1]

LEVEL:
  R < 0.30  →  LOW     (green)
  R < 0.60  →  MEDIUM  (orange)
  R ≥ 0.60  →  HIGH    (red + buzzer)
```

The dashboard additionally overlays the ML model's non-linear prediction for a more accurate risk assessment.

---

## Components Bill of Materials

| Qty | Component | Specification |
|-----|-----------|---------------|
| 1 | ATmega328P | DIP-28, 16 MHz |
| 1 | Crystal | 16 MHz, HC-49 |
| 2 | Capacitor | 22 pF ceramic |
| 1 | Soil Moisture Sensor | Capacitive, 3.3–5 V |
| 1 | Shock/Tap Sensor | SW-420 or equivalent |
| 1 | MPU-6050 | 6-DOF IMU breakout |
| 1 | HC-05 | Bluetooth 2.0 SPP |
| 1 | LED | 5 mm, any colour |
| 1 | Resistor | 220 Ω (LED current limit) |
| 1 | Active Buzzer | 5 V |
| 1 | Breadboard / PCB | – |

---

## Firmware Upload

The firmware is written in C/C++ and compiled with the Arduino AVR toolchain targeting the `ATmega328P / 16 MHz` board definition.

```bash
# Using Arduino CLI
arduino-cli compile --fqbn arduino:avr:uno TerraGuardFirmware/
arduino-cli upload  --fqbn arduino:avr:uno -p <PORT> TerraGuardFirmware/
```
