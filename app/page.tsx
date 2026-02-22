'use client'

import { useState, useEffect, useRef, useCallback } from 'react'
import { AlertTriangle, Bluetooth, BluetoothOff, Zap, Activity, Droplets, TrendingUp, Maximize2, X, Loader2, Radio, CheckCircle2, Brain, Gauge } from 'lucide-react'
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { loadModel, predictRisk, isModelLoaded, type MLPrediction } from '@/lib/ml-inference'

// ─── Types ────────────────────────────────────────────────────────────────────
type ConnectionState = 'disconnected' | 'scanning' | 'connecting' | 'connected' | 'error'
type RiskLevel = 'LOW' | 'MEDIUM' | 'HIGH'

interface SensorReading {
  // Raw sensor values
  moistureRaw: number   // ADC value (soil sensor)
  tilt: number          // degrees (can be negative)
  vibrationRaw: number  // ADC value
  // Normalized (0.0 – 1.0)
  Mn: number
  Tn: number
  Vn: number
  // Risk
  R: number             // 0.0 – 1.0
  level: RiskLevel
}

interface ChartPoint {
  time: string
  Mn: number   // moisture normalized %
  Tn: number   // tilt normalized %
  Vn: number   // vibration normalized %
}

interface ActivityEntry extends SensorReading {
  time: string
}

// ─── Arduino Serial Parser ─────────────────────────────────────────────────────
// Expected format (exact):
// Moisture: 0  Mn=0.00 | Tilt: 0.00  Tn=0.00 | Vibration: 8  Vn=0.01 | Risk=0.00 | LEVEL: LOW
const ARDUINO_REGEX =
  /Moisture:\s*(-?[\d.]+)\s+Mn=([\d.]+)\s*\|\s*Tilt:\s*(-?[\d.]+)\s+Tn=([\d.]+)\s*\|\s*Vibration:\s*(-?[\d.]+)\s+Vn=([\d.]+)\s*\|\s*Risk=([\d.]+)\s*\|\s*LEVEL:\s*(\w+)/

function parseArduinoLine(line: string): SensorReading | null {
  const m = line.match(ARDUINO_REGEX)
  if (!m) return null
  const level = m[8].trim().toUpperCase() as RiskLevel
  return {
    moistureRaw: parseFloat(m[1]),
    Mn: parseFloat(m[2]),
    tilt: parseFloat(m[3]),
    Tn: parseFloat(m[4]),
    vibrationRaw: parseFloat(m[5]),
    Vn: parseFloat(m[6]),
    R: parseFloat(m[7]),
    level: ['LOW', 'MEDIUM', 'HIGH'].includes(level) ? level : 'LOW',
  }
}

// ─── Simulated Data (mirrors Arduino logic when disconnected) ─────────────────
// M_MIN=200, M_MAX=800, T_MAX=45°, V_MAX=1023
function simulateReading(): SensorReading {
  const moistureRaw = 200 + Math.random() * 600
  const tilt = (Math.random() - 0.5) * 60          // -30° to +30°
  const vibrationRaw = Math.random() * 300
  const Mn = Math.max(0, Math.min(1, (moistureRaw - 200) / 600))
  const Tn = Math.max(0, Math.min(1, Math.abs(tilt) / 45))
  const Vn = Math.max(0, Math.min(1, vibrationRaw / 1023))
  const R = 0.40 * Mn + 0.35 * Tn + 0.25 * Vn
  const level: RiskLevel = R >= 0.6 ? 'HIGH' : R >= 0.3 ? 'MEDIUM' : 'LOW'
  return {
    moistureRaw: Math.round(moistureRaw),
    tilt: Math.round(tilt * 100) / 100,
    vibrationRaw: Math.round(vibrationRaw),
    Mn: Math.round(Mn * 100) / 100,
    Tn: Math.round(Tn * 100) / 100,
    Vn: Math.round(Vn * 100) / 100,
    R: Math.round(R * 100) / 100,
    level,
  }
}

// Build 60-point simulated history
function buildSimulatedHistory(): { chart: ChartPoint[]; log: ActivityEntry[] } {
  const now = new Date()
  const chart: ChartPoint[] = []
  const log: ActivityEntry[] = []
  for (let i = 60; i >= 0; i--) {
    const t = new Date(now.getTime() - i * 2000)
    const timeStr = `${String(t.getHours()).padStart(2, '0')}:${String(t.getMinutes()).padStart(2, '0')}:${String(t.getSeconds()).padStart(2, '0')}`
    const r = simulateReading()
    chart.push({ time: timeStr, Mn: r.Mn, Tn: r.Tn, Vn: r.Vn })
    if (i % 6 === 0) log.push({ ...r, time: timeStr })
  }
  return { chart, log: log.slice(0, 10) }
}

// ─── Disconnected Placeholders ────────────────────────────────────────────────
type PlaceholderColor = 'blue' | 'orange' | 'purple'

const PLACEHOLDER_COLOR_MAP: Record<PlaceholderColor, { bar: string; glow: string }> = {
  blue:   { bar: 'bg-blue-500/20',   glow: 'bg-blue-400/10' },
  orange: { bar: 'bg-orange-500/20', glow: 'bg-orange-400/10' },
  purple: { bar: 'bg-purple-500/20', glow: 'bg-purple-400/10' },
}

function SensorAwaitingPlaceholder({ color, label }: { color: PlaceholderColor; label: string }) {
  const c = PLACEHOLDER_COLOR_MAP[color]
  return (
    <div className="flex flex-col gap-3 animate-pulse">
      {/* Value placeholder */}
      <div className="flex items-end gap-2">
        <div className="h-12 w-20 rounded-md bg-secondary/50" />
        <div className="h-6 w-6 rounded bg-secondary/30 mb-1" />
      </div>
      {/* Sub-label placeholder */}
      <div className="h-3 w-48 rounded bg-secondary/40" />
      {/* Progress bar */}
      <div className={`w-full ${c.glow} rounded-full h-3 relative overflow-hidden`}>
        <div
          className={`absolute top-0 left-0 h-full w-1/3 ${c.bar} rounded-full`}
          style={{ animation: 'none' }}
        />
      </div>
      {/* Awaiting text */}
      <p className="text-xs text-muted-foreground/50 font-mono mt-1">
        {label} &mdash; <span className="italic">awaiting signal…</span>
      </p>
    </div>
  )
}

function ChartAwaitingPlaceholder() {
  return (
    <div className="flex flex-col items-center justify-center h-[180px] gap-3 select-none">
      {/* Animated scan-line grid */}
      <div className="relative w-full h-full flex items-center justify-center overflow-hidden rounded-md bg-secondary/10 border border-border/20">
        {/* Horizontal grid lines */}
        {[0.2, 0.4, 0.6, 0.8].map(pos => (
          <div
            key={pos}
            className="absolute w-full border-t border-border/20"
            style={{ top: `${pos * 100}%` }}
          />
        ))}
        {/* Vertical grid lines */}
        {[0.25, 0.5, 0.75].map(pos => (
          <div
            key={pos}
            className="absolute h-full border-l border-border/20"
            style={{ left: `${pos * 100}%` }}
          />
        ))}
        {/* Center content */}
        <div className="relative z-10 flex flex-col items-center gap-2">
          <div className="relative">
            {/* Outer ping rings */}
            <div className="absolute inset-0 rounded-full border border-muted-foreground/20 animate-ping" style={{ animationDuration: '2s' }} />
            <div className="absolute inset-1 rounded-full border border-muted-foreground/10 animate-ping" style={{ animationDuration: '2.5s', animationDelay: '0.3s' }} />
            <div className="w-8 h-8 rounded-full border border-muted-foreground/30 flex items-center justify-center">
              <div className="w-2 h-2 rounded-full bg-muted-foreground/40 animate-pulse" />
            </div>
          </div>
          <p className="text-[10px] font-mono text-muted-foreground/50 tracking-widest uppercase">No Signal</p>
        </div>
      </div>
    </div>
  )
}

// ─── Chart Modal ──────────────────────────────────────────────────────────────
interface ChartModalProps {
  isOpen: boolean
  onClose: () => void
  title: string
  data: ChartPoint[]
  dataKey: string
  color: string
}
function ChartModal({ isOpen, onClose, title, data, dataKey, color }: ChartModalProps) {
  if (!isOpen) return null
  return (
    <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <Card className="w-full max-w-4xl border-border/50 bg-card/95 backdrop-blur-sm shadow-2xl">
        <CardHeader className="flex flex-row items-center justify-between border-b border-border/50">
          <div>
            <CardTitle>{title}</CardTitle>
            <CardDescription>Full view – Normalized value (0.0 – 1.0)</CardDescription>
          </div>
          <Button variant="ghost" size="icon" onClick={onClose} className="h-8 w-8 hover:bg-secondary/50">
            <X className="w-5 h-5" />
          </Button>
        </CardHeader>
        <CardContent className="pt-6">
          <ResponsiveContainer width="100%" height={500}>
            <LineChart data={data}>
              <CartesianGrid strokeDasharray="3 3" stroke="hsl(240, 10%, 18%)" />
              <XAxis dataKey="time" stroke="hsl(240, 5%, 75%)" />
              <YAxis stroke="hsl(240, 5%, 75%)" domain={[0, 1]} />
              <Tooltip
                contentStyle={{ backgroundColor: 'hsl(240, 10%, 11%)', border: '1px solid hsl(240, 10%, 18%)', borderRadius: '0.5rem' }}
                labelStyle={{ color: 'hsl(240, 5%, 95%)' }}
              />
              <Legend />
              <Line type="monotone" dataKey={dataKey} stroke={color} dot={false} strokeWidth={2} />
            </LineChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>
    </div>
  )
}

// ─── Bluetooth Modal ──────────────────────────────────────────────────────────
interface BluetoothModalProps {
  isOpen: boolean
  connectionState: ConnectionState
  errorMessage: string
  deviceName: string
  onConnect: () => void
  onDisconnect: () => void
  onClose: () => void
}
function BluetoothModal({ isOpen, connectionState, errorMessage, deviceName, onConnect, onDisconnect, onClose }: BluetoothModalProps) {
  if (!isOpen) return null
  const isWebSerialSupported = typeof navigator !== 'undefined' && 'serial' in navigator
  return (
    <div className="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <Card className="w-full max-w-md border-border/50 bg-card/95 backdrop-blur-sm shadow-2xl">
        <CardHeader className="flex flex-row items-center justify-between border-b border-border/50">
          <div>
            <CardTitle className="flex items-center gap-2"><Bluetooth className="w-5 h-5 text-blue-400" />Device Connection</CardTitle>
            <CardDescription>HC-05 Bluetooth Module</CardDescription>
          </div>
          <Button variant="ghost" size="icon" onClick={onClose} className="h-8 w-8 hover:bg-secondary/50"><X className="w-5 h-5" /></Button>
        </CardHeader>
        <CardContent className="pt-6 space-y-5">
          {!isWebSerialSupported && (
            <div className="rounded-lg border border-amber-700 bg-amber-900/30 p-4 text-sm text-amber-200">
              <p className="font-semibold mb-1">⚠ Unsupported Browser</p>
              <p>Web Serial API requires <strong>Chrome 117+</strong> or Edge on desktop.</p>
            </div>
          )}
          {connectionState === 'disconnected' && (
            <div className="rounded-lg border border-border/50 bg-secondary/20 p-4 space-y-2 text-sm text-muted-foreground">
              <p className="font-semibold text-foreground">⚡ Before connecting:</p>
              <ol className="list-decimal list-inside space-y-1">
                <li>Power on the HC-05 (LED blinks fast)</li>
                <li>Pair it via <strong>Windows Bluetooth Settings</strong> — PIN: <code className="bg-secondary px-1 rounded">1234</code></li>
                <li>Click <strong>Connect Device</strong> and pick the COM port</li>
              </ol>
            </div>
          )}
          <div className="flex items-center justify-center py-6">
            {connectionState === 'disconnected' && (
              <div className="text-center space-y-2"><BluetoothOff className="w-14 h-14 text-muted-foreground mx-auto" /><p className="text-muted-foreground text-sm">No device connected</p></div>
            )}
            {connectionState === 'scanning' && (
              <div className="text-center space-y-3"><Radio className="w-14 h-14 text-blue-400 mx-auto animate-pulse" /><p className="text-blue-400 font-medium">Select your HC-05 port…</p><p className="text-muted-foreground text-xs">Choose the COM port paired to HC-05</p></div>
            )}
            {connectionState === 'connecting' && (
              <div className="text-center space-y-3"><Loader2 className="w-14 h-14 text-blue-400 mx-auto animate-spin" /><p className="text-blue-400 font-medium">Opening serial port…</p></div>
            )}
            {connectionState === 'connected' && (
              <div className="text-center space-y-3">
                <CheckCircle2 className="w-14 h-14 text-green-400 mx-auto" />
                <p className="text-green-400 font-medium text-lg">Connected!</p>
                <p className="text-muted-foreground text-sm">Device: <span className="text-foreground font-mono">{deviceName || 'HC-05'}</span></p>
                <p className="text-muted-foreground text-xs">Receiving live sensor data at 9600 baud</p>
              </div>
            )}
            {connectionState === 'error' && (
              <div className="text-center space-y-3"><BluetoothOff className="w-14 h-14 text-red-400 mx-auto" /><p className="text-red-400 font-medium">Connection Failed</p><p className="text-muted-foreground text-xs max-w-xs">{errorMessage}</p></div>
            )}
          </div>
          <div className="flex gap-3">
            {(connectionState === 'disconnected' || connectionState === 'error') && (
              <Button onClick={onConnect} disabled={!isWebSerialSupported} className="flex-1 bg-blue-600 hover:bg-blue-500 text-white gap-2">
                <Bluetooth className="w-4 h-4" />Connect Device
              </Button>
            )}
            {connectionState === 'connected' && (
              <Button onClick={onDisconnect} variant="destructive" className="flex-1 gap-2">
                <BluetoothOff className="w-4 h-4" />Disconnect
              </Button>
            )}
            <Button variant="outline" onClick={onClose} className="flex-1 border-border/50">{connectionState === 'connected' ? 'Close' : 'Cancel'}</Button>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}

// ─── Helpers ──────────────────────────────────────────────────────────────────
const RISK_STYLES: Record<RiskLevel, { bg: string; text: string; badge: string; icon: string }> = {
  LOW:    { bg: 'bg-green-900 text-green-100',   text: 'Area is stable. Conditions normal.',              badge: 'bg-green-900 text-green-100',  icon: 'text-green-400' },
  MEDIUM: { bg: 'bg-orange-900 text-orange-100', text: 'Moderate movement detected. Continue monitoring.', badge: 'bg-orange-900 text-orange-100', icon: 'text-orange-400' },
  HIGH:   { bg: 'bg-red-900 text-red-100',       text: 'High landslide risk! Immediate action required.', badge: 'bg-red-900 text-red-100',    icon: 'text-red-400' },
}

function nowTimeStr() {
  const t = new Date()
  return `${String(t.getHours()).padStart(2, '0')}:${String(t.getMinutes()).padStart(2, '0')}:${String(t.getSeconds()).padStart(2, '0')}`
}

// ─── Main Dashboard ───────────────────────────────────────────────────────────
export default function Dashboard() {
  const [connectionState, setConnectionState] = useState<ConnectionState>('disconnected')
  const [errorMessage, setErrorMessage] = useState('')
  const [deviceName, setDeviceName] = useState('')
  const [bluetoothModalOpen, setBluetoothModalOpen] = useState(false)
  const [expandedChart, setExpandedChart] = useState<string | null>(null)

  // ── Current sensor state ──────────────────────────────────────────────────
  const [latest, setLatest] = useState<SensorReading>({
    moistureRaw: 0, tilt: 0, vibrationRaw: 0,
    Mn: 0, Tn: 0, Vn: 0, R: 0, level: 'LOW',
  })
  const [chartData, setChartData] = useState<ChartPoint[]>([])
  const [activityLog, setActivityLog] = useState<ActivityEntry[]>([])
  const [lastUpdate, setLastUpdate] = useState('--:--:--')

  // Web Serial API refs
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const portRef = useRef<any>(null)
  const readerRef = useRef<ReadableStreamDefaultReader | null>(null)
  const readingRef = useRef(false)
  const lineBufferRef = useRef('')

  const isConnected = connectionState === 'connected'

  // ── ML inference state ────────────────────────────────────────────────────
  const [mlReady, setMlReady]     = useState(false)
  const [mlLoading, setMlLoading] = useState(true)
  const [mlPred, setMlPred]       = useState<MLPrediction | null>(null)

  // Load model weights once on mount
  useEffect(() => {
    loadModel()
      .then(() => { setMlReady(true); setMlLoading(false) })
      .catch(() => { setMlLoading(false) })
  }, [])

  // ── Apply a new sensor reading to state ───────────────────────────────────
  const applyReading = useCallback((r: SensorReading) => {
    const time = nowTimeStr()
    setLatest(r)
    setLastUpdate(time)
    setChartData(prev => {
      const point: ChartPoint = { time, Mn: r.Mn, Tn: r.Tn, Vn: r.Vn }
      const next = [...prev, point]
      return next.length > 60 ? next.slice(-60) : next
    })
    setActivityLog(prev => {
      const entry: ActivityEntry = { ...r, time }
      return [entry, ...prev].slice(0, 20)
    })
  }, [])

  // ── Run ML prediction whenever sensor values or model readiness change ────
  useEffect(() => {
    if (!isConnected || !mlReady || !isModelLoaded()) {
      setMlPred(null)
      return
    }
    try {
      setMlPred(predictRisk(latest.Mn, latest.Tn, latest.Vn))
    } catch (_) {
      setMlPred(null)
    }
  }, [latest, isConnected, mlReady])

  // ── Reset to empty state when disconnected ───────────────────────────────
  useEffect(() => {
    if (isConnected) return
    setChartData([])
    setActivityLog([])
    setLatest({ moistureRaw: 0, tilt: 0, vibrationRaw: 0, Mn: 0, Tn: 0, Vn: 0, R: 0, level: 'LOW' })
    setLastUpdate('--:--:--')
  }, [isConnected])

  // ── Serial reading loop ───────────────────────────────────────────────────
  const startReadLoop = useCallback(async (port: any) => {
    const decoder = new TextDecoder()
    readingRef.current = true
    lineBufferRef.current = ''

    try {
      while (readingRef.current && port.readable) {
        const reader = port.readable.getReader()
        readerRef.current = reader
        try {
          while (true) {
            const { value, done } = await reader.read()
            if (done) break
            const chunk = decoder.decode(value)
            lineBufferRef.current += chunk

            const lines = lineBufferRef.current.split('\n')
            lineBufferRef.current = lines.pop() ?? ''

            for (const rawLine of lines) {
              const line = rawLine.trim()
              if (!line) continue

              // ── Console prints ──
              console.log('[HC-05 RAW]', line)

              const parsed = parseArduinoLine(line)
              if (!parsed) {
                console.warn('[HC-05] Could not parse line:', line)
                continue
              }
              console.log('[HC-05 PARSED]', parsed)
              applyReading(parsed)
            }
          }
        } finally {
          reader.releaseLock()
        }
      }
    } catch (err) {
      if (readingRef.current) {
        console.error('HC-05 read error:', err)
        setConnectionState('error')
        setErrorMessage('Connection lost. Device may have been turned off or moved out of range.')
      }
    }
  }, [applyReading])

  // ── Connect ───────────────────────────────────────────────────────────────
  const handleConnect = useCallback(async () => {
    if (!('serial' in navigator)) {
      setErrorMessage('Web Serial API is not supported. Use Chrome 117+ or Edge on desktop.')
      setConnectionState('error')
      return
    }
    setConnectionState('scanning')
    setErrorMessage('')
    try {
      const port = await (navigator as any).serial.requestPort()
      setConnectionState('connecting')
      setDeviceName('HC-05')
      // HC-05 default baud rate 9600 matches Arduino Serial.begin(9600)
      await port.open({ baudRate: 9600, dataBits: 8, stopBits: 1, parity: 'none' })
      portRef.current = port
      setConnectionState('connected')
      setBluetoothModalOpen(false)
      startReadLoop(port)
    } catch (err: any) {
      if (err?.name === 'NotFoundError' || err?.message?.includes('No port selected')) {
        setConnectionState('disconnected')
      } else {
        setErrorMessage(err?.message ?? 'Failed to open port. Ensure HC-05 is paired and not in use.')
        setConnectionState('error')
      }
    }
  }, [startReadLoop])

  // ── Disconnect ────────────────────────────────────────────────────────────
  const handleDisconnect = useCallback(async () => {
    readingRef.current = false
    try { readerRef.current?.cancel() } catch (_) {}
    readerRef.current = null
    try { await portRef.current?.close() } catch (_) {}
    portRef.current = null
    setConnectionState('disconnected')
    setDeviceName('')
  }, [])

  useEffect(() => {
    return () => {
      readingRef.current = false
      readerRef.current?.cancel().catch(() => {})
      portRef.current?.close().catch(() => {})
    }
  }, [])

  // ── Derived display values ────────────────────────────────────────────────
  const { Mn, Tn, Vn, R, level, moistureRaw, tilt, vibrationRaw } = latest
  const riskStyle = RISK_STYLES[level]

  // ── Render ────────────────────────────────────────────────────────────────
  return (
    <div className="min-h-screen bg-background text-foreground">
      {/* Header */}
      <header className="border-b border-border bg-card/50 backdrop-blur-sm sticky top-0 z-10">
        <div className="max-w-7xl mx-auto px-6 py-6">
          <div className="flex items-start justify-between">
            <div>
              <h1 className="text-3xl font-bold text-foreground">TerraGuard™ – Landslide Risk Monitoring Dashboard</h1>
              <p className="text-muted-foreground mt-1">Real-time ground condition monitoring and prediction</p>
            </div>
            <Badge
              variant="outline"
              className={`cursor-pointer transition-colors text-sm ${isConnected ? 'bg-green-900/50 border-green-700 text-green-300 hover:bg-green-900' : 'bg-secondary/50 hover:bg-secondary'}`}
              onClick={() => setBluetoothModalOpen(true)}
            >
              <span className={`inline-block w-2 h-2 rounded-full mr-1.5 ${isConnected ? 'bg-green-400 animate-pulse' : 'bg-red-400'}`} />
              {isConnected ? `Connected — ${deviceName}` : 'Not Connected'}
            </Badge>
          </div>
        </div>
      </header>

      <main className="max-w-7xl mx-auto px-6 py-8">
        {/* ── Device Connection Panel ──────────────────────────────────────── */}
        <Card className="mb-8 border-border/50 bg-card/50 backdrop-blur-sm">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Bluetooth className={`w-5 h-5 ${isConnected ? 'text-blue-400' : 'text-muted-foreground'}`} />
              Device Connection
            </CardTitle>
            <CardDescription>HC-05 Bluetooth Module Status</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
              <div>
                <p className="text-sm text-muted-foreground">Connection Status</p>
                <div className="flex items-center gap-2 mt-2">
                  <div className={`w-3 h-3 rounded-full transition-all ${
                    isConnected ? 'bg-green-500 animate-pulse'
                    : connectionState === 'error' ? 'bg-red-500'
                    : connectionState === 'scanning' || connectionState === 'connecting' ? 'bg-blue-500 animate-pulse'
                    : 'bg-red-500'
                  }`} />
                  <span className="font-semibold">
                    {connectionState === 'disconnected' ? 'Disconnected'
                     : connectionState === 'scanning' ? 'Scanning…'
                     : connectionState === 'connecting' ? 'Connecting…'
                     : connectionState === 'connected' ? 'Connected'
                     : 'Error'}
                  </span>
                </div>
              </div>
              <div>
                <p className="text-sm text-muted-foreground">Device</p>
                <p className="font-semibold mt-2">{deviceName || 'HC-05'}</p>
              </div>
              <div>
                <p className="text-sm text-muted-foreground">Last Data Received</p>
                <p className="font-semibold mt-2 font-mono text-sm">{lastUpdate}</p>
              </div>
              <div>
                <p className="text-sm text-muted-foreground">Risk Score (R)</p>
                <p className="font-semibold mt-2 font-mono text-lg">
                  <span className={level === 'HIGH' ? 'text-red-400' : level === 'MEDIUM' ? 'text-orange-400' : 'text-green-400'}>
                    {R.toFixed(2)}
                  </span>
                  <span className="text-muted-foreground text-sm ml-1">/ 1.00</span>
                </p>
              </div>
            </div>

            {!isConnected && connectionState !== 'scanning' && connectionState !== 'connecting' && (
              <div className="mt-4 text-xs text-muted-foreground rounded-md border border-border/40 bg-secondary/20 px-4 py-3">
                <span className="font-semibold text-foreground">How to connect HC-05:</span> Pair via Windows Bluetooth Settings (PIN: <code className="bg-secondary px-1 rounded">1234</code>), then click Connect Device and pick the matching COM port.
              </div>
            )}

            <div className="mt-6 flex gap-3">
              {!isConnected ? (
                <Button
                  onClick={() => setBluetoothModalOpen(true)}
                  className="w-full md:w-auto gap-2 bg-blue-600 hover:bg-blue-500 text-white"
                  disabled={connectionState === 'scanning' || connectionState === 'connecting'}
                >
                  {(connectionState === 'scanning' || connectionState === 'connecting')
                    ? <Loader2 className="w-4 h-4 animate-spin" />
                    : <Bluetooth className="w-4 h-4" />}
                  {connectionState === 'scanning' ? 'Scanning…' : connectionState === 'connecting' ? 'Connecting…' : 'Connect Device'}
                </Button>
              ) : (
                <Button onClick={handleDisconnect} variant="destructive" className="w-full md:w-auto gap-2">
                  <BluetoothOff className="w-4 h-4" />Disconnect Device
                </Button>
              )}
            </div>
          </CardContent>
        </Card>

        {/* ── Sensor Cards ─────────────────────────────────────────────────── */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          {/* Soil Moisture */}
          <Card className="border-border/50 bg-card/50 backdrop-blur-sm">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Droplets className={`w-5 h-5 ${isConnected ? 'text-blue-400' : 'text-muted-foreground'}`} />Soil Moisture
              </CardTitle>
            </CardHeader>
            <CardContent>
              {isConnected ? (
                <>
                  <div className="flex items-end gap-2 mb-1">
                    <span className="text-5xl font-bold text-blue-400">{Math.round(Mn * 100)}</span>
                    <span className="text-xl text-blue-400 mb-1">%</span>
                  </div>
                  <p className="text-xs text-muted-foreground mb-3">
                    Raw ADC: <span className="font-mono text-foreground">{moistureRaw}</span>
                    &nbsp;·&nbsp; Normalized: <span className="font-mono text-foreground">{Mn.toFixed(2)}</span>
                  </p>
                  <div className="w-full bg-secondary/50 rounded-full h-3">
                    <div className="bg-gradient-to-r from-blue-500 to-blue-400 h-3 rounded-full transition-all duration-500" style={{ width: `${Mn * 100}%` }} />
                  </div>
                  <p className="text-sm text-muted-foreground mt-3">Mn = 0.40×Risk weight</p>
                </>
              ) : (
                <SensorAwaitingPlaceholder color="blue" label="Mn = 0.40×Risk weight" />
              )}
            </CardContent>
          </Card>

          {/* Vibration */}
          <Card className="border-border/50 bg-card/50 backdrop-blur-sm">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Zap className={`w-5 h-5 ${isConnected ? 'text-orange-400' : 'text-muted-foreground'}`} />Shock / Vibration
              </CardTitle>
            </CardHeader>
            <CardContent>
              {isConnected ? (
                <>
                  <div className="flex items-end gap-2 mb-1">
                    <span className="text-5xl font-bold text-orange-400">{Math.round(Vn * 100)}</span>
                    <span className="text-xl text-orange-400 mb-1">%</span>
                  </div>
                  <p className="text-xs text-muted-foreground mb-3">
                    Raw ADC: <span className="font-mono text-foreground">{vibrationRaw}</span>
                    &nbsp;·&nbsp; Normalized: <span className="font-mono text-foreground">{Vn.toFixed(2)}</span>
                  </p>
                  <div className="w-full bg-secondary/50 rounded-full h-3">
                    <div className="bg-gradient-to-r from-orange-500 to-orange-400 h-3 rounded-full transition-all duration-500" style={{ width: `${Vn * 100}%` }} />
                  </div>
                  <p className="text-sm text-muted-foreground mt-3">Vn = 0.25×Risk weight</p>
                </>
              ) : (
                <SensorAwaitingPlaceholder color="orange" label="Vn = 0.25×Risk weight" />
              )}
            </CardContent>
          </Card>

          {/* Tilt */}
          <Card className="border-border/50 bg-card/50 backdrop-blur-sm">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Activity className={`w-5 h-5 ${isConnected ? 'text-purple-400' : 'text-muted-foreground'}`} />Tilt / Movement
              </CardTitle>
            </CardHeader>
            <CardContent>
              {isConnected ? (
                <>
                  <div className="flex items-end gap-2 mb-1">
                    <span className="text-5xl font-bold text-purple-400">{tilt.toFixed(1)}</span>
                    <span className="text-xl text-purple-400 mb-1">°</span>
                  </div>
                  <p className="text-xs text-muted-foreground mb-3">
                    Normalized: <span className="font-mono text-foreground">{Tn.toFixed(2)}</span>
                    &nbsp;·&nbsp; T<sub>max</sub> = 45°
                  </p>
                  <div className="w-full bg-secondary/50 rounded-full h-3">
                    <div className="bg-gradient-to-r from-purple-500 to-purple-400 h-3 rounded-full transition-all duration-500" style={{ width: `${Tn * 100}%` }} />
                  </div>
                  <p className="text-sm text-muted-foreground mt-3">Tn = 0.35×Risk weight</p>
                </>
              ) : (
                <SensorAwaitingPlaceholder color="purple" label="Tn = 0.35×Risk weight" />
              )}
            </CardContent>
          </Card>
        </div>

        {/* ── Risk Level Banner ─────────────────────────────────────────────── */}
        {isConnected ? (
          <div className={`${riskStyle.bg} rounded-lg p-8 mb-8 border border-current/20 shadow-lg`}>
            <div className="flex items-start gap-4">
              <AlertTriangle className={`w-12 h-12 ${riskStyle.icon} flex-shrink-0 mt-1`} />
              <div className="flex-1">
                <div className="flex items-center gap-3 mb-2">
                  <h2 className="text-2xl font-bold">Risk Level: {level}</h2>
                  <span className="font-mono text-lg opacity-75">(R = {R.toFixed(2)})</span>
                </div>
                <p className="text-lg opacity-90">{riskStyle.text}</p>
                <p className="text-sm opacity-70 mt-2 font-mono">R = 0.40 × Mn + 0.35 × Tn + 0.25 × Vn = {(0.40 * Mn).toFixed(2)} + {(0.35 * Tn).toFixed(2)} + {(0.25 * Vn).toFixed(2)}</p>
              </div>
            </div>
          </div>
        ) : (
          <div className="rounded-lg p-8 mb-8 border border-border/30 bg-secondary/10 shadow-lg">
            <div className="flex items-start gap-4">
              <div className="relative flex-shrink-0 mt-1">
                <div className="w-12 h-12 rounded-full border-2 border-muted-foreground/30 flex items-center justify-center">
                  <div className="w-3 h-3 rounded-full bg-muted-foreground/50 animate-pulse" />
                </div>
                <div className="absolute inset-0 rounded-full border border-muted-foreground/20 animate-ping" />
              </div>
              <div className="flex-1">
                <div className="flex items-center gap-3 mb-2">
                  <h2 className="text-2xl font-bold text-muted-foreground">System Standby</h2>
                  <span className="text-xs font-mono px-2 py-0.5 rounded-full bg-secondary/50 text-muted-foreground border border-border/40">OFFLINE</span>
                </div>
                <p className="text-base text-muted-foreground opacity-80">No sensor data available. Connect your HC-05 device to begin risk assessment.</p>
                <p className="text-sm opacity-50 mt-2 font-mono">R = 0.40 × Mn + 0.35 × Tn + 0.25 × Vn</p>
              </div>
            </div>
          </div>
        )}

        {/* ── Sensor Trends (Normalized) ────────────────────────────────────── */}
        <div className="mb-8">
          <h2 className="text-xl font-semibold mb-1">Sensor Trends</h2>
          <p className="text-sm text-muted-foreground mb-4">Normalized values (0.0 – 1.0) · updated every 2 s</p>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            {[
              { key: 'Mn', label: 'Soil Moisture (Mn)', color: 'hsl(212, 100%, 50%)' },
              { key: 'Vn', label: 'Vibration (Vn)',     color: 'hsl(45, 85%, 55%)' },
              { key: 'Tn', label: 'Tilt (Tn)',           color: 'hsl(280, 70%, 60%)' },
            ].map(({ key, label, color }) => (
              <Card key={key} className="border-border/50 bg-card/50 backdrop-blur-sm flex flex-col">
                <CardHeader className="pb-3">
                  <div className="flex items-start justify-between">
                    <div className="flex-1">
                      <CardTitle className="text-base">{label}</CardTitle>
                      <CardDescription className="text-xs">{isConnected ? 'Last 60 readings' : 'Awaiting connection'}</CardDescription>
                    </div>
                    <Button variant="ghost" size="icon" onClick={() => setExpandedChart(key)} disabled={!isConnected} className="h-7 w-7 hover:bg-secondary/50 flex-shrink-0">
                      <Maximize2 className="w-4 h-4" />
                    </Button>
                  </div>
                </CardHeader>
                <CardContent className="flex-1 pb-3">
                  {isConnected ? (
                    <ResponsiveContainer width="100%" height={180}>
                      <LineChart data={chartData}>
                        <CartesianGrid strokeDasharray="3 3" stroke="hsl(240, 10%, 18%)" />
                        <XAxis dataKey="time" stroke="hsl(240, 5%, 75%)" tick={{ fontSize: 9 }} tickCount={5} />
                        <YAxis stroke="hsl(240, 5%, 75%)" domain={[0, 1]} tick={{ fontSize: 11 }} />
                        <Tooltip
                          contentStyle={{ backgroundColor: 'hsl(240, 10%, 11%)', border: '1px solid hsl(240, 10%, 18%)', borderRadius: '0.5rem', fontSize: '12px' }}
                          labelStyle={{ color: 'hsl(240, 5%, 95%)' }}
                        />
                        <Line type="monotone" dataKey={key} stroke={color} dot={false} strokeWidth={2} />
                      </LineChart>
                    </ResponsiveContainer>
                  ) : (
                    <ChartAwaitingPlaceholder />
                  )}
                </CardContent>
              </Card>
            ))}
          </div>
        </div>

        {/* Chart Modals */}
        {[
          { key: 'Mn', title: 'Soil Moisture (Mn) – Normalized', color: 'hsl(212, 100%, 50%)' },
          { key: 'Vn', title: 'Vibration (Vn) – Normalized',     color: 'hsl(45, 85%, 55%)' },
          { key: 'Tn', title: 'Tilt (Tn) – Normalized',           color: 'hsl(280, 70%, 60%)' },
        ].map(({ key, title, color }) => (
          <ChartModal key={key} isOpen={expandedChart === key} onClose={() => setExpandedChart(null)} title={title} data={chartData} dataKey={key} color={color} />
        ))}

        {/* ── Activity Log ─────────────────────────────────────────────────── */}
        <Card className="border-border/50 bg-card/50 backdrop-blur-sm mb-8">
          <CardHeader>
            <CardTitle>Activity Log</CardTitle>
            <CardDescription>Live sensor readings — newest first</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="overflow-x-auto">
              <Table>
                <TableHeader>
                  <TableRow className="border-border/50 hover:bg-secondary/30">
                    <TableHead>Time</TableHead>
                    <TableHead>Moisture Raw</TableHead>
                    <TableHead>Mn</TableHead>
                    <TableHead>Tilt (°)</TableHead>
                    <TableHead>Tn</TableHead>
                    <TableHead>Vibration Raw</TableHead>
                    <TableHead>Vn</TableHead>
                    <TableHead>R</TableHead>
                    <TableHead>Level</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {activityLog.length > 0 ? activityLog.map((entry, i) => (
                    <TableRow key={i} className="border-border/50 hover:bg-secondary/30">
                      <TableCell className="font-mono text-xs">{entry.time}</TableCell>
                      <TableCell>{entry.moistureRaw}</TableCell>
                      <TableCell className="font-mono">{entry.Mn.toFixed(2)}</TableCell>
                      <TableCell>{entry.tilt.toFixed(2)}°</TableCell>
                      <TableCell className="font-mono">{entry.Tn.toFixed(2)}</TableCell>
                      <TableCell>{entry.vibrationRaw}</TableCell>
                      <TableCell className="font-mono">{entry.Vn.toFixed(2)}</TableCell>
                      <TableCell className="font-mono font-bold">{entry.R.toFixed(2)}</TableCell>
                      <TableCell>
                        <Badge variant="secondary" className={RISK_STYLES[entry.level].badge}>
                          {entry.level}
                        </Badge>
                      </TableCell>
                    </TableRow>
                  )) : (
                    <TableRow>
                      <TableCell colSpan={9} className="py-12">
                        <div className="flex flex-col items-center gap-3 text-muted-foreground">
                          <div className="relative">
                            <Bluetooth className="w-8 h-8 opacity-30" />
                            <div className="absolute -top-1 -right-1 w-3 h-3 rounded-full bg-red-500/70" />
                          </div>
                          <p className="text-sm font-medium">No live data</p>
                          <p className="text-xs opacity-60">Connect your HC-05 device to start receiving sensor readings</p>
                        </div>
                      </TableCell>
                    </TableRow>
                  )}
                </TableBody>
              </Table>
            </div>
          </CardContent>
        </Card>

        {/* ── AI Risk Prediction ─────────────────────────────────────────────── */}
        <Card className="border-border/50 bg-card/50 backdrop-blur-sm mb-8">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Brain className={`w-5 h-5 ${isConnected && mlReady ? 'text-violet-400' : 'text-muted-foreground'}`} />
              AI Risk Prediction
              {mlReady && (
                <Badge variant="outline" className="ml-2 text-[10px] font-mono border-violet-700/50 text-violet-400 bg-violet-900/20">
                  MLP {mlPred?.meta.modelVersion ?? ''}
                </Badge>
              )}
            </CardTitle>
            <CardDescription>Neural network landslide probability — 3-layer MLP trained on {mlPred?.meta.training.n_samples?.toLocaleString() ?? '10 000'} samples</CardDescription>
          </CardHeader>
          <CardContent>
            {/* ── Disconnected / model loading state ── */}
            {(!isConnected || !mlReady) ? (
              <div className="py-10 flex flex-col items-center gap-4 text-muted-foreground">
                <div className="relative">
                  <div className="absolute inset-0 rounded-full border border-violet-500/20 animate-ping" style={{ animationDuration: '2s' }} />
                  <div className="w-14 h-14 rounded-full border border-violet-500/30 flex items-center justify-center">
                    {mlLoading
                      ? <Loader2 className="w-6 h-6 animate-spin text-violet-400/60" />
                      : <Brain className="w-6 h-6 text-muted-foreground/40" />
                    }
                  </div>
                </div>
                <div className="text-center">
                  <p className="text-sm font-medium">
                    {mlLoading ? 'Loading neural network…' : 'Awaiting sensor connection'}
                  </p>
                  <p className="text-xs opacity-50 mt-1">
                    {mlLoading ? 'Fetching model weights from /model_weights.json' : 'Connect HC-05 to enable live ML predictions'}
                  </p>
                </div>
              </div>
            ) : mlPred === null ? (
              <div className="py-8 text-center text-muted-foreground text-sm">Waiting for first reading…</div>
            ) : (
              <div className="space-y-6">
                {/* ── Top row: Gauge + Contributions ───────────── */}
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">

                  {/* Arc Gauge */}
                  <div className="flex flex-col items-center gap-3">
                    <p className="text-xs font-semibold uppercase tracking-widest text-muted-foreground">ML Risk Probability</p>
                    <div className="relative w-48 h-28 select-none">
                      {/* SVG arc gauge */}
                      <svg viewBox="0 0 200 110" className="w-full h-full">
                        {/* Background arc */}
                        <path
                          d="M 20 100 A 80 80 0 0 1 180 100"
                          fill="none" stroke="hsl(240,10%,18%)" strokeWidth="16" strokeLinecap="round"
                        />
                        {/* Value arc — strokeDasharray trick for partial fill */}
                        {(() => {
                          const score = mlPred.riskScore
                          const arcLen = 251.2  // π × r (r=80, half-circle)
                          const filled = score * arcLen
                          const color = score >= 0.6 ? 'hsl(0,72%,51%)' : score >= 0.3 ? 'hsl(38,92%,50%)' : 'hsl(142,71%,45%)'
                          return (
                            <path
                              d="M 20 100 A 80 80 0 0 1 180 100"
                              fill="none" stroke={color} strokeWidth="16" strokeLinecap="round"
                              strokeDasharray={`${filled} ${arcLen - filled + 0.1}`}
                              strokeDashoffset="0"
                              style={{ transition: 'stroke-dasharray 0.6s ease, stroke 0.4s ease' }}
                            />
                          )
                        })()}
                        {/* Needle */}
                        {(() => {
                          const angle = mlPred.riskScore * 180 - 180  // -180° to 0°
                          const rad = (angle * Math.PI) / 180
                          const nx = 100 + 65 * Math.cos(rad)
                          const ny = 100 + 65 * Math.sin(rad)
                          return <line x1="100" y1="100" x2={nx.toFixed(1)} y2={ny.toFixed(1)}
                            stroke="hsl(240,5%,85%)" strokeWidth="2.5" strokeLinecap="round" />
                        })()}
                        {/* Center dot */}
                        <circle cx="100" cy="100" r="5" fill="hsl(240,5%,85%)" />
                        {/* Score text */}
                        <text x="100" y="88" textAnchor="middle" fill="hsl(240,5%,95%)" fontSize="20" fontWeight="bold" fontFamily="monospace">
                          {(mlPred.riskScore * 100).toFixed(1)}%
                        </text>
                        {/* Labels */}
                        <text x="18" y="115" fill="hsl(142,71%,45%)" fontSize="9" fontFamily="monospace">LOW</text>
                        <text x="82" y="25" fill="hsl(38,92%,50%)" fontSize="9" fontFamily="monospace">MED</text>
                        <text x="166" y="115" fill="hsl(0,72%,51%)" fontSize="9" fontFamily="monospace">HIGH</text>
                      </svg>
                      {/* Class badge below gauge */}
                      <div className="absolute bottom-0 left-0 right-0 flex justify-center">
                        <span className={`text-xs font-bold px-3 py-0.5 rounded-full ${
                          mlPred.riskClass === 'HIGH'   ? 'bg-red-900/60 text-red-200' :
                          mlPred.riskClass === 'MEDIUM' ? 'bg-orange-900/60 text-orange-200' :
                                                          'bg-green-900/60 text-green-200'
                        }`}>{mlPred.riskClass}</span>
                      </div>
                    </div>

                    {/* Confidence indicator */}
                    <div className="w-full max-w-[200px] space-y-1">
                      <div className="flex justify-between text-[10px] text-muted-foreground">
                        <span>Prediction Confidence</span>
                        <span className="font-mono">{(mlPred.confidence * 100).toFixed(0)}%</span>
                      </div>
                      <div className="w-full bg-secondary/50 rounded-full h-1.5">
                        <div
                          className="bg-violet-500 h-1.5 rounded-full transition-all duration-500"
                          style={{ width: `${mlPred.confidence * 100}%` }}
                        />
                      </div>
                      <p className="text-[10px] text-muted-foreground text-right">
                        {mlPred.confidence >= 0.7 ? '★ High' : mlPred.confidence >= 0.4 ? '◐ Moderate' : '○ Low'} confidence
                      </p>
                    </div>
                  </div>

                  {/* Factor Contributions */}
                  <div className="space-y-4">
                    <div className="flex items-center justify-between">
                      <p className="text-xs font-semibold uppercase tracking-widest text-muted-foreground">Feature Attribution</p>
                      <span className="text-[10px] text-muted-foreground/60 font-mono">
                        {(mlPred.contributions.moisture + mlPred.contributions.tilt + mlPred.contributions.vibration) > 1e-6
                          ? 'input × ∇ risk'
                          : '|∇ risk| sensitivity'}
                      </span>
                    </div>
                    {(() => {
                      const { moisture, tilt, vibration } = mlPred.contributions
                      const allZero = moisture === 0 && tilt === 0 && vibration === 0
                      if (allZero) {
                        return (
                          <div className="flex items-center gap-2 py-3 px-3 rounded-lg bg-green-900/20 border border-green-800/30 text-green-300/70">
                            <span className="text-base">✓</span>
                            <p className="text-xs">All sensors at baseline — no active risk factors</p>
                          </div>
                        )
                      }
                      return (
                        <>
                          {([
                            { label: 'Soil Moisture', color: 'bg-blue-500',   value: moisture },
                            { label: 'Tilt / Slope',  color: 'bg-purple-500', value: tilt },
                            { label: 'Vibration',     color: 'bg-orange-500', value: vibration },
                          ]).map(({ label, color, value }) => (
                            <div key={label} className="space-y-1">
                              <div className="flex justify-between text-xs text-muted-foreground">
                                <span>{label}</span>
                                <span className="font-mono">{(value * 100).toFixed(1)}%</span>
                              </div>
                              <div className="w-full bg-secondary/50 rounded-full h-2.5">
                                <div
                                  className={`${color} h-2.5 rounded-full transition-all duration-700`}
                                  style={{ width: `${value * 100}%` }}
                                />
                              </div>
                            </div>
                          ))}
                        </>
                      )
                    })()}

                    {/* ML vs Linear Formula comparison */}
                    <div className="mt-4 rounded-lg border border-border/40 bg-secondary/20 p-3 space-y-2">
                      <p className="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground">ML vs Formula Comparison</p>
                      <div className="grid grid-cols-2 gap-2 text-xs">
                        <div>
                          <p className="text-muted-foreground text-[10px]">ML Score</p>
                          <p className={`font-mono font-bold ${
                            mlPred.riskClass === 'HIGH' ? 'text-red-400' : mlPred.riskClass === 'MEDIUM' ? 'text-orange-400' : 'text-green-400'
                          }`}>{mlPred.riskScore.toFixed(4)}</p>
                        </div>
                        <div>
                          <p className="text-muted-foreground text-[10px]">Linear Formula</p>
                          <p className="font-mono text-muted-foreground">{mlPred.linearScore.toFixed(4)}</p>
                        </div>
                      </div>
                      <div className="flex items-center gap-1.5 pt-1 border-t border-border/30">
                        <span className="text-[10px] text-muted-foreground">Delta:</span>
                        <span className={`text-xs font-mono font-semibold ${
                          mlPred.delta > 0.02 ? 'text-red-400' : mlPred.delta < -0.02 ? 'text-green-400' : 'text-muted-foreground'
                        }`}>
                          {mlPred.delta >= 0 ? '+' : ''}{mlPred.delta.toFixed(4)}
                        </span>
                        <span className="text-[10px] text-muted-foreground ml-1">
                          {Math.abs(mlPred.delta) > 0.02
                            ? mlPred.delta > 0 ? '↑ ML detects higher non-linear risk' : '↓ ML sees lower actual risk'
                            : '≈ Models agree'}
                        </span>
                      </div>
                    </div>
                  </div>
                </div>

                {/* ── Model metadata row ─────────────────────────────────── */}
                <div className="rounded-lg border border-border/30 bg-secondary/10 px-4 py-3 grid grid-cols-2 md:grid-cols-4 gap-3 text-xs text-muted-foreground">
                  <div>
                    <p className="font-semibold text-foreground/70">Architecture</p>
                    <p className="font-mono">MLP 3→32→16→1</p>
                  </div>
                  <div>
                    <p className="font-semibold text-foreground/70">Training R²</p>
                    <p className="font-mono text-green-400">{mlPred.meta.training.r2_val?.toFixed(4) ?? '—'}</p>
                  </div>
                  <div>
                    <p className="font-semibold text-foreground/70">MAE</p>
                    <p className="font-mono">{mlPred.meta.training.mae_val?.toFixed(4) ?? '—'}</p>
                  </div>
                  <div>
                    <p className="font-semibold text-foreground/70">Samples</p>
                    <p className="font-mono">{mlPred.meta.training.n_samples?.toLocaleString() ?? '—'}</p>
                  </div>
                </div>
              </div>
            )}
          </CardContent>
        </Card>

        {/* ── System Alerts ────────────────────────────────────────────────── */}
        <Card className="border-border/50 bg-card/50 backdrop-blur-sm">
          <CardHeader>
            <CardTitle>System Alerts</CardTitle>
            <CardDescription>Active danger notifications</CardDescription>
          </CardHeader>
          <CardContent>
            {level === 'LOW' ? (
              <div className="py-8 text-center">
                <div className="inline-block px-6 py-3 rounded-lg bg-green-900/30 text-green-100 border border-green-800">
                  ✓ No active danger alerts
                </div>
                <p className="text-sm text-muted-foreground mt-4">Alert panel will display in red when danger is detected</p>
              </div>
            ) : (
              <div className={`py-8 text-center`}>
                <div className={`inline-block px-6 py-4 rounded-lg border ${level === 'HIGH' ? 'bg-red-900/50 text-red-100 border-red-700' : 'bg-orange-900/50 text-orange-100 border-orange-700'}`}>
                  <p className="text-lg font-bold mb-1">
                    {level === 'HIGH' ? '🚨 HIGH RISK DETECTED' : '⚠️ MEDIUM RISK DETECTED'}
                  </p>
                  <p className="text-sm">{riskStyle.text}</p>
                  <p className="text-xs mt-2 font-mono opacity-75">Risk Score: {R.toFixed(2)}</p>
                </div>
              </div>
            )}
          </CardContent>
        </Card>
      </main>

      {/* Bluetooth Modal */}
      <BluetoothModal
        isOpen={bluetoothModalOpen}
        connectionState={connectionState}
        errorMessage={errorMessage}
        deviceName={deviceName}
        onConnect={handleConnect}
        onDisconnect={handleDisconnect}
        onClose={() => setBluetoothModalOpen(false)}
      />
    </div>
  )
}
