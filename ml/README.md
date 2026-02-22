# TerraGuard – ML Pipeline

## Overview
Trains a small MLP (3-32-16-1) on a physics-based landslide risk dataset and
exports the weights to `../public/model_weights.json` for browser inference.

## Quick Start

```bash
cd ml/

# Create a virtual environment (recommended)
python -m venv .venv
.venv\Scripts\activate          # Windows
# source .venv/bin/activate     # macOS / Linux

pip install -r requirements.txt
python train_model.py
```

The script will:
1. Generate `dataset.csv` (10 000 labelled samples)
2. Train the MLP and print R², MAE, and 3-class accuracy
3. Write `../public/model_weights.json` (used by the browser)

## Files
| File | Description |
|------|-------------|
| `dataset_generation.py` | Physics-based synthetic dataset generator |
| `train_model.py` | MLP training + weight export (pure NumPy) |
| `dataset.csv` | Auto-generated training data (git-ignored) |
| `requirements.txt` | Python dependencies |

## Dataset Design
Features: **Mn** (moisture), **Tn** (tilt), **Vn** (vibration) — all normalised 0–1.  
Target: **R** (risk score 0–1), derived from a physics formula including:
- Mohr-Coulomb moisture × slope interaction (`Mn × Tn`)
- Super-threshold spikes at Mn > 0.70 and Tn > 0.60
- Seismic amplification: `Vn × (1 + 0.5·Mn)`

Grounded in published hardware studies using MPU6050 (tilt/gyro), SW-420 (vibration), and capacitive moisture sensors for landslide early-warning systems.

## Re-training
Simply re-run `python train_model.py`. The new `model_weights.json` will be
picked up automatically on the next page reload.
