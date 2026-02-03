#!/bin/bash

echo "======================================"
echo "    塔罗占卜应用 - 启动脚本"
echo "======================================"
echo ""

# Kill any existing servers
echo "1. 清理旧的服务器进程..."
pkill -f "python3 -m http.server" 2>/dev/null
sleep 1

# Navigate to directory
cd /workspaces/tarot111 || exit 1

# Start server
echo "2. 启动 HTTP 服务器（端口 8000）..."
python3 -m http.server 8000 > /tmp/tarot_server.log 2>&1 &
SERVER_PID=$!
echo "   服务器 PID: $SERVER_PID"

# Wait for server to start
sleep 2

# Check if server is running
if ps -p $SERVER_PID > /dev/null; then
    echo "   ✓ 服务器启动成功"
else
    echo "   ✗ 服务器启动失败"
    exit 1
fi

# Check port
if netstat -tuln 2>/dev/null | grep -q ":8000" || ss -tuln 2>/dev/null | grep -q ":8000"; then
    echo "   ✓ 端口 8000 正在监听"
else
    echo "   ✗ 端口 8000 未监听"
    exit 1
fi

echo ""
echo "======================================"
echo "    服务器运行中！"
echo "======================================"
echo ""
echo "📱 访问方式："
echo ""
echo "1. VS Code 内置浏览器："
echo "   http://localhost:8000/simple-test.html  (诊断页面)"
echo "   http://localhost:8000/index.html        (主应用)"
echo ""
echo "2. 外部浏览器："
echo "   - 查看 VS Code 底部的 '端口(PORTS)' 标签"
echo "   - 找到端口 8000 并右键 -> '在浏览器中打开'"
echo ""
echo "3. 查看服务器日志："
echo "   tail -f /tmp/tarot_server.log"
echo ""
echo "======================================"
echo ""

# Test with curl
echo "测试连接..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/simple-test.html | grep -q "200"; then
    echo "✓ HTTP 连接测试成功 (200 OK)"
else
    echo "⚠ HTTP 连接测试失败"
fi

echo ""
echo "按 Ctrl+C 停止服务器"
echo ""

# Keep script running
wait $SERVER_PID
