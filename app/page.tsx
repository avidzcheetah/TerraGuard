'use client'

import { useState, useEffect } from 'react'
import { AlertTriangle, Bluetooth, Zap, Activity, Droplets, TrendingUp, Maximize2, X } from 'lucide-react'
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'

// Helper function to generate real-time data
const generateRealTimeData = () => {
  const now = new Date()
  const data = []
  
  // Generate data for the last 60 minutes (one data point per minute)
  for (let i = 60; i >= 0; i--) {
    const time = new Date(now.getTime() - i * 60 * 1000)
    const minutes = String(time.getMinutes()).padStart(2, '0')
    const hours = String(time.getHours()).padStart(2, '0')
    const timeStr = `${hours}:${minutes}`
    
    // Simulate realistic sensor values with some variation
    const moistureBase = 60 + Math.sin(i / 10) * 15 + Math.random() * 5
    const shockBase = 2 + Math.cos(i / 15) * 1 + Math.random() * 0.8
    const tiltBase = 1 + Math.sin(i / 20) * 1 + Math.random() * 0.5
    
    data.push({
      time: timeStr,
      moisture: Math.max(40, Math.min(90, Math.round(moistureBase * 10) / 10)),
      shock: Math.max(0.5, Math.min(4, Math.round(shockBase * 10) / 10)),
      tilt: Math.max(0, Math.min(3, Math.round(tiltBase * 10) / 10)),
    })
  }
  
  return data
}

const generateActivityLog = () => {
  const now = new Date()
  const log = []
  
  // Generate activity log for recent minutes
  for (let i = 0; i < 5; i++) {
    const time = new Date(now.getTime() - i * 3 * 60 * 1000)
    const minutes = String(time.getMinutes()).padStart(2, '0')
    const hours = String(time.getHours()).padStart(2, '0')
    const timeStr = `${hours}:${minutes}`
    
    const moisture = 55 + Math.random() * 30
    const shock = 1.5 + Math.random() * 2
    const tilt = 0.8 + Math.random() * 1.5
    
    let risk = 'LOW'
    if (tilt > 2.0 || shock > 2.8) risk = 'HIGH'
    else if (tilt > 1.5 || shock > 2.3 || moisture > 75) risk = 'MEDIUM'
    
    log.push({
      time: timeStr,
      moisture: Math.round(moisture),
      shock: Math.round(shock * 10) / 10,
      tilt: Math.round(tilt * 10) / 10,
      risk,
    })
  }
  
  return log
}

function ChartModal({ isOpen, onClose, title, data, dataKey, color }) {
  if (!isOpen) return null

  return (
    <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <Card className="w-full max-w-4xl border-border/50 bg-card/95 backdrop-blur-sm shadow-2xl">
        <CardHeader className="flex flex-row items-center justify-between border-b border-border/50">
          <div>
            <CardTitle>{title}</CardTitle>
            <CardDescription>Full view - Real-time monitoring data</CardDescription>
          </div>
          <Button
            variant="ghost"
            size="icon"
            onClick={onClose}
            className="h-8 w-8 hover:bg-secondary/50"
          >
            <X className="w-5 h-5" />
          </Button>
        </CardHeader>
        <CardContent className="pt-6">
          <ResponsiveContainer width="100%" height={500}>
            <LineChart data={data}>
              <CartesianGrid strokeDasharray="3 3" stroke="hsl(240, 10%, 18%)" />
              <XAxis dataKey="time" stroke="hsl(240, 5%, 75%)" />
              <YAxis stroke="hsl(240, 5%, 75%)" />
              <Tooltip
                contentStyle={{
                  backgroundColor: 'hsl(240, 10%, 11%)',
                  border: '1px solid hsl(240, 10%, 18%)',
                  borderRadius: '0.5rem',
                }}
                labelStyle={{ color: 'hsl(240, 5%, 95%)' }}
              />
              <Legend />
              <Line type="monotone" dataKey={dataKey} stroke={color} />
            </LineChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>
    </div>
  )
}

export default function Dashboard() {
  const [isConnected, setIsConnected] = useState(false)
  const [expandedChart, setExpandedChart] = useState(null)
  const [chartData, setChartData] = useState([])
  const [activityLog, setActivityLog] = useState([])
  const [currentMoisture, setCurrentMoisture] = useState(0)
  const [currentShock, setCurrentShock] = useState(0)
  const [currentTilt, setCurrentTilt] = useState(0)
  const [lastUpdate, setLastUpdate] = useState(new Date().toLocaleTimeString())

  // Initialize and update data every second
  useEffect(() => {
    const updateData = () => {
      const data = generateRealTimeData()
      setChartData(data)
      
      // Get the latest reading (last item in array)
      const latestReading = data[data.length - 1]
      if (latestReading) {
        setCurrentMoisture(latestReading.moisture)
        setCurrentShock(latestReading.shock)
        setCurrentTilt(latestReading.tilt)
      }
      
      const log = generateActivityLog()
      setActivityLog(log)
      setLastUpdate(new Date().toLocaleTimeString())
    }

    // Initial update
    updateData()

    // Update every 1 second
    const interval = setInterval(updateData, 1000)

    return () => clearInterval(interval)
  }, [])
  
  // Determine risk level based on sensor data
  const getRiskLevel = () => {
    if (currentTilt > 2.0 || currentShock > 2.8) return 'HIGH'
    if (currentTilt > 1.5 || currentShock > 2.3 || currentMoisture > 75) return 'MEDIUM'
    return 'LOW'
  }

  const getRiskColor = () => {
    const risk = getRiskLevel()
    if (risk === 'HIGH') return 'bg-red-900 text-red-100'
    if (risk === 'MEDIUM') return 'bg-orange-900 text-orange-100'
    return 'bg-green-900 text-green-100'
  }

  const getRiskIcon = () => {
    const risk = getRiskLevel()
    if (risk === 'HIGH') return 'text-red-400'
    if (risk === 'MEDIUM') return 'text-orange-400'
    return 'text-green-400'
  }

  const getRiskMessage = () => {
    const risk = getRiskLevel()
    if (risk === 'HIGH') return 'High landslide risk detected. Immediate action required.'
    if (risk === 'MEDIUM') return 'Moderate movement detected. Continue monitoring.'
    return 'Area is stable. Conditions normal.'
  }

  return (
    <div className="min-h-screen bg-background text-foreground">
      {/* Header */}
      <header className="border-b border-border bg-card/50 backdrop-blur-sm sticky top-0 z-10">
        <div className="max-w-7xl mx-auto px-6 py-6">
          <div className="flex items-start justify-between">
            <div>
              <h1 className="text-3xl font-bold text-foreground">TerraGuard™ - Landslide Risk Monitoring Dashboard</h1>
              <p className="text-muted-foreground mt-1">Real-time ground condition monitoring and prediction</p>
            </div>
            <Badge variant="outline" className="bg-secondary/50">
              Device: {isConnected ? 'Connected' : 'Not Connected'}
            </Badge>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-6 py-8">
        {/* Bluetooth Connection Panel */}
        <Card className="mb-8 border-border/50 bg-card/50 backdrop-blur-sm">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Bluetooth className="w-5 h-5" />
              Device Connection
            </CardTitle>
            <CardDescription>HC-05 Bluetooth Module Status</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="flex flex-col justify-between">
                <p className="text-sm text-muted-foreground">Connection Status</p>
                <div className="flex items-center gap-2 mt-2">
                  <div className={`w-3 h-3 rounded-full ${isConnected ? 'bg-green-500 animate-pulse' : 'bg-red-500'}`} />
                  <span className="font-semibold">{isConnected ? 'Connected' : 'Disconnected'}</span>
                </div>
              </div>
              <div className="flex flex-col justify-between">
                <p className="text-sm text-muted-foreground">Device Name</p>
                <p className="font-semibold mt-2">HC-05</p>
              </div>
              <div className="flex flex-col justify-between">
                <p className="text-sm text-muted-foreground">Last Data Received</p>
                <p className="font-semibold mt-2 font-mono text-sm">{lastUpdate}</p>
              </div>
            </div>
            <Button
              onClick={() => setIsConnected(!isConnected)}
              className="mt-6 w-full md:w-auto"
              variant={isConnected ? 'destructive' : 'default'}
            >
              {isConnected ? 'Disconnect Device' : 'Connect Device'}
            </Button>
          </CardContent>
        </Card>

        {/* Sensor Data Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          {/* Soil Moisture Card */}
          <Card className="border-border/50 bg-card/50 backdrop-blur-sm">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Droplets className="w-5 h-5 text-blue-400" />
                Soil Moisture
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-5xl font-bold text-blue-400 mb-4">{currentMoisture}%</div>
              <div className="w-full bg-secondary/50 rounded-full h-3">
                <div
                  className="bg-gradient-to-r from-blue-500 to-blue-400 h-3 rounded-full transition-all duration-300"
                  style={{ width: `${currentMoisture}%` }}
                />
              </div>
              <p className="text-sm text-muted-foreground mt-3">Optimal range: 45-80%</p>
            </CardContent>
          </Card>

          {/* Shock/Vibration Card */}
          <Card className="border-border/50 bg-card/50 backdrop-blur-sm">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Zap className="w-5 h-5 text-orange-400" />
                Shock/Vibration
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-5xl font-bold text-orange-400 mb-4">{currentShock.toFixed(1)} m/s²</div>
              <div className="w-full bg-secondary/50 rounded-full h-3">
                <div
                  className="bg-gradient-to-r from-orange-500 to-orange-400 h-3 rounded-full transition-all duration-300"
                  style={{ width: `${Math.min((currentShock / 4) * 100, 100)}%` }}
                />
              </div>
              <p className="text-sm text-muted-foreground mt-3">Normal: 0-3 m/s²</p>
            </CardContent>
          </Card>

          {/* Tilt/Movement Card */}
          <Card className="border-border/50 bg-card/50 backdrop-blur-sm">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Activity className="w-5 h-5 text-purple-400" />
                Tilt/Movement
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-5xl font-bold text-purple-400 mb-4">{currentTilt.toFixed(1)}°</div>
              <div className="w-full bg-secondary/50 rounded-full h-3">
                <div
                  className="bg-gradient-to-r from-purple-500 to-purple-400 h-3 rounded-full transition-all duration-300"
                  style={{ width: `${Math.min((currentTilt / 3) * 100, 100)}%` }}
                />
              </div>
              <p className="text-sm text-muted-foreground mt-3">Safe threshold: &lt;2.5°</p>
            </CardContent>
          </Card>
        </div>

        {/* Risk Level Indicator */}
        <div className={`${getRiskColor()} rounded-lg p-8 mb-8 border border-current/20 shadow-lg`}>
          <div className="flex items-start gap-4">
            <AlertTriangle className={`w-12 h-12 ${getRiskIcon()} flex-shrink-0 mt-1`} />
            <div className="flex-1">
              <h2 className="text-2xl font-bold mb-2">Risk Level: {getRiskLevel()}</h2>
              <p className="text-lg opacity-90">{getRiskMessage()}</p>
            </div>
          </div>
        </div>

        {/* Charts Section - Compact Subplots */}
        <div className="mb-8">
          <h2 className="text-xl font-semibold mb-4">Sensor Trends</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            {/* Soil Moisture Chart */}
            <Card className="border-border/50 bg-card/50 backdrop-blur-sm flex flex-col">
              <CardHeader className="pb-3">
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <CardTitle className="text-base">Soil Moisture</CardTitle>
                    <CardDescription className="text-xs">Last 60 minutes</CardDescription>
                  </div>
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => setExpandedChart('moisture')}
                    className="h-7 w-7 hover:bg-secondary/50 flex-shrink-0"
                  >
                    <Maximize2 className="w-4 h-4" />
                  </Button>
                </div>
              </CardHeader>
              <CardContent className="flex-1 pb-3">
                <ResponsiveContainer width="100%" height={180}>
                  <LineChart data={chartData}>
                    <CartesianGrid strokeDasharray="3 3" stroke="hsl(240, 10%, 18%)" />
                    <XAxis dataKey="time" stroke="hsl(240, 5%, 75%)" tick={{ fontSize: 11 }} />
                    <YAxis stroke="hsl(240, 5%, 75%)" domain={[0, 100]} tick={{ fontSize: 11 }} />
                    <Tooltip
                      contentStyle={{
                        backgroundColor: 'hsl(240, 10%, 11%)',
                        border: '1px solid hsl(240, 10%, 18%)',
                        borderRadius: '0.5rem',
                        fontSize: '12px',
                      }}
                      labelStyle={{ color: 'hsl(240, 5%, 95%)' }}
                    />
                    <Line type="monotone" dataKey="moisture" stroke="hsl(212, 100%, 50%)" dot={false} strokeWidth={2} />
                  </LineChart>
                </ResponsiveContainer>
              </CardContent>
            </Card>

            {/* Shock Activity Chart */}
            <Card className="border-border/50 bg-card/50 backdrop-blur-sm flex flex-col">
              <CardHeader className="pb-3">
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <CardTitle className="text-base">Shock Activity</CardTitle>
                    <CardDescription className="text-xs">Last 60 minutes</CardDescription>
                  </div>
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => setExpandedChart('shock')}
                    className="h-7 w-7 hover:bg-secondary/50 flex-shrink-0"
                  >
                    <Maximize2 className="w-4 h-4" />
                  </Button>
                </div>
              </CardHeader>
              <CardContent className="flex-1 pb-3">
                <ResponsiveContainer width="100%" height={180}>
                  <LineChart data={chartData}>
                    <CartesianGrid strokeDasharray="3 3" stroke="hsl(240, 10%, 18%)" />
                    <XAxis dataKey="time" stroke="hsl(240, 5%, 75%)" tick={{ fontSize: 11 }} />
                    <YAxis stroke="hsl(240, 5%, 75%)" tick={{ fontSize: 11 }} />
                    <Tooltip
                      contentStyle={{
                        backgroundColor: 'hsl(240, 10%, 11%)',
                        border: '1px solid hsl(240, 10%, 18%)',
                        borderRadius: '0.5rem',
                        fontSize: '12px',
                      }}
                      labelStyle={{ color: 'hsl(240, 5%, 95%)' }}
                    />
                    <Line type="monotone" dataKey="shock" stroke="hsl(45, 85%, 55%)" dot={false} strokeWidth={2} />
                  </LineChart>
                </ResponsiveContainer>
              </CardContent>
            </Card>

            {/* Tilt Movement Chart */}
            <Card className="border-border/50 bg-card/50 backdrop-blur-sm flex flex-col">
              <CardHeader className="pb-3">
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <CardTitle className="text-base">Tilt Movement</CardTitle>
                    <CardDescription className="text-xs">Last 60 minutes</CardDescription>
                  </div>
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => setExpandedChart('tilt')}
                    className="h-7 w-7 hover:bg-secondary/50 flex-shrink-0"
                  >
                    <Maximize2 className="w-4 h-4" />
                  </Button>
                </div>
              </CardHeader>
              <CardContent className="flex-1 pb-3">
                <ResponsiveContainer width="100%" height={180}>
                  <LineChart data={chartData}>
                    <CartesianGrid strokeDasharray="3 3" stroke="hsl(240, 10%, 18%)" />
                    <XAxis dataKey="time" stroke="hsl(240, 5%, 75%)" tick={{ fontSize: 11 }} />
                    <YAxis stroke="hsl(240, 5%, 75%)" tick={{ fontSize: 11 }} />
                    <Tooltip
                      contentStyle={{
                        backgroundColor: 'hsl(240, 10%, 11%)',
                        border: '1px solid hsl(240, 10%, 18%)',
                        borderRadius: '0.5rem',
                        fontSize: '12px',
                      }}
                      labelStyle={{ color: 'hsl(240, 5%, 95%)' }}
                    />
                    <Line type="monotone" dataKey="tilt" stroke="hsl(280, 70%, 60%)" dot={false} strokeWidth={2} />
                  </LineChart>
                </ResponsiveContainer>
              </CardContent>
            </Card>
          </div>
        </div>

        {/* Chart Modals */}
        <ChartModal
          isOpen={expandedChart === 'moisture'}
          onClose={() => setExpandedChart(null)}
          title="Soil Moisture Over Time"
          data={chartData}
          dataKey="moisture"
          color="hsl(212, 100%, 50%)"
        />
        <ChartModal
          isOpen={expandedChart === 'shock'}
          onClose={() => setExpandedChart(null)}
          title="Shock Activity Over Time"
          data={chartData}
          dataKey="shock"
          color="hsl(45, 85%, 55%)"
        />
        <ChartModal
          isOpen={expandedChart === 'tilt'}
          onClose={() => setExpandedChart(null)}
          title="Tilt Movement Over Time"
          data={chartData}
          dataKey="tilt"
          color="hsl(280, 70%, 60%)"
        />

        {/* Activity Log Table */}
        <Card className="border-border/50 bg-card/50 backdrop-blur-sm mb-8">
          <CardHeader>
            <CardTitle>Activity Log</CardTitle>
            <CardDescription>Recent sensor readings and risk assessments</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="overflow-x-auto">
              <Table>
                <TableHeader>
                  <TableRow className="border-border/50 hover:bg-secondary/30">
                    <TableHead>Time</TableHead>
                    <TableHead>Moisture</TableHead>
                    <TableHead>Shock</TableHead>
                    <TableHead>Tilt</TableHead>
                    <TableHead>Risk Level</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {activityLog.length > 0 ? (
                    activityLog.map((entry, i) => (
                      <TableRow key={i} className="border-border/50 hover:bg-secondary/30">
                        <TableCell className="font-medium font-mono text-sm">{entry.time}</TableCell>
                        <TableCell>{entry.moisture}%</TableCell>
                        <TableCell>{entry.shock} m/s²</TableCell>
                        <TableCell>{entry.tilt}°</TableCell>
                        <TableCell>
                          <Badge
                            variant="secondary"
                            className={
                              entry.risk === 'HIGH'
                                ? 'bg-red-900 text-red-100'
                                : entry.risk === 'MEDIUM'
                                  ? 'bg-orange-900 text-orange-100'
                                  : 'bg-green-900 text-green-100'
                            }
                          >
                            {entry.risk}
                          </Badge>
                        </TableCell>
                      </TableRow>
                    ))
                  ) : (
                    <TableRow>
                      <TableCell colSpan={5} className="text-center text-muted-foreground py-4">
                        Loading data...
                      </TableCell>
                    </TableRow>
                  )}
                </TableBody>
              </Table>
            </div>
          </CardContent>
        </Card>

        {/* Prediction Panel */}
        <Card className="border-border/50 bg-card/50 backdrop-blur-sm mb-8">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <TrendingUp className="w-5 h-5" />
              AI Risk Prediction
            </CardTitle>
            <CardDescription>Machine learning-based landslide probability forecast</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="py-12 text-center">
              <p className="text-lg text-muted-foreground">
                Prediction module will be added in a future update
              </p>
              <p className="text-sm text-muted-foreground mt-4">
                Placeholder for probability and confidence level display
              </p>
            </div>
          </CardContent>
        </Card>

        {/* Alert Panel */}
        <Card className="border-border/50 bg-card/50 backdrop-blur-sm">
          <CardHeader>
            <CardTitle>System Alerts</CardTitle>
            <CardDescription>Active danger notifications</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="py-8 text-center">
              <div className="inline-block px-6 py-3 rounded-lg bg-green-900/30 text-green-100 border border-green-800">
                ✓ No active danger alerts
              </div>
              <p className="text-sm text-muted-foreground mt-4">
                Alert panel will display in red when danger is detected
              </p>
            </div>
          </CardContent>
        </Card>
      </main>
    </div>
  )
}
