#!/usr/bin/env python3
import os
import re
import json
import subprocess
from datetime import datetime, timezone
from flask import Flask, render_template, request, jsonify

app = Flask(__name__)

# 工作目录（由 adoremix config-manager 服务的环境变量指定，默认 /opt/adoremix）
WORKDIR = os.environ.get('ADOREMIX_WORKDIR', '/opt/adoremix')

# 配置文件路径
CONFIG_INI = os.path.join(WORKDIR, 'config.ini')
OPENCLAW_CONFIG = "/root/.openclaw/openclaw.json"

# 常用模型列表
POPULAR_MODELS = [
    # 智谱 GLM 系列 (完整)
    {"id": "zai/glm-4.7", "name": "智谱 GLM-4.7", "provider": "zhipu"},
    {"id": "zai/glm-4-plus", "name": "智谱 GLM-4 Plus", "provider": "zhipu"},
    {"id": "zai/glm-4-0520", "name": "智谱 GLM-4-0520", "provider": "zhipu"},
    {"id": "zai/glm-4-air", "name": "智谱 GLM-4 Air", "provider": "zhipu"},
    {"id": "zai/glm-4-airx", "name": "智谱 GLM-4 AirX", "provider": "zhipu"},
    {"id": "zai/glm-4-flash", "name": "智谱 GLM-4 Flash", "provider": "zhipu"},
    {"id": "zai/glm-4-long", "name": "智谱 GLM-4 Long (长文本)", "provider": "zhipu"},
    {"id": "zai/glm-4", "name": "智谱 GLM-4", "provider": "zhipu"},
    {"id": "zai/glm-4v", "name": "智谱 GLM-4V (视觉)", "provider": "zhipu"},
    {"id": "zai/glm-4v-plus", "name": "智谱 GLM-4V Plus (视觉)", "provider": "zhipu"},
    {"id": "zai/glm-3-turbo", "name": "智谱 GLM-3 Turbo", "provider": "zhipu"},
    {"id": "zai/glm-5", "name": "智谱 GLM-5", "provider": "zhipu"},
    {"id": "zai/glm-5-turbo", "name": "智谱 GLM-5 Turbo", "provider": "zhipu"},
    # OpenAI
    {"id": "openai/gpt-4o", "name": "OpenAI GPT-4o", "provider": "openai"},
    {"id": "openai/gpt-4o-mini", "name": "OpenAI GPT-4o Mini", "provider": "openai"},
    {"id": "openai/gpt-4-turbo", "name": "OpenAI GPT-4 Turbo", "provider": "openai"},
    {"id": "openai/gpt-4", "name": "OpenAI GPT-4", "provider": "openai"},
    {"id": "openai/o1-preview", "name": "OpenAI O1 Preview", "provider": "openai"},
    {"id": "openai/o1-mini", "name": "OpenAI O1 Mini", "provider": "openai"},
    # Claude
    {"id": "anthropic/claude-3-5-sonnet", "name": "Claude 3.5 Sonnet", "provider": "anthropic"},
    {"id": "anthropic/claude-3-5-haiku", "name": "Claude 3.5 Haiku", "provider": "anthropic"},
    {"id": "anthropic/claude-3-opus", "name": "Claude 3 Opus", "provider": "anthropic"},
    {"id": "anthropic/claude-3-sonnet", "name": "Claude 3 Sonnet", "provider": "anthropic"},
    {"id": "anthropic/claude-3-haiku", "name": "Claude 3 Haiku", "provider": "anthropic"},
    # Google
    {"id": "google/gemini-1.5-pro", "name": "Google Gemini 1.5 Pro", "provider": "google"},
    {"id": "google/gemini-1.5-flash", "name": "Google Gemini 1.5 Flash", "provider": "google"},
    {"id": "google/gemini-2.0-flash", "name": "Google Gemini 2.0 Flash", "provider": "google"},
    {"id": "google/gemini-pro", "name": "Google Gemini Pro", "provider": "google"},
    # DeepSeek
    {"id": "deepseek/deepseek-chat", "name": "DeepSeek Chat", "provider": "deepseek"},
    {"id": "deepseek/deepseek-coder", "name": "DeepSeek Coder", "provider": "deepseek"},
    {"id": "deepseek/deepseek-reasoner", "name": "DeepSeek Reasoner", "provider": "deepseek"},
    # Moonshot
    {"id": "moonshot/moonshot-v1-8k", "name": "Moonshot Kimi 8K", "provider": "moonshot"},
    {"id": "moonshot/moonshot-v1-32k", "name": "Moonshot Kimi 32K", "provider": "moonshot"},
    {"id": "moonshot/moonshot-v1-128k", "name": "Moonshot Kimi 128K", "provider": "moonshot"},
    # 通义千问
    {"id": "qwen/qwen-turbo", "name": "通义千问 Turbo", "provider": "qwen"},
    {"id": "qwen/qwen-plus", "name": "通义千问 Plus", "provider": "qwen"},
    {"id": "qwen/qwen-max", "name": "通义千问 Max", "provider": "qwen"},
    {"id": "qwen/qwen-long", "name": "通义千问 Long", "provider": "qwen"},
    # Ollama 本地
    {"id": "ollama/llama3", "name": "Ollama Llama3 (本地)", "provider": "ollama"},
    {"id": "ollama/llama3.1", "name": "Ollama Llama3.1 (本地)", "provider": "ollama"},
    {"id": "ollama/qwen2", "name": "Ollama Qwen2 (本地)", "provider": "ollama"},
    {"id": "ollama/qwen2.5", "name": "Ollama Qwen2.5 (本地)", "provider": "ollama"},
    {"id": "ollama/deepseek-v2", "name": "Ollama DeepSeek V2 (本地)", "provider": "ollama"},
    {"id": "ollama/glm4", "name": "Ollama GLM4 (本地)", "provider": "ollama"},
]

def parse_ini(filepath):
    """解析 INI 文件"""
    config = {}
    current_section = None
    
    if not os.path.exists(filepath):
        return config
    
    with open(filepath, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith(';') or line.startswith('#'):
                continue
            if line.startswith('[') and line.endswith(']'):
                current_section = line[1:-1]
                config[current_section] = {}
            elif '=' in line and current_section:
                key, value = line.split('=', 1)
                config[current_section][key.strip()] = value.strip()
    
    return config

def write_ini(filepath, config):
    """写入 INI 文件"""
    with open(filepath, 'w', encoding='utf-8') as f:
        for section, values in config.items():
            f.write(f'[{section}]\n')
            for key, value in values.items():
                f.write(f'{key}={value}\n')
            f.write('\n')

def get_network_info():
    """获取当前网络信息"""
    result = subprocess.run(['ip', 'addr', 'show'], capture_output=True, text=True)
    
    interfaces = []
    current_iface = None
    
    for line in result.stdout.split('\n'):
        if ': ' in line and not line.startswith(' '):
            parts = line.split(': ')
            if len(parts) >= 2:
                iface = parts[1].split('@')[0]
                if iface != 'lo':
                    current_iface = {'name': iface, 'ip': '', 'netmask': '', 'gateway': '', 'dhcp': False}
                    interfaces.append(current_iface)
        elif 'inet ' in line and current_iface:
            match = re.search(r'inet (\d+\.\d+\.\d+\.\d+)/(\d+)', line)
            if match:
                current_iface['ip'] = match.group(1)
                current_iface['netmask'] = match.group(2)
    
    # 获取网关
    result = subprocess.run(['ip', 'route'], capture_output=True, text=True)
    for line in result.stdout.split('\n'):
        if 'default' in line:
            match = re.search(r'via (\d+\.\d+\.\d+\.\d+)', line)
            if match:
                for iface in interfaces:
                    iface['gateway'] = match.group(1)
    
    # 通过 systemd-networkd 配置检测 DHCP/静态状态
    for iface in interfaces:
        net_file = f'/etc/systemd/network/10-{iface["name"]}.network'
        if os.path.exists(net_file):
            try:
                with open(net_file, 'r') as f:
                    cfg = f.read()
                iface['dhcp'] = 'DHCP=yes' in cfg
            except:
                iface['dhcp'] = True
        else:
            iface['dhcp'] = True
    
    return interfaces

def set_static_ip(interface, ip, netmask, gateway, dns='8.8.8.8', use_dhcp=False):
    """使用 systemd-networkd 设置静态IP或DHCP"""
    net_file = f'/etc/systemd/network/10-{interface}.network'
    
    if use_dhcp:
        config = f"""[Match]
Name={interface}

[Network]
DHCP=yes
"""
    else:
        config = f"""[Match]
Name={interface}

[Network]
Address={ip}/{netmask}
Gateway={gateway}
DNS={dns}
"""
    
    with open(net_file, 'w') as f:
        f.write(config)
    
    return net_file

def apply_network():
    """应用网络配置"""
    result = subprocess.run(['systemctl', 'restart', 'systemd-networkd'], capture_output=True, text=True, timeout=15)
    return result

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/network', methods=['GET'])
def get_network():
    """获取网络配置"""
    interfaces = get_network_info()
    return jsonify({'interfaces': interfaces})

@app.route('/api/network', methods=['POST'])
def set_network():
    """设置网络配置"""
    data = request.json
    interface = data.get('interface')
    ip = data.get('ip')
    netmask = data.get('netmask', '24')
    gateway = data.get('gateway')
    dns = data.get('dns', '8.8.8.8')
    use_dhcp = data.get('useDhcp', False)
    apply_now = data.get('applyNow', False)
    
    if not interface:
        return jsonify({'error': '缺少网络接口参数'}), 400
    
    # DHCP 模式不需要 IP/网关
    if not use_dhcp and not all([ip, gateway]):
        return jsonify({'error': '静态 IP 模式需要填写 IP 地址和网关'}), 400
    
    try:
        netplan_file = set_static_ip(interface, ip, netmask, gateway, dns, use_dhcp)
        
        if apply_now:
            # 应用网络配置
            result = apply_network()
            if result.returncode != 0:
                return jsonify({'error': f'配置已保存但应用失败: {result.stderr}'}), 500
            
            # 等待网络恢复
            import time
            time.sleep(2)
            
            # 重启依赖服务
            services = ['config-manager.service', 'broadcast-panel.service', 'openclaw-gateway.service']
            restarted = []
            for svc in services:
                try:
                    subprocess.run(['systemctl', 'restart', svc], capture_output=True, text=True, timeout=30)
                    restarted.append(svc)
                except:
                    pass
            
            return jsonify({
                'success': True,
                'message': f'配置已保存并应用，已重启服务: {", ".join(restarted) if restarted else "无"}',
                'restarted': restarted
            })
        
        return jsonify({
            'success': True,
            'message': f'配置已保存到 {netplan_file}',
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/config', methods=['GET'])
def get_config():
    """获取 config.ini"""
    config = parse_ini(CONFIG_INI)
    return jsonify({'config': config})

@app.route('/api/config', methods=['POST'])
def set_config():
    """保存 config.ini"""
    data = request.json
    config = data.get('config')
    
    if not config:
        return jsonify({'error': '无配置数据'}), 400
    
    try:
        # 备份
        subprocess.run(['cp', CONFIG_INI, f'{CONFIG_INI}.bak'], stderr=subprocess.DEVNULL)
        write_ini(CONFIG_INI, config)
        return jsonify({'success': True, 'message': '配置已保存'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/qqbot', methods=['GET'])
def get_qqbot():
    """获取 QQBot 配置"""
    try:
        with open(OPENCLAW_CONFIG, 'r') as f:
            config = json.load(f)
        channels = config.get('channels', {}).get('qqbot', {})
        plugin_enabled = config.get('plugins', {}).get('entries', {}).get('openclaw-qqbot', {}).get('enabled', True)
        return jsonify({
            'config': {
                'uin': channels.get('appId', ''),
                'password': channels.get('clientSecret', ''),
                'enabled': plugin_enabled
            }
        })
    except Exception as e:
        return jsonify({'config': {'uin': '', 'password': ''}, 'error': str(e)})

@app.route('/api/qqbot', methods=['POST'])
def set_qqbot():
    """保存 QQBot 配置到 OpenClaw 配置文件"""
    data = request.json
    uin = data.get('uin', '')
    password = data.get('password', '')
    
    try:
        with open(OPENCLAW_CONFIG, 'r') as f:
            config = json.load(f)
        
        if 'channels' not in config:
            config['channels'] = {}
        if 'qqbot' not in config['channels']:
            config['channels']['qqbot'] = {}
        
        config['channels']['qqbot']['appId'] = uin
        config['channels']['qqbot']['clientSecret'] = password
        
        with open(OPENCLAW_CONFIG, 'w') as f:
            json.dump(config, f, indent=2)
        
        return jsonify({
            'success': True, 
            'message': 'QQBot 配置已保存，需要重启 OpenClaw Gateway 才能生效'
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/qqbot-toggle', methods=['POST'])
def toggle_qqbot():
    """启用/禁用 QQBot"""
    data = request.json
    enabled = data.get('enabled', True)
    
    try:
        with open(OPENCLAW_CONFIG, 'r') as f:
            config = json.load(f)
        
        if 'plugins' not in config:
            config['plugins'] = {}
        if 'entries' not in config['plugins']:
            config['plugins']['entries'] = {}
        if 'openclaw-qqbot' not in config['plugins']['entries']:
            config['plugins']['entries']['openclaw-qqbot'] = {}
        
        config['plugins']['entries']['openclaw-qqbot']['enabled'] = enabled
        
        with open(OPENCLAW_CONFIG, 'w') as f:
            json.dump(config, f, indent=2)
        
        return jsonify({
            'success': True,
            'message': f'QQBot 已{"启用" if enabled else "禁用"}，需要重启 Gateway 才能生效'
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/netplan-apply', methods=['POST'])
def apply_netplan():
    """应用网络配置"""
    try:
        result = apply_network()
        if result.returncode == 0:
            return jsonify({'success': True, 'message': '网络配置已应用'})
        else:
            return jsonify({'error': result.stderr}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/adoremix-restart', methods=['POST'])
def restart_adoremix():
    """重启小播鼠服务"""
    try:
        result = subprocess.run(['systemctl', 'restart', 'adoremix'], capture_output=True, text=True, timeout=30)
        if result.returncode == 0:
            return jsonify({'success': True, 'message': '小播鼠服务已重启'})
        else:
            return jsonify({'error': result.stderr}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/openclaw-restart', methods=['POST'])
def restart_openclaw():
    """重启 OpenClaw Gateway"""
    try:
        result = subprocess.run(['openclaw', 'gateway', 'restart'], capture_output=True, text=True, timeout=300)
        return jsonify({'success': True, 'message': 'OpenClaw Gateway 正在重启'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/models', methods=['GET'])
def get_models():
    """获取模型配置"""
    try:
        with open(OPENCLAW_CONFIG, 'r') as f:
            config = json.load(f)
        
        agents = config.get('agents', {}).get('defaults', {})
        model_val = agents.get('model', '')
        primary = model_val if isinstance(model_val, str) else model_val.get('primary', '')
        models_config = agents.get('models', {})
        
        # 获取各提供商的 API key
        api_keys = {}
        for model_id, model_cfg in models_config.items():
            if isinstance(model_cfg, dict) and 'apiKey' in model_cfg:
                api_keys[model_id] = model_cfg['apiKey']
        
        return jsonify({
            'primary': primary,
            'models': models_config,
            'apiKeys': api_keys,
            'availableModels': POPULAR_MODELS
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/models', methods=['POST'])
def set_models():
    """保存模型配置"""
    data = request.json
    primary = data.get('primary', '')
    model_configs = data.get('modelConfigs', {})
    
    try:
        with open(OPENCLAW_CONFIG, 'r') as f:
            config = json.load(f)
        
        if 'agents' not in config:
            config['agents'] = {}
        if 'defaults' not in config['agents']:
            config['agents']['defaults'] = {}
        if 'models' not in config['agents']['defaults']:
            config['agents']['defaults']['models'] = {}
        
        # 设置主模型（直接存字符串）
        config['agents']['defaults']['model'] = primary
        
        # 确保主模型在 models 列表中
        if primary not in config['agents']['defaults']['models']:
            config['agents']['defaults']['models'][primary] = {}
        
        # 保存模型配置 (apiKey + baseUrl)
        for model_id, model_cfg in model_configs.items():
            if model_id not in config['agents']['defaults']['models']:
                config['agents']['defaults']['models'][model_id] = {}
            
            if isinstance(model_cfg, dict):
                if 'apiKey' in model_cfg:
                    config['agents']['defaults']['models'][model_id]['apiKey'] = model_cfg['apiKey']
                if 'baseUrl' in model_cfg:
                    config['agents']['defaults']['models'][model_id]['baseUrl'] = model_cfg['baseUrl']
        
        with open(OPENCLAW_CONFIG, 'w') as f:
            json.dump(config, f, indent=2)
        
        return jsonify({
            'success': True, 
            'message': '模型配置已保存，需要重启 Gateway 才能生效'
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ==================== 实时日志查看 ====================

# 常用服务预设（优先列在前面）
LOG_SERVICES_PRESET = [
    'adoremix',
    'config-manager',
    'openclaw-gateway',
    'smbd',
    'nmbd',
    'ssh',
]

# 文件日志源（不是 systemd 服务，是应用自己的日志文件）
LOG_FILE_SOURCES = {
    'adoremix-app': os.path.join(WORKDIR, 'var', 'app.log'),
    'config-manager-out': '/var/log/config-manager.log',  # 预留，可能不存在
}

@app.route('/api/logs', methods=['GET'])
def api_logs():
    """拉取 systemd journal 日志 或 文件日志"""
    service = request.args.get('service', 'adoremix').strip()
    try:
        lines = int(request.args.get('lines', 200))
    except ValueError:
        lines = 200
    lines = max(1, min(lines, 2000))

    # 时间范围过滤：since 形如 "5min" / "30min" / "1h" / "2h" / "today" / "all" / ISO timestamp
    since = request.args.get('since', 'all').strip()

    if not service:
        return jsonify({'error': '缺少 service 参数', 'lines': []}), 400

    # 验证服务名（防注入：只允许字母数字下划线短横线点）
    if not re.match(r'^[A-Za-z0-9._-]+$', service):
        return jsonify({'error': '非法服务名', 'lines': []}), 400

    # === 文件源 ===
    if service in LOG_FILE_SOURCES:
        file_path = LOG_FILE_SOURCES[service]
        try:
            if not os.path.exists(file_path):
                return jsonify({
                    'service': service,
                    'source': 'file',
                    'path': file_path,
                    'lines': [],
                    'count': 0,
                    'timestamp': datetime.now(timezone.utc).isoformat(),
                    'warning': f'文件不存在: {file_path}'
                })
            # tail 取最后 N 行
            result = subprocess.run(
                ['tail', '-n', str(lines), file_path],
                capture_output=True, text=True, timeout=5
            )
            log_lines = result.stdout.splitlines() if result.stdout else []
            return jsonify({
                'service': service,
                'source': 'file',
                'path': file_path,
                'lines': log_lines,
                'count': len(log_lines),
                'timestamp': datetime.now(timezone.utc).isoformat()
            })
        except subprocess.TimeoutExpired:
            return jsonify({'error': 'tail timeout (>5s)', 'lines': []}), 500
        except Exception as e:
            return jsonify({'error': str(e), 'lines': []}), 500

    # === journalctl 源 ===
    # 映射快捷时间
    since_map = {
        '5min':   '5 min ago',
        '10min':  '10 min ago',
        '30min':  '30 min ago',
        '1h':     '1 hour ago',
        '2h':     '2 hours ago',
        '6h':     '6 hours ago',
        '12h':    '12 hours ago',
        'today':  'today',
        'yesterday': 'yesterday',
    }
    since_value = since_map.get(since, since)
    use_since = since_value and since_value != 'all'

    try:
        cmd = ['journalctl', '-u', service, '--no-pager', '-n', str(lines)]
        if use_since:
            cmd += ['--since', since_value]

        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=10
        )

        log_lines = result.stdout.splitlines() if result.stdout else []

        return jsonify({
            'service': service,
            'source': 'journalctl',
            'since': since,
            'lines': log_lines,
            'count': len(log_lines),
            'timestamp': datetime.now(timezone.utc).isoformat()
        })
    except subprocess.TimeoutExpired:
        return jsonify({'error': 'journalctl timeout (>10s)', 'lines': []}), 500
    except FileNotFoundError:
        return jsonify({'error': 'journalctl 未安装', 'lines': []}), 500
    except Exception as e:
        return jsonify({'error': str(e), 'lines': []}), 500


@app.route('/api/logs/services', methods=['GET'])
def api_logs_services():
    """列出常用服务（用于下拉菜单）"""
    services = list(LOG_SERVICES_PRESET)
    try:
        # 额外获取当前 running 的服务
        result = subprocess.run(
            ['systemctl', 'list-units', '--type=service', '--no-pager', '--no-legend', '--state=running'],
            capture_output=True, text=True, timeout=5
        )
        for line in result.stdout.splitlines():
            parts = line.split()
            if parts and parts[0].endswith('.service'):
                name = parts[0][:-len('.service')]
                if name not in services:
                    services.append(name)
    except Exception:
        pass
    return jsonify({'services': services})

if __name__ == '__main__':
    app.run(host='::', port=9877, debug=False)
