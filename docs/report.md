# TerraGuard — Full Project Report

**Project:** TerraGuard — Smart Landslide Risk Monitoring System  
**Developer:** Avidu Witharana  
**Date:** February 2026  
**Stack:** ATmega328P · HC-05 · Next.js 15 · TypeScript · Python (NumPy) · Tailwind CSS

---

## 1. Introduction

Landslides are one of the most destructive natural hazards in slope-prone regions, responsible for thousands of deaths and billions in damages annually. Early-warning systems that provide even a few minutes of advance notice can allow evacuation and prevent casualties.

**TerraGuard** is a low-cost, real-time landslide early-warning system designed for deployment on unstable slopes. It combines:

1. A **bare-metal ATmega328P** microcontroller collecting soil moisture, tilt, and vibration data
2. **Bluetooth streaming** (HC-05) to a browser dashboard via the Web Serial API
3. A **machine learning model** (MLP neural network, R² = 0.9851) for non-linear risk prediction
4. A **modern React dashboard** (Next.js 15) with live charts, SHAP attribution, and confidence metrics

---

## 2. System Architecture

```
┌─────────────────────────────────────────────────┐
│              Physical Monitoring Node           │
│                                                 │
│  [Moisture Sensor] → ADC A0                     │
│  [MPU-6050 IMU]    → I²C (A4/A5)  ATmega328P   │
│  [Shock Sensor]    → ADC A1      ─────────────► HC-05
│                                                 │
│  (Computes linear risk R, outputs serial line)  │
└─────────────────────────────────────────────────┘
                                        │ Bluetooth / COM
                                        ▼
┌─────────────────────────────────────────────────┐
│                Browser Dashboard                │
│                                                 │
│  Web Serial API → Parser → State               │
│  ├── Real-time charts (Recharts)               │
│  ├── Sensor cards + risk banner                │
│  ├── Activity log (last 20 readings)           │
│  └── AI Risk Prediction (MLP inference)        │
│       ├── Arc gauge (risk %)                   │
│       ├── Feature attribution (SHAP-style)     │
│       ├── Confidence bar                       │
│       └── ML vs formula delta                  │
└─────────────────────────────────────────────────┘
```

---

## 3. Hardware

### 3.1 Microcontroller

The **ATmega328P** (DIP-28, 16 MHz) was chosen for its:
- Mature AVR toolchain and Arduino compatibility
- 10-bit ADC for moisture and vibration analog reads
- Hardware I²C for MPU-6050 communication
- Hardware UART for HC-05 Bluetooth connection

Full wiring documentation: [`docs/embedded_system.md`](embedded_system.md)

### 3.2 Sensors

| Sensor | Measures | Interface | Normalised Variable |
|--------|----------|-----------|---------------------|
| Soil Moisture (capacitive) | Soil water content | ADC (A0) | **Mn** ∈ [0,1] |
| MPU-6050 IMU | Tilt angle via accelerometer | I²C (A4/A5) | **Tn** ∈ [0,1] |
| SW-420 Shock/Vibration | Ground vibration magnitude | ADC (A1) + Digital (D2) | **Vn** ∈ [0,1] |

### 3.3 Output Peripherals

- **HC-05:** Streams sensor data at 9600 baud / 2-second intervals
- **LED (D13):** Status blink on each transmission
- **Active Buzzer (D8):** 3-beep alert when risk is HIGH (R ≥ 0.6)

### 3.4 Serial Protocol

```
Moisture: 612  Mn=0.69 | Tilt: 12.34  Tn=0.27 | Vibration: 308  Vn=0.30 | Risk=0.45 | LEVEL: MEDIUM
```

---

## 4. Software — Dashboard

### 4.1 Technology Stack

| Layer | Technology |
|-------|-----------|
| Framework | Next.js 15 (App Router) |
| Language | TypeScript 5 |
| UI Components | shadcn/ui + Tailwind CSS |
| Charts | Recharts (LineChart) |
| Connectivity | Web Serial API (built-in browser) |
| ML Inference | Hand-written TypeScript (no npm packages) |

### 4.2 Key Features

**Live Bluetooth Connectivity**  
Uses the Web Serial API to connect directly to the HC-05 Bluetooth COM port. A streaming reader loop parses each line, updates state at 2-second intervals, and handles disconnects gracefully.

**Disconnected State UI**  
When no device is connected:
- Sensor cards show animated shimmer placeholders with "awaiting signal…"
- Charts display an empty-state with pulsing radar rings and "No Signal" overlay
- Risk banner shows "System Standby / OFFLINE"
- AI section shows a pulsing violet brain icon

**Real-Time Charts**  
Three synchronized line charts (Mn, Tn, Vn) with 60-point rolling window, click-to-expand modal, and colour-coded lines.

**AI Risk Prediction Card**  
- SVG half-circle arc gauge showing ML risk probability with animated needle
- SHAP-style feature attribution bars (Soil Moisture / Tilt / Vibration)
- Prediction confidence bar (distance from nearest class boundary)
- ML score vs. Arduino linear formula comparison with signed delta
- Model metadata row (architecture, R², MAE, sample count)

### 4.3 State Management

The dashboard is a single React client component (`app/page.tsx`) using:
- `useState` for all sensor, chart, and UI state
- `useRef` for the serial port and reader (mutable refs, not re-renders)
- `useCallback` for the `applyReading` function
- `useEffect` for serial reading loop, disconnect reset, and ML model loading

---

## 5. Machine Learning Model

Full ML documentation: [`docs/ml_documentation.md`](ml_documentation.md)

### 5.1 Problem

The ATmega328P uses a simple weighted linear formula:

```
R_linear = 0.40·Mn + 0.35·Tn + 0.25·Vn
```

This cannot capture non-linear threshold effects and synergistic interactions between saturated soil and seismic loading.

### 5.2 Solution: MLP Neural Network

A **Multi-Layer Perceptron** (3 → 32 → 16 → 1) was trained on a physics-based synthetic dataset of 10,000 samples.

**Physics encoded:**
- Mohr-Coulomb soil–slope interaction: `Mn × Tn`
- Critical saturation threshold spike at Mn > 0.70
- Critical tilt threshold spike at Tn > 0.60
- Seismic amplification by wet soil: `Vn × (1 + 0.5·Mn)`

### 5.3 Performance

| Metric | Value |
|--------|-------|
| R² (validation) | **0.9851** |
| MAE (validation) | **0.0217** |
| 3-class accuracy | **~97%** |
| Model size | 673 parameters / 14 KB JSON |

### 5.4 Browser Inference

The trained weights are exported to `public/model_weights.json` and served as a static asset. A hand-written TypeScript module (`lib/ml-inference.ts`) performs the forward pass at every sensor update without any ML library dependency.

---

## 6. Results and Evaluation

### 6.1 System Performance

| Requirement | Result |
|-------------|--------|
| Real-time streaming | ✅ 2-second update cycle |
| Bluetooth range | ✅ ~10 m (HC-05 Class 2) |
| Dashboard latency | ✅ < 100 ms parse + render |
| ML inference latency | ✅ < 5 ms (673-param network) |
| Offline capability | ✅ Weights served as static file |

### 6.2 Limitations

- **Synthetic dataset:** The ML model was trained on physics-based synthetic data. Performance on real-world deployments should be validated with field sensor logs.
- **Single node:** This is a single-sensor-node prototype. Production systems would use multiple nodes with spatial interpolation.
- **Linear risk on MCU:** The ATmega328P firmware still uses the linear formula; the ML score is computed in the browser only.

### 6.3 Future Work

- Replace linear firmware formula with a compressed neural network running on MCU
- Add GPS coordinates and multi-node aggregation
- Collect real-world calibration data to fine-tune the model
- Implement alert notifications (SMS/email) via a backend relay
- Add historical data persistence (IndexedDB or remote database)

---

## 7. How to Run

### Dashboard

```bash
npm install
npm run dev
# Open http://localhost:3000
```

### ML Model (re-training)

```bash
cd ml/
pip install -r requirements.txt
python train_model.py
```

### Firmware Upload

```bash
# Arduino CLI
arduino-cli compile --fqbn arduino:avr:uno TerraGuardFirmware/
arduino-cli upload  --fqbn arduino:avr:uno -p COM3 TerraGuardFirmware/
```

---

## 8. References

1. Aleotti, P., & Chowdhury, R. (1999). *Landslide hazard assessment: Summary review and new perspectives.* Bulletin of Engineering Geology and the Environment, 58(1), 21–44.
2. Vanapalli, S. K., et al. (1996). *Model for the prediction of shear strength with respect to soil suction.* Canadian Geotechnical Journal, 33(3), 379–392. (Mohr-Coulomb with moisture)
3. Zenodo Dataset: *LSTM-based IoT landslide early-warning system with MPU6050 + moisture sensor.* DOI: 10.5281/zenodo.xxxxxxx
4. SciTePress: *Real-time soil deformation monitoring using geophone, ADXL345, and capacitive moisture sensors.*
5. Kaggle: *Landslide Early Warning Dataset* — `Soil_Saturation`, `Slope_Angle` columns used for threshold calibration.
6. ATmega328P Datasheet, Microchip Technology (2020).
7. HC-05 AT Command Reference, Guangzhou HC Information Technology.
8. InvenSense. MPU-6000/6050 Product Specification, Rev 3.4 (2013).

---

## 9. Developer

**Avidu Witharana**  
Embedded Systems & Full-Stack Developer  
GitHub: [github.com/AviduWitharana](https://github.com/AviduWitharana)
