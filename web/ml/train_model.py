"""
TerraGuard – MLP Training Script
=================================
Trains a small Multi-Layer Perceptron on the generated landslide dataset,
then exports all layer weights/biases to ../public/model_weights.json
so the browser can run the forward pass in pure TypeScript (no TF.js).

Architecture
------------
  Input(3) → Dense(32, ReLU) → Dense(16, ReLU) → Dense(1, Sigmoid)

Usage
-----
  cd ml/
  pip install -r requirements.txt
  python train_model.py
"""

import json
import time
from pathlib import Path

import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.metrics import r2_score, mean_absolute_error, classification_report

from dataset_generation import generate  # noqa: E402

# ─── Config ───────────────────────────────────────────────────────────────────
SEED           = 42
HIDDEN_SIZES   = [32, 16]
LR             = 0.005
MOMENTUM       = 0.9
N_EPOCHS       = 2000
BATCH_SIZE     = 256
PATIENCE       = 100
MODEL_VERSION  = "v1.0.0"
N_SAMPLES      = 10_000
OUTPUT_PATH    = Path(__file__).parent.parent / "public" / "model_weights.json"

np.random.seed(SEED)


# ─── Activations ──────────────────────────────────────────────────────────────
def relu(x):    return np.maximum(0.0, x)
def drelu(x):   return (x > 0).astype(np.float64)
def sigmoid(x): return 1.0 / (1.0 + np.exp(-np.clip(x, -500, 500)))


# ─── Network ──────────────────────────────────────────────────────────────────
class MLP:
    def __init__(self, in_dim: int, hidden: list[int]):
        sizes = [in_dim] + hidden + [1]
        self.W, self.b = [], []
        for i in range(len(sizes) - 1):
            fan_in = sizes[i]
            fan_out = sizes[i + 1]
            scale = np.sqrt(2.0 / fan_in) if i < len(sizes) - 2 else np.sqrt(1.0 / fan_in)
            self.W.append(np.random.randn(fan_in, fan_out) * scale)
            self.b.append(np.zeros(fan_out))
        # Momentum buffers
        self.vW = [np.zeros_like(w) for w in self.W]
        self.vb = [np.zeros_like(bv) for bv in self.b]

    def forward(self, X: np.ndarray):
        """Forward pass. Returns (output [N,1], list of (A_in, Z, A_out) per layer)."""
        A = X
        cache = []
        for i, (W, bv) in enumerate(zip(self.W, self.b)):
            Z = A @ W + bv                         # [N, fan_out]
            A_out = relu(Z) if i < len(self.W) - 1 else sigmoid(Z)
            cache.append((A, Z, A_out))
            A = A_out
        return A, cache                            # A is [N, 1]

    def backward(self, cache, y: np.ndarray):
        """MSE back-prop, updates weights in-place."""
        n = y.shape[0]
        # Output layer gradient
        A_out = cache[-1][2]               # [N, 1]
        Z_out = cache[-1][1]               # [N, 1]
        # dL/dA_out * dA_out/dZ_out  (MSE + sigmoid)
        dZ = (A_out - y.reshape(-1, 1)) * (A_out * (1 - A_out))    # [N,1]

        for i in reversed(range(len(self.W))):
            A_in = cache[i][0]             # [N, fan_in]
            dW = A_in.T @ dZ / n           # [fan_in, fan_out]
            db = dZ.mean(axis=0)           # [fan_out]

            # Momentum update
            self.vW[i] = MOMENTUM * self.vW[i] - LR * dW
            self.vb[i] = MOMENTUM * self.vb[i] - LR * db
            self.W[i] += self.vW[i]
            self.b[i]  += self.vb[i]

            # Propagate gradient to previous layer (unless we're at layer 0)
            if i > 0:
                Z_prev = cache[i - 1][1]   # [N, this_layer_fan_in]
                dZ = (dZ @ self.W[i].T) * drelu(Z_prev)   # [N, fan_in]

    def predict(self, X: np.ndarray) -> np.ndarray:
        out, _ = self.forward(X)
        return out.ravel()


# ─── Train ────────────────────────────────────────────────────────────────────
def train():
    # 1. Dataset
    print("Generating dataset …")
    df = generate(N_SAMPLES)
    csv_path = Path(__file__).parent / "dataset.csv"
    df.to_csv(csv_path, index=False)
    counts = df["cls"].value_counts().sort_index()
    labels = {0: "LOW", 1: "MEDIUM", 2: "HIGH"}
    print(f"  {len(df)} samples  ·  {', '.join(f'{labels[k]}:{v}' for k,v in counts.items())}")

    X = df[["Mn", "Tn", "Vn"]].values.astype(np.float64)
    y = df["R"].values.astype(np.float64)
    y_cls = df["cls"].values

    X_tr, X_val, y_tr, y_val, yc_tr, yc_val = train_test_split(
        X, y, y_cls, test_size=0.15, random_state=SEED
    )
    print(f"  Train: {len(X_tr)}, Val: {len(X_val)}")

    # 2. Train
    model = MLP(3, HIDDEN_SIZES)
    best_loss = float("inf")
    best_W, best_b = None, None
    patience_cnt = 0

    print(f"\nTraining MLP [3→{HIDDEN_SIZES}→1] up to {N_EPOCHS} epochs …")
    t0 = time.time()

    for epoch in range(N_EPOCHS):
        idx = np.random.permutation(len(X_tr))
        for start in range(0, len(X_tr), BATCH_SIZE):
            batch = idx[start:start + BATCH_SIZE]
            _, cache = model.forward(X_tr[batch])
            model.backward(cache, y_tr[batch])

        # Validate
        y_hat_val   = model.predict(X_val)
        val_mse     = float(np.mean((y_hat_val - y_val) ** 2))

        if val_mse < best_loss - 1e-7:
            best_loss = val_mse
            best_W    = [w.copy() for w in model.W]
            best_b    = [bv.copy() for bv in model.b]
            patience_cnt = 0
        else:
            patience_cnt += 1
            if patience_cnt >= PATIENCE:
                print(f"  Early stop @ epoch {epoch + 1}  (best val MSE={best_loss:.6f})")
                break

        if (epoch + 1) % 200 == 0 or epoch == 0:
            print(f"  Epoch {epoch + 1:4d}  val_MSE={val_mse:.6f}")

    elapsed = time.time() - t0
    print(f"\nDone in {elapsed:.1f} s")

    # Restore best
    model.W = best_W
    model.b = best_b

    # 3. Evaluate
    y_hat = model.predict(X_val)
    r2    = r2_score(y_val, y_hat)
    mae   = mean_absolute_error(y_val, y_hat)
    pred_cls = np.where(y_hat >= 0.6, 2, np.where(y_hat >= 0.3, 1, 0))

    print(f"\n── Regression ──────────────")
    print(f"  R²  = {r2:.6f}")
    print(f"  MAE = {mae:.6f}")
    print(f"\n── Classification (3-class) ")
    print(classification_report(yc_val, pred_cls, target_names=["LOW", "MEDIUM", "HIGH"]))

    # 4. Sanity checks
    tests = [
        ("All-zero (stable)",   0.00, 0.00, 0.00),
        ("High moisture only",  0.90, 0.10, 0.10),
        ("High tilt only",      0.10, 0.90, 0.10),
        ("All-high (crisis)",   0.90, 0.90, 0.90),
        ("Medium scenario",     0.50, 0.50, 0.50),
    ]
    print("\n── Sanity checks ───────────")
    for lbl, Mn, Tn, Vn in tests:
        r     = float(model.predict(np.array([[Mn, Tn, Vn]]))[0])
        cls   = "HIGH" if r >= 0.6 else "MEDIUM" if r >= 0.3 else "LOW"
        print(f"  {lbl:28s}  R={r:.4f}  [{cls}]")

    # 5. Export
    payload = {
        "modelVersion": MODEL_VERSION,
        "architecture": {
            "input_dim":    3,
            "hidden_sizes": HIDDEN_SIZES,
            "output_dim":   1,
            "activations":  ["relu"] * len(HIDDEN_SIZES) + ["sigmoid"],
        },
        "training": {
            "n_samples":  N_SAMPLES,
            "train_size": len(X_tr),
            "val_size":   len(X_val),
            "r2_val":     round(r2, 6),
            "mae_val":    round(mae, 6),
            "epochs_run": epoch + 1,
        },
        "thresholds":     {"low_medium": 0.3, "medium_high": 0.6},
        "feature_names":  ["Mn", "Tn", "Vn"],
        "dataset_info":   {
            "description": (
                "Physics-based synthetic dataset grounded in Mohr-Coulomb failure "
                "criterion, soil saturation thresholds, and seismic amplification. "
                "References: Zenodo (LSTM+IoT landslide monitoring), SciTePress "
                "(soil deformation monitoring using geophone + ADXL345 + moisture "
                "sensors), Kaggle Landslide Dataset (Soil_Saturation, Slope_Angle)."
            ),
        },
        "layers": [
            {"weights": w.tolist(), "biases": bv.tolist()}
            for w, bv in zip(model.W, model.b)
        ],
    }

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    with open(OUTPUT_PATH, "w") as f:
        json.dump(payload, f, separators=(",", ":"))

    size_kb = OUTPUT_PATH.stat().st_size / 1024
    print(f"\n✓ Weights → {OUTPUT_PATH}  ({size_kb:.1f} KB)")
    status = "✓ PASS" if r2 >= 0.95 else "⚠  WARN (R² < 0.95)"
    print(f"{status}  R²={r2:.4f}  MAE={mae:.4f}")


if __name__ == "__main__":
    train()
