# AdoreMix 一键安装脚本（Windows x64）
#
# 用法（PowerShell，一条命令）：
#   irm https://raw.githubusercontent.com/oxiaom/adoremix-npm/main/scripts/install.ps1 | iex
#
# 可选环境变量（执行前设置）：
#   $env:ADOREMIX_VERSION      = "1.0.76"       # 默认 latest
#   $env:ADOREMIX_SKIP_START   = "1"            # 安装后不启动
#   $env:ADOREMIX_NO_SERVICE   = "1"            # 不注册 Windows 服务
#   $env:ADOREMIX_NPM_REGISTRY = "https://registry.npmmirror.com"
#   $env:ADOREMIX_NODE_MAJOR   = "20"
#   $env:ADOREMIX_DRY_RUN      = "1"
#
# 说明：脚本不修改系统已有 Node（低于 18 时只在用户目录装独立版本）。

$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Version    = if ($env:ADOREMIX_VERSION)    { $env:ADOREMIX_VERSION }    else { 'latest' }
$SkipStart  = ($env:ADOREMIX_SKIP_START -eq '1')
$NoService  = ($env:ADOREMIX_NO_SERVICE -eq '1')
$Registry   = $env:ADOREMIX_NPM_REGISTRY
$NodeMajor  = if ($env:ADOREMIX_NODE_MAJOR) { [int]$env:ADOREMIX_NODE_MAJOR } else { 20 }
$DryRun     = ($env:ADOREMIX_DRY_RUN -eq '1')
$NodeMirror = if ($env:ADOREMIX_NODE_MIRROR) { $env:ADOREMIX_NODE_MIRROR } else { 'https://npmmirror.com/mirrors/node' }
$NodeDir    = Join-Path $env:LOCALAPPDATA 'AdoreMix\node'

function Write-Step($m) { Write-Host "-> $m" -ForegroundColor Cyan }
function Write-Ok($m)   { Write-Host "OK $m" -ForegroundColor Green }
function Write-Warn2($m){ Write-Host "!  $m" -ForegroundColor Yellow }
function Fail($m)       { Write-Host "X  $m" -ForegroundColor Red; throw $m }
function Invoke-Step([scriptblock]$b) {
  if ($DryRun) { Write-Host "  [dry-run] $($b.ToString().Trim())" -ForegroundColor DarkGray; return }
  & $b
}

function Refresh-Path {
  $m = [Environment]::GetEnvironmentVariable('Path','Machine')
  $u = [Environment]::GetEnvironmentVariable('Path','User')
  $env:Path = (@($m, $u) | Where-Object { $_ }) -join ';'
}

function Get-NodeVersion {
  try {
    $v = (& node -v) 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $v) { return $null }
    return ([string]$v).TrimStart('v')
  } catch { return $null }
}

function Test-VersionGe($cur, $need) {
  try { return ([version]$cur -ge [version]$need) } catch { return $false }
}

function Add-UserPath($dir) {
  $u = [Environment]::GetEnvironmentVariable('Path','User')
  $parts = @()
  if ($u) { $parts = $u -split ';' }
  if ($parts -notcontains $dir) {
    $new = (($parts + $dir) | Where-Object { $_ }) -join ';'
    [Environment]::SetEnvironmentVariable('Path', $new, 'User')
  }
  if (($env:Path -split ';') -notcontains $dir) {
    $env:Path = "$dir;$env:Path"
  }
}

function Install-NodePortable {
  Write-Step "未检测到 Node.js 18+，自动安装 Node.js v$NodeMajor.x 到用户目录（无需管理员）"
  $sumsUrl = "$NodeMirror/latest-v$NodeMajor.x/SHASUMS256.txt"
  try {
    $sums = Invoke-RestMethod -Uri $sumsUrl -UseBasicParsing -TimeoutSec 30
  } catch {
    Write-Warn2 "镜像不可用（$sumsUrl），改用官方源"
    $sumsUrl = "https://nodejs.org/dist/latest-v$NodeMajor.x/SHASUMS256.txt"
    $sums = Invoke-RestMethod -Uri $sumsUrl -UseBasicParsing -TimeoutSec 30
  }
  $lines = $sums -split "`r?`n"
  $line = $lines | Where-Object { $_ -match 'node-v[\d.]+-win-x64\.zip$' } | Select-Object -First 1
  if (-not $line) { Fail "在 $sumsUrl 中找不到 Windows x64 的 Node 安装包" }
  $fileName = ($line -split '\s+')[-1]
  $expect = ($line -split '\s+')[0]
  $url = "$($sumsUrl.Substring(0, $sumsUrl.LastIndexOf('/') + 1))$fileName"

  $tmp = Join-Path $env:TEMP ("adoremix-node-" + [guid]::NewGuid().ToString('N'))
  New-Item -ItemType Directory -Path $tmp -Force | Out-Null
  $zip = Join-Path $tmp $fileName
  try {
    Write-Step "下载 $fileName"
    Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing -TimeoutSec 300
    $got = (Get-FileHash -Path $zip -Algorithm SHA256).Hash.ToLower()
    if ($expect -and $got -ne $expect.ToLower()) { Fail "Node 安装包校验失败：$fileName" }
    if (Test-Path $NodeDir) { Remove-Item -Recurse -Force $NodeDir }
    New-Item -ItemType Directory -Path $NodeDir -Force | Out-Null
    Expand-Archive -Path $zip -DestinationPath $tmp -Force
    $inner = Get-ChildItem -Path $tmp -Directory | Where-Object { $_.Name -like 'node-v*' } | Select-Object -First 1
    if (-not $inner) { Fail "Node 压缩包结构异常" }
    Copy-Item -Path (Join-Path $inner.FullName '*') -Destination $NodeDir -Recurse -Force
  } finally {
    Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
  }
  Add-UserPath $NodeDir
  Refresh-Path
  $v = Get-NodeVersion
  if (-not $v) { Fail "Node 安装后仍无法执行，请手动安装 Node 18+：https://nodejs.org" }
  Write-Ok "Node.js $v 安装到 $NodeDir"
}

function Ensure-Node {
  $v = Get-NodeVersion
  if ($v -and (Test-VersionGe $v '18.0.0')) { Write-Ok "Node.js $v 已就绪"; return }
  if ($v) { Write-Warn2 "检测到 Node.js $v，低于 18，将安装独立的新版本（不影响系统 Node）" }

  if (-not $v -and (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Step "尝试用 winget 安装 Node.js LTS"
    try {
      Invoke-Step { winget install --id OpenJS.NodeJS.LTS -e --silent --accept-package-agreements --accept-source-agreements | Out-Null }
      Refresh-Path
      $v = Get-NodeVersion
      if ($v -and (Test-VersionGe $v '18.0.0')) { Write-Ok "Node.js $v 已通过 winget 安装"; return }
    } catch {
      Write-Warn2 "winget 安装失败，改为便携版"
    }
  }
  Install-NodePortable
}

function Test-Admin {
  $id = [Security.Principal.WindowsIdentity]::GetCurrent()
  $p = New-Object Security.Principal.WindowsPrincipal($id)
  return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-Writable($dir) {
  try {
    if (-not (Test-Path $dir)) { return $false }
    $f = Join-Path $dir ('.adoremix-write-' + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType File -Path $f -Force | Out-Null
    Remove-Item $f -Force
    return $true
  } catch { return $false }
}

Refresh-Path
if (-not [Environment]::Is64BitOperatingSystem) { Fail "仅支持 64 位 Windows" }
if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') {
  Write-Warn2 "检测到 ARM64 Windows：npm 包为 x64，将依赖系统模拟运行"
}

Write-Host ''
Write-Host '==============================================' -ForegroundColor Cyan
Write-Host '  AdoreMix 一键安装（Windows x64）' -ForegroundColor Cyan
Write-Host '==============================================' -ForegroundColor Cyan

Ensure-Node

$prefix = (& npm config get prefix) 2>$null
if ($LASTEXITCODE -ne 0 -or -not $prefix) { Fail "npm 不可用，请重新打开 PowerShell 后重试" }
$prefix = $prefix.Trim()

# 非管理员：npm 全局目录不可写时，切换到当前用户目录，避免 UAC 失败
if (-not (Test-Writable $prefix)) {
  $fallback = Join-Path $env:APPDATA 'npm'
  New-Item -ItemType Directory -Path $fallback -Force | Out-Null
  if (Test-Writable $fallback) {
    Write-Warn2 "npm 全局目录 $prefix 不可写，改用 $fallback（无需管理员）"
    Invoke-Step { & npm config set prefix $fallback | Out-Null }
    $prefix = $fallback
  } else {
    Fail "npm 全局目录不可写：$prefix。请用“以管理员身份运行”的 PowerShell 重试"
  }
}
Write-Ok "npm 全局目录：$prefix"
if (($env:Path -split ';') -notcontains $prefix) { Add-UserPath $prefix }

$npmArgs = @('install', '-g', "@oxiaom/adoremix@$Version")
if ($Registry) { $npmArgs += @('--registry', $Registry) }
Write-Step "安装 @oxiaom/adoremix@$Version"
Invoke-Step { & npm @npmArgs }
if ($LASTEXITCODE -ne 0 -and -not $DryRun) { Fail "npm install 失败（退出码 $LASTEXITCODE）" }

if ($DryRun) { Write-Host '  [dry-run] 到此为止（ADOREMIX_DRY_RUN=1）' -ForegroundColor DarkGray; return }

$adoremix = Join-Path $prefix 'adoremix.cmd'
if (-not (Test-Path $adoremix)) {
  $cmd = Get-Command adoremix -ErrorAction SilentlyContinue
  if ($cmd) { $adoremix = $cmd.Source } else { Fail "未找到 adoremix 命令，请检查 PATH" }
}
Write-Ok "adoremix 已安装：$adoremix"

Write-Step '初始化工作目录与默认配置'
& $adoremix install --no-interactive
if ($LASTEXITCODE -ne 0) { Write-Warn2 "初始化返回 $LASTEXITCODE，继续" }

$curIp = (& $adoremix config get Settings.LocalIP) 2>$null
$curIp = if ($curIp) { ($curIp -split '=')[-1].Trim() } else { '' }
if (-not $curIp -or $curIp -eq '127.0.0.1') {
  Write-Step '自动选择网卡 IP（设备连接地址）'
  & $adoremix config network --no-interactive
} else {
  Write-Ok "设备连接 IP：$curIp"
}

Write-Step '环境体检'
& $adoremix doctor
if ($LASTEXITCODE -ne 0) { Write-Warn2 'doctor 有告警，请按提示处理' }

if (-not $SkipStart) {
  $isAdmin = Test-Admin
  if (-not $NoService -and $isAdmin) {
    Write-Step '注册 Windows 开机自启服务'
    & $adoremix service install
    if ($LASTEXITCODE -ne 0) {
      Write-Warn2 '服务注册失败，改为后台启动'
      & $adoremix start --daemon
    }
  } else {
    if (-not $NoService -and -not $isAdmin) {
      Write-Warn2 '当前不是管理员，跳过服务注册（可用管理员 PowerShell 执行：adoremix service install）'
    }
    Write-Step '后台启动 AdoreMix'
    & $adoremix start --daemon
  }
} else {
  Write-Warn2 '已跳过启动（ADOREMIX_SKIP_START=1）'
}

$ip = (& $adoremix config get Settings.LocalIP) 2>$null
$ip = if ($ip) { ($ip -split '=')[-1].Trim() } else { '127.0.0.1' }
Write-Host ''
Write-Ok '安装完成！'
Write-Host "  WebUI：   http://${ip}:12080/"
Write-Host '  状态：    adoremix status'
Write-Host '  日志：    adoremix logs'
Write-Host '  配置：    adoremix config'
Write-Host ''
