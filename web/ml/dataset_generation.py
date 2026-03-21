"""
TerraGuard – Landslide Risk Dataset Generator
==============================================
Generates a physically-motivated synthetic dataset of 10 000 samples.

Features
--------
  Mn  : soil-moisture normalized  [0, 1]
  Tn  : tilt/slope normalized     [0, 1]
  Vn  : vibration normalized      [0, 1]

Target
------
  R   : risk score   [0, 1]   (regression)
  cls : risk class   {0=LOW, 1=MEDIUM, 2=HIGH}

Physics-based labelling
-----------------------
The ground-truth risk function is richer than the Arduino linear formula and
captures the following published landslide-trigger relationships:

  1. Mohr-Coulomb interaction: moisture degrades soil cohesion,
     slope increases shear stress → interaction term Mn × Tn is significant.
  2. Threshold non-linearities: risk accelerates above ~70 % moisture or
     ~60 % slope (consistent with field study thresholds; see SciTePress
     soil-deformation monitoring paper and Zenodo LSTM/IoT study).
  3. Seismic amplification: vibration impact scales with moisture (wet soil
     transmits vibration more effectively).

References
----------
  - Zenodo: "Landslide Monitoring and Prediction Using IoT and LSTM Based RNN"
  - SciTePress: "Soil Deformation Monitoring System using Soil Vibration and Moisture"
  - Kaggle "Landslide dataset" (Slope_Angle, Soil_Saturation, Rainfall_mm)
"""

import numpy as np
import pandas as pd
from pathlib import Path

# Reproducibility
RNG = np.random.default_rng(42)

N_SAMPLES = 10_000


def _sigmoid(x: np.ndarray) -> np.ndarray:
    return 1.0 / (1.0 + np.exp(-x))


def physics_risk(Mn: np.ndarray, Tn: np.ndarray, Vn: np.ndarray) -> np.ndarray:
    """
    Physics-inspired risk function.

    Base weights (from Arduino / literature consensus):
        moisture  → 0.40
        tilt      → 0.35
        vibration → 0.25

    Additional non-linear terms:
        - Mohr-Coulomb interaction:  Mn * Tn  (primary co-trigger)
        - Above-threshold moisture:  ReLU(Mn - 0.70) spike
        - Above-threshold tilt:      ReLU(Tn - 0.60) spike
        - Seismic amplification:     Vn * (1 + 0.5*Mn)
    """
    # Linear base
    base = 0.33 * Mn + 0.29 * Tn + 0.18 * Vn

    # Mohr-Coulomb interaction (wet + steep = dangerous)
    interaction = 0.14 * Mn * Tn

    # Super-threshold spikes
    spike_m = 0.12 * np.maximum(0.0, Mn - 0.70) / 0.30   # normalised to [0,0.12]
    spike_t = 0.09 * np.maximum(0.0, Tn - 0.60) / 0.40   # normalised to [0,0.09]

    # Seismic amplification
    seismic = 0.06 * Vn * (1.0 + 0.5 * Mn)

    R = base + interaction + spike_m + spike_t + seismic
    return np.clip(R, 0.0, 1.0)


def generate(n: int = N_SAMPLES) -> pd.DataFrame:
    """
    Generate n labelled samples.

    Sampling strategy: mixture of uniform coverage + scenario-weighted
    sampling to ensure balanced class representation.
    """
    # --- 70 % uniform coverage ---
    n_uniform = int(n * 0.70)
    Mn_u = RNG.uniform(0.0, 1.0, n_uniform)
    Tn_u = RNG.uniform(0.0, 1.0, n_uniform)
    Vn_u = RNG.uniform(0.0, 1.0, n_uniform)

    # --- 30 % scenario-weighted (critical regions) ---
    n_scenario = n - n_uniform

    # HIGH-risk scenario: high moisture, moderate-to-high tilt
    n_high = n_scenario // 3
    Mn_h = RNG.uniform(0.65, 1.0, n_high)
    Tn_h = RNG.uniform(0.50, 1.0, n_high)
    Vn_h = RNG.uniform(0.30, 1.0, n_high)

    # MEDIUM-risk scenario: moderate moisture + tilt
    n_med = n_scenario // 3
    Mn_m = RNG.uniform(0.35, 0.70, n_med)
    Tn_m = RNG.uniform(0.25, 0.65, n_med)
    Vn_m = RNG.uniform(0.10, 0.70, n_med)

    # LOW-risk scenario: low moisture or low tilt
    n_low = n_scenario - n_high - n_med
    Mn_l = RNG.uniform(0.0, 0.45, n_low)
    Tn_l = RNG.uniform(0.0, 0.40, n_low)
    Vn_l = RNG.uniform(0.0, 0.40, n_low)

    # Combine
    Mn = np.concatenate([Mn_u, Mn_h, Mn_m, Mn_l])
    Tn = np.concatenate([Tn_u, Tn_h, Tn_m, Tn_l])
    Vn = np.concatenate([Vn_u, Vn_h, Vn_m, Vn_l])

    # Compute ground-truth risk
    R = physics_risk(Mn, Tn, Vn)

    # Add realistic sensor noise (± ~2 % of range)
    noise_scale = 0.02
    R_noisy = np.clip(
        R + RNG.normal(0.0, noise_scale, len(R)),
        0.0, 1.0
    )

    # Classify
    cls = np.where(R_noisy >= 0.6, 2, np.where(R_noisy >= 0.3, 1, 0))

    df = pd.DataFrame({
        "Mn": np.round(Mn, 4),
        "Tn": np.round(Tn, 4),
        "Vn": np.round(Vn, 4),
        "R":  np.round(R_noisy, 4),
        "cls": cls,
    })

    # Shuffle
    df = df.sample(frac=1, random_state=42).reset_index(drop=True)
    return df


if __name__ == "__main__":
    out_path = Path(__file__).parent / "dataset.csv"
    df = generate()
    df.to_csv(out_path, index=False)

    counts = df["cls"].value_counts().sort_index()
    labels = {0: "LOW", 1: "MEDIUM", 2: "HIGH"}
    print(f"Dataset saved → {out_path}")
    print(f"Total samples : {len(df)}")
    print("Class distribution:")
    for k, v in counts.items():
        print(f"  {labels[k]:6s} ({k}): {v:5d}  ({v/len(df)*100:.1f} %)")
    print(f"R  mean={df['R'].mean():.3f}  std={df['R'].std():.3f}")
