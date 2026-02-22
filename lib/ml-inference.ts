/**
 * TerraGuard – Browser-side MLP Inference
 * =========================================
 * Loads the exported model weights from /model_weights.json and runs
 * the MLP forward pass entirely in TypeScript — no TF.js required.
 *
 * Architecture: Input(3) → Dense(32, ReLU) → Dense(16, ReLU) → Dense(1, Sigmoid)
 *
 * Usage:
 *   import { loadModel, predictRisk } from '@/lib/ml-inference'
 *   await loadModel()           // call once on mount
 *   const result = predictRisk(Mn, Tn, Vn)
 */

// ─── Types ────────────────────────────────────────────────────────────────────

export interface MLModelMeta {
    modelVersion: string
    architecture: {
        input_dim: number
        hidden_sizes: number[]
        output_dim: number
        activations: string[]
    }
    training: {
        n_samples: number
        train_size: number
        val_size: number
        r2_val: number
        mae_val: number
        epochs_run: number
    }
    thresholds: { low_medium: number; medium_high: number }
    feature_names: string[]
    layers: Array<{ weights: number[][]; biases: number[] }>
}

export interface MLPrediction {
    riskScore: number                         // raw score 0–1
    riskClass: 'LOW' | 'MEDIUM' | 'HIGH'
    confidence: number                        // 0–1: distance from nearest class boundary
    contributions: {
        moisture: number                        // SHAP-style partial attribution 0–1
        tilt: number
        vibration: number
    }
    linearScore: number                       // old Arduino formula for comparison
    delta: number                             // ML score − linear score (signed)
    meta: MLModelMeta
}

// ─── State ────────────────────────────────────────────────────────────────────

let _model: MLModelMeta | null = null
let _loadPromise: Promise<void> | null = null

// ─── Math helpers ─────────────────────────────────────────────────────────────

function relu(x: number): number { return Math.max(0, x) }
function sigmoid(x: number): number { return 1 / (1 + Math.exp(-Math.max(-500, Math.min(500, x)))) }

/** Matrix-vector multiply: (n_out,) = W[n_in, n_out]ᵀ · x[n_in] + b[n_out] */
function linearLayer(x: number[], W: number[][], b: number[]): number[] {
    const nOut = W[0].length
    const out = new Array<number>(nOut)
    for (let j = 0; j < nOut; j++) {
        let sum = b[j]
        for (let i = 0; i < x.length; i++) sum += x[i] * W[i][j]
        out[j] = sum
    }
    return out
}

// ─── Forward pass ─────────────────────────────────────────────────────────────

function forwardPass(inputs: number[]): number {
    if (!_model) throw new Error('Model not loaded. Call loadModel() first.')
    const n = _model.layers.length
    let a = inputs
    for (let l = 0; l < n; l++) {
        const { weights, biases } = _model.layers[l]
        const z = linearLayer(a, weights, biases)
        a = (l < n - 1)
            ? z.map(relu)
            : z.map(sigmoid)
    }
    return a[0]
}

// ─── Gradient-based feature attribution (finite differences) ─────────────────
// Each feature's contribution is the sensitivity of the output to that feature,
// weighted by the feature value itself (input × gradient ≈ Integrated Gradients).

function computeContributions(Mn: number, Tn: number, Vn: number): { moisture: number; tilt: number; vibration: number } {
    const eps = 1e-4
    const base = forwardPass([Mn, Tn, Vn])

    // Partial derivatives via finite differences
    const dMn = (forwardPass([Mn + eps, Tn, Vn]) - base) / eps
    const dTn = (forwardPass([Mn, Tn + eps, Vn]) - base) / eps
    const dVn = (forwardPass([Mn, Tn, Vn + eps]) - base) / eps

    // Primary: input × gradient (how much each sensor currently drives risk)
    const attrMn = Mn * dMn
    const attrTn = Tn * dTn
    const attrVn = Vn * dVn
    const totalWeighted = attrMn + attrTn + attrVn

    if (totalWeighted > 1e-6) {
        // Normal case: inputs have meaningful values
        return {
            moisture: Math.max(0, Math.min(1, attrMn / totalWeighted)),
            tilt: Math.max(0, Math.min(1, attrTn / totalWeighted)),
            vibration: Math.max(0, Math.min(1, attrVn / totalWeighted)),
        }
    }

    // Fallback: inputs near zero — use raw gradient magnitude (sensitivity)
    const totalGrad = Math.abs(dMn) + Math.abs(dTn) + Math.abs(dVn)
    if (totalGrad < 1e-8) {
        // Model output is flat here — no meaningful attribution at all
        return { moisture: 0, tilt: 0, vibration: 0 }
    }

    return {
        moisture: Math.max(0, Math.min(1, Math.abs(dMn) / totalGrad)),
        tilt: Math.max(0, Math.min(1, Math.abs(dTn) / totalGrad)),
        vibration: Math.max(0, Math.min(1, Math.abs(dVn) / totalGrad)),
    }
}

// ─── Confidence calculation ────────────────────────────────────────────────────
// Confidence = how far the score is from the nearest class boundary (0.3 or 0.6)
// Mapped to [0, 1] within its class interval.

function computeConfidence(score: number): number {
    const lo = 0.3
    const hi = 0.6
    if (score < lo) {
        // LOW class: boundary at lo, max confidence at 0.0
        return 2 * Math.min(score, lo - score)    // peaks at lo/2 = 0.15
    } else if (score < hi) {
        // MEDIUM class: boundaries at lo and hi, max confidence at 0.45
        const mid = (lo + hi) / 2
        return 1 - Math.abs(score - mid) / ((hi - lo) / 2)
    } else {
        // HIGH class: boundary at hi, max confidence at 1.0
        return 2 * Math.min(1 - score, score - hi)   // peaks at hi + (1-hi)/2 = 0.8
    }
}

// ─── Public API ───────────────────────────────────────────────────────────────

/** Load model weights from /model_weights.json (idempotent — only fetches once). */
export async function loadModel(): Promise<void> {
    if (_model) return
    if (_loadPromise) return _loadPromise

    _loadPromise = fetch('/model_weights.json')
        .then(r => {
            if (!r.ok) throw new Error(`Failed to load model_weights.json: ${r.status}`)
            return r.json() as Promise<MLModelMeta>
        })
        .then(data => { _model = data })

    return _loadPromise
}

/** Returns true after loadModel() has resolved. */
export function isModelLoaded(): boolean { return _model !== null }

/** Returns the model metadata (version, training stats, etc.) */
export function getModelMeta(): MLModelMeta | null { return _model }

/**
 * Run inference on a single (Mn, Tn, Vn) sample.
 * Must call loadModel() and await it before calling this.
 */
export function predictRisk(Mn: number, Tn: number, Vn: number): MLPrediction {
    if (!_model) throw new Error('Model not loaded.')

    const riskScore = forwardPass([Mn, Tn, Vn])

    const { low_medium: lo, medium_high: hi } = _model.thresholds
    const riskClass: 'LOW' | 'MEDIUM' | 'HIGH' =
        riskScore >= hi ? 'HIGH' : riskScore >= lo ? 'MEDIUM' : 'LOW'

    // Old linear formula (Arduino baseline)
    const linearScore = Math.min(1, 0.40 * Mn + 0.35 * Tn + 0.25 * Vn)

    const contributions = computeContributions(Mn, Tn, Vn)
    const confidence = Math.max(0, Math.min(1, computeConfidence(riskScore)))

    return {
        riskScore: Math.round(riskScore * 10000) / 10000,
        riskClass,
        confidence: Math.round(confidence * 100) / 100,
        contributions: {
            moisture: Math.round(contributions.moisture * 100) / 100,
            tilt: Math.round(contributions.tilt * 100) / 100,
            vibration: Math.round(contributions.vibration * 100) / 100,
        },
        linearScore: Math.round(linearScore * 10000) / 10000,
        delta: Math.round((riskScore - linearScore) * 10000) / 10000,
        meta: _model,
    }
}
