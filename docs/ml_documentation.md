# TerraGuard — ML Model Documentation

## Overview

TerraGuard uses a browser-side **Multi-Layer Perceptron (MLP)** neural network to predict landslide risk from three normalised sensor readings. The model is trained offline in Python and deployed as a JSON weight file loaded by a hand-written TypeScript inference engine — requiring **no heavy ML libraries** in the browser.

---

## The Problem

Landslide early-warning systems rely on multiple concurrent environmental signals. The traditional approach at the firmware level uses a **weighted linear formula**:

```
R_linear = 0.40·Mn + 0.35·Tn + 0.25·Vn
```

While fast to compute on an 8-bit MCU, this formula:
- Ignores **non-linear interactions** (e.g., saturated soil amplifying seismic effects)
- Cannot capture **threshold behaviour** (sharp increase in risk above critical values)
- Misses **synergistic effects** between sensors

The MLP model captures all of these non-linearities.

---

## Dataset

### Strategy: Physics-Motivated Synthetic Data

No single public dataset provides all three of TerraGuard's sensor axes (soil moisture Mn, tilt Tn, vibration Vn) with corresponding risk labels. After reviewing available options, a **physically-grounded synthetic dataset** of **10,000 samples** was generated.

### Dataset References / Inspiration

| Source | What it provided |
|--------|-----------------|
| [Kaggle Landslide Dataset](https://www.kaggle.com/) | `Soil_Saturation` ↔ Mn, `Slope_Angle` ↔ Tn threshold values |
| Zenodo: "LSTM+IoT Landslide Monitoring" | Confirms MPU6050 (Tn) + SW-420 (Vn) + moisture (Mn) as the canonical 3-sensor setup |
| SciTePress: "Soil Deformation Monitoring using Geophone + ADXL345 + Moisture Sensors" | Validates 3-feature model; provides seismic amplification coefficient estimates |

### Physics Encoded in the Dataset

The ground-truth risk score **R** is computed from the Mohr-Coulomb failure framework:

```
R_base     = 0.33·Mn + 0.29·Tn + 0.18·Vn
interaction = 0.14 · (Mn × Tn)                     # saturated slope = highest danger
spike_m    = 0.12 · max(0, Mn - 0.70)              # critical saturation threshold > 70%
spike_t    = 0.09 · max(0, Tn - 0.60)              # critical tilt threshold > 60%
seismic    = 0.06 · Vn · (1 + 0.5·Mn)             # vibration amplified by wet soil

R = clip(R_base + interaction + spike_m + spike_t + seismic + noise, 0, 1)
```

Gaussian noise (σ = 0.025) is added to simulate real sensor imperfections.

### Dataset Statistics

| Class | Threshold | Count | Percentage |
|-------|-----------|-------|------------|
| LOW | R < 0.30 | 2,145 | 21.5% |
| MEDIUM | 0.30 ≤ R < 0.60 | 4,697 | 47.0% |
| HIGH | R ≥ 0.60 | 3,158 | 31.6% |

**Train / Validation split:** 85% / 15% (8,500 / 1,500 samples)

---

## Model Architecture

```
Input Layer     Hidden Layer 1    Hidden Layer 2    Output Layer
   (3)         →  (32, ReLU)   →  (16, ReLU)    →  (1, Sigmoid)

Mn ─┐
Tn ─┼──► [Linear 3×32] ──► ReLU ──► [Linear 32×16] ──► ReLU ──► [Linear 16×1] ──► Sigmoid ──► R̂ ∈ [0,1]
Vn ─┘
```

| Layer | Input → Output | Activation | Parameters |
|-------|---------------|------------|------------|
| Dense 1 | 3 → 32 | ReLU | 3×32 + 32 = 128 |
| Dense 2 | 32 → 16 | ReLU | 32×16 + 16 = 528 |
| Dense 3 | 16 → 1 | Sigmoid | 16×1 + 1 = 17 |
| **Total** | | | **673 parameters** |

The network is intentionally small (673 parameters) to allow browser-side inference at sensor update frequency (every 2 seconds) with negligible CPU usage.

---

## Training Algorithm

### Optimiser: Mini-Batch SGD with Momentum

```python
# Nesterov-style momentum SGD
velocity_W = momentum × velocity_W - lr × dW
weight_W  += velocity_W

hyperparameters:
  lr          = 0.005
  momentum    = 0.90
  batch_size  = 256
  max_epochs  = 2000
  patience    = 100    # early stopping
```

### Weight Initialisation: He (Kaiming) Initialisation

For ReLU layers, each weight is drawn from:
```
W ~ N(0, sqrt(2 / fan_in))
```

This prevents vanishing gradients in deep ReLU networks.

### Loss Function: Mean Squared Error (Regression)

```
L = (1/N) Σ (ŷᵢ - yᵢ)²
```

The network solves regression (predicting continuous R ∈ [0,1]), not direct classification. Risk classes are derived by thresholding:
```
R < 0.30  → LOW
R < 0.60  → MEDIUM
R ≥ 0.60  → HIGH
```

### Early Stopping

Training stops if validation MSE does not improve by more than `1e-7` for 100 consecutive epochs. The best weights (by val MSE) are saved and restored.

---

## Training Results

### Regression Metrics (Validation Set, 1,500 samples)

| Metric | Value |
|--------|-------|
| **R² Score** | **0.9851** |
| **MAE** | **0.0217** |
| Val MSE | 0.001057 |
| Epochs run | ~1,000 (early stop) |

An **R² of 0.9851** means the model explains **98.5%** of the variance in landslide risk, far outperforming the linear formula (estimated R² ≈ 0.84 on the same dataset).

### 3-Class Classification Metrics (Validation Set)

| Class | Precision | Recall | F1-Score | Support |
|-------|-----------|--------|----------|---------|
| LOW | 0.98 | 0.98 | 0.98 | ~322 |
| MEDIUM | 0.96 | 0.97 | 0.96 | ~705 |
| HIGH | 0.98 | 0.97 | 0.97 | ~473 |
| **Macro avg** | **0.97** | **0.97** | **0.97** | 1500 |

### Sanity Checks

| Scenario | Mn | Tn | Vn | ML Score | Class |
|----------|----|----|----|----------|-------|
| All baseline | 0.00 | 0.00 | 0.00 | ~0.005 | LOW |
| High moisture | 0.90 | 0.10 | 0.10 | ~0.38 | MEDIUM |
| High tilt | 0.10 | 0.90 | 0.10 | ~0.33 | MEDIUM |
| Full crisis | 0.90 | 0.90 | 0.90 | ~0.94 | HIGH |
| Medium scenario | 0.50 | 0.50 | 0.50 | ~0.47 | MEDIUM |

---

## Model Export Format

After training, weights are exported to `public/model_weights.json` (14 KB):

```json
{
  "modelVersion": "v1.0.0",
  "architecture": { "input_dim": 3, "hidden_sizes": [32, 16], "output_dim": 1 },
  "training": { "r2_val": 0.9851, "mae_val": 0.0217, "epochs_run": 1000 },
  "thresholds": { "low_medium": 0.3, "medium_high": 0.6 },
  "feature_names": ["Mn", "Tn", "Vn"],
  "layers": [
    { "weights": [[...32 cols per row, 3 rows...]], "biases": [...32...] },
    { "weights": [[...16 cols per row, 32 rows...]], "biases": [...16...] },
    { "weights": [[...1 col per row, 16 rows...]], "biases": [...1...] }
  ]
}
```

---

## Browser Inference (`lib/ml-inference.ts`)

A hand-written TypeScript module implements the entire MLP forward pass using plain array math — no `npm` package is required. The weights file (~14 KB) is fetched once on mount via `fetch('/model_weights.json')`.

### Forward Pass

```typescript
function forwardPass(inputs: number[]): number {
  let a = inputs
  for (let l = 0; l < layers.length; l++) {
    const z = linearLayer(a, layers[l].weights, layers[l].biases)
    a = l < n - 1 ? z.map(relu) : z.map(sigmoid)
  }
  return a[0]
}
```

### Feature Attribution

Gradient-based SHAP-style attributions are computed via finite differences:

```typescript
const dMn = (forwardPass([Mn + ε, Tn, Vn]) - base) / ε  // sensitivity
const attr = input × gradient  // contribution at current value
```

When inputs are near zero, the method automatically falls back to raw gradient magnitudes (sensitivity mode), avoiding the misleading equal-split that would otherwise appear.

### Confidence Score

```
confidence = distance from nearest class boundary (0.30 or 0.60)
           = normalized fraction of the class interval occupied
```

---

## Files

| File | Purpose |
|------|---------|
| `ml/dataset_generation.py` | Generates physics-based 10k dataset |
| `ml/train_model.py` | Trains MLP, exports weights |
| `ml/requirements.txt` | Python dependencies |
| `ml/dataset.csv` | Generated dataset (git-ignored in production) |
| `public/model_weights.json` | Exported weights (served as static asset) |
| `lib/ml-inference.ts` | TypeScript MLP forward pass + attribution |

---

## Re-Training

```bash
cd ml/
pip install -r requirements.txt
python train_model.py
# → prints R², MAE, classification report
# → overwrites public/model_weights.json
```

The new weights are picked up on the next browser page reload.
