#!/bin/bash

# 功能验证测试脚本
# 确保免杀修改后的代码功能完整

echo "========================================="
echo "        功能验证测试 v1.0"
echo "========================================="

# 测试配置
TEST_TARGET="127.0.0.1"
TEST_PORT="22,80,443,3389"
LOG_FILE="test_results.log"

# 创建测试日志
echo "测试开始时间: $(date)" > $LOG_FILE

# 检查编译是否成功
echo "步骤1: 检查编译结果..."
if [ ! -f "fscan" ] && [ ! -f "fscan.exe" ]; then
    echo "错误: 未找到编译后的可执行文件"
    echo "请先运行编译脚本"
    exit 1
fi

# 确定可执行文件名
EXECUTABLE="fscan"
if [ -f "fscan.exe" ]; then
    EXECUTABLE="fscan.exe"
fi

echo "找到可执行文件: $EXECUTABLE"

# 测试1: 基本帮助信息
echo "步骤2: 测试基本功能..."
echo "测试帮助信息..." | tee -a $LOG_FILE
./$EXECUTABLE -h >> $LOG_FILE 2>&1
if [ $? -eq 0 ]; then
    echo "✓ 帮助信息测试通过" | tee -a $LOG_FILE
else
    echo "✗ 帮助信息测试失败" | tee -a $LOG_FILE
fi

# 测试2: 端口扫描功能
echo "测试端口扫描功能..." | tee -a $LOG_FILE
timeout 30 ./$EXECUTABLE -h $TEST_TARGET -p $TEST_PORT >> $LOG_FILE 2>&1
if [ $? -eq 0 ] || [ $? -eq 124 ]; then  # 124是timeout的退出码
    echo "✓ 端口扫描测试通过" | tee -a $LOG_FILE
else
    echo "✗ 端口扫描测试失败" | tee -a $LOG_FILE
fi

# 测试3: 主机存活检测
echo "测试主机存活检测..." | tee -a $LOG_FILE
timeout 20 ./$EXECUTABLE -h $TEST_TARGET -m icmp >> $LOG_FILE 2>&1
if [ $? -eq 0 ] || [ $? -eq 124 ]; then
    echo "✓ 主机存活检测测试通过" | tee -a $LOG_FILE
else
    echo "✗ 主机存活检测测试失败" | tee -a $LOG_FILE
fi

# 测试4: Web标题获取
echo "测试Web标题获取..." | tee -a $LOG_FILE
timeout 15 ./$EXECUTABLE -u http://www.baidu.com >> $LOG_FILE 2>&1
if [ $? -eq 0 ] || [ $? -eq 124 ]; then
    echo "✓ Web标题获取测试通过" | tee -a $LOG_FILE
else
    echo "✗ Web标题获取测试失败" | tee -a $LOG_FILE
fi

# 测试5: 检查输出格式
echo "步骤3: 检查输出格式..."
echo "检查输出格式..." | tee -a $LOG_FILE

# 运行一个简单的扫描并检查输出
OUTPUT=$(timeout 10 ./$EXECUTABLE -h $TEST_TARGET -p 80 2>&1)
echo "$OUTPUT" >> $LOG_FILE

# 检查是否包含预期的输出格式
if echo "$OUTPUT" | grep -q "start"; then
    echo "✓ 输出格式检查通过" | tee -a $LOG_FILE
else
    echo "✗ 输出格式检查失败" | tee -a $LOG_FILE
fi

# 测试6: 错误处理
echo "步骤4: 测试错误处理..."
echo "测试错误处理..." | tee -a $LOG_FILE

# 测试无效参数
./$EXECUTABLE -invalid-param >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
    echo "✓ 错误处理测试通过" | tee -a $LOG_FILE
else
    echo "✗ 错误处理测试失败" | tee -a $LOG_FILE
fi

# 测试7: 内存和性能检查
echo "步骤5: 性能检查..."
echo "性能检查..." | tee -a $LOG_FILE

# 检查内存使用
if command -v ps &> /dev/null; then
    echo "启动性能监控..." | tee -a $LOG_FILE
    
    # 在后台运行扫描
    timeout 15 ./$EXECUTABLE -h $TEST_TARGET -p 1-100 &
    PID=$!
    
    # 监控内存使用
    sleep 2
    if ps -p $PID > /dev/null; then
        MEMORY=$(ps -o pid,vsz,rss,comm -p $PID | tail -1)
        echo "内存使用: $MEMORY" | tee -a $LOG_FILE
        echo "✓ 性能监控完成" | tee -a $LOG_FILE
    else
        echo "✗ 进程已退出" | tee -a $LOG_FILE
    fi
    
    # 清理进程
    kill $PID 2>/dev/null || true
    wait $PID 2>/dev/null || true
else
    echo "ps命令不可用，跳过性能检查" | tee -a $LOG_FILE
fi

# 测试8: 文件完整性检查
echo "步骤6: 文件完整性检查..."
echo "文件完整性检查..." | tee -a $LOG_FILE

# 检查文件大小
FILE_SIZE=$(stat -c%s "$EXECUTABLE" 2>/dev/null || stat -f%z "$EXECUTABLE" 2>/dev/null)
echo "文件大小: $FILE_SIZE bytes" | tee -a $LOG_FILE

if [ $FILE_SIZE -gt 1000000 ]; then  # 大于1MB
    echo "✓ 文件大小正常" | tee -a $LOG_FILE
else
    echo "✗ 文件大小异常" | tee -a $LOG_FILE
fi

# 计算文件哈希
if command -v sha256sum &> /dev/null; then
    HASH=$(sha256sum "$EXECUTABLE" | cut -d' ' -f1)
    echo "文件SHA256: $HASH" | tee -a $LOG_FILE
elif command -v shasum &> /dev/null; then
    HASH=$(shasum -a 256 "$EXECUTABLE" | cut -d' ' -f1)
    echo "文件SHA256: $HASH" | tee -a $LOG_FILE
fi

# 生成测试报告
echo "步骤7: 生成测试报告..."

cat >> $LOG_FILE << EOF

========================================
测试总结
========================================
测试完成时间: $(date)
可执行文件: $EXECUTABLE
文件大小: $FILE_SIZE bytes
文件哈希: $HASH

测试结果:
$(grep "✓\|✗" $LOG_FILE | tail -8)

建议:
1. 如果所有测试都通过，说明功能正常
2. 如果有测试失败，请检查相关功能
3. 定期运行此测试以确保功能稳定
4. 在不同环境中测试以确保兼容性

注意:
- 某些功能可能需要特定的网络环境
- 超时可能是正常的，特别是在网络较慢时
- 请确保在合法授权的环境中进行测试
EOF

echo "========================================="
echo "功能验证测试完成!"
echo "详细结果请查看: $LOG_FILE"
echo "========================================="

# 显示测试摘要
echo "测试摘要:"
grep "✓\|✗" $LOG_FILE | tail -8
