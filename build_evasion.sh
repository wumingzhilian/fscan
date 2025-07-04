#!/bin/bash

# 完整的免杀构建流程
# 集成多种反检测技术

set -e

echo "========================================="
echo "        免杀构建流程 v1.0"
echo "========================================="

# 配置变量
PROJECT_NAME="fscan"
OUTPUT_DIR="output"
TEMP_DIR="temp_$(date +%s)"

# 创建输出目录
mkdir -p $OUTPUT_DIR
mkdir -p $TEMP_DIR

# 步骤1: 代码混淆
echo "步骤1: 代码混淆..."
if [ -f "advanced_obfuscation.py" ]; then
    python3 advanced_obfuscation.py obfuscate .
    echo "代码混淆完成"
else
    echo "警告: 未找到混淆脚本，跳过代码混淆"
fi

# 步骤2: 编译多个变种
echo "步骤2: 编译多个变种..."

# 变种1: 标准编译
echo "编译变种1: 标准版本..."
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build \
    -ldflags="-s -w -X main.version=1.0.1 -X main.buildTime=$(date +%Y%m%d%H%M%S)" \
    -trimpath \
    -o $OUTPUT_DIR/${PROJECT_NAME}_v1.exe \
    main.go

# 变种2: 优化编译
echo "编译变种2: 优化版本..."
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build \
    -ldflags="-s -w -X main.version=2.0.1 -X main.buildTime=$(date +%Y%m%d%H%M%S)" \
    -trimpath \
    -buildmode=exe \
    -tags=netgo \
    -a \
    -gcflags="-N -l" \
    -o $OUTPUT_DIR/${PROJECT_NAME}_v2.exe \
    main.go

# 变种3: 最小化编译
echo "编译变种3: 最小化版本..."
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build \
    -ldflags="-s -w -X main.version=3.0.1" \
    -trimpath \
    -tags=netgo \
    -o $OUTPUT_DIR/${PROJECT_NAME}_v3.exe \
    main.go

# 步骤3: 文件处理
echo "步骤3: 文件后处理..."

cd $OUTPUT_DIR

# 生成随机文件名
for file in *.exe; do
    if [ -f "$file" ]; then
        # 生成随机名称
        random_name="SystemTool_$(openssl rand -hex 4).exe"
        cp "$file" "$random_name"
        echo "生成: $random_name"
        
        # 计算文件哈希
        echo "SHA256: $(sha256sum $random_name | cut -d' ' -f1)"
    fi
done

cd ..

# 步骤4: UPX压缩 (可选)
echo "步骤4: 文件压缩..."
if command -v upx &> /dev/null; then
    echo "使用UPX压缩部分文件..."
    cd $OUTPUT_DIR
    
    # 只压缩部分文件以提供选择
    files=(*.exe)
    if [ ${#files[@]} -gt 0 ]; then
        # 压缩第一个文件作为示例
        upx --best --lzma "${files[0]}" -o "compressed_${files[0]}"
        echo "压缩完成: compressed_${files[0]}"
    fi
    
    cd ..
else
    echo "UPX未安装，跳过压缩"
fi

# 步骤5: 生成报告
echo "步骤5: 生成构建报告..."

cat > $OUTPUT_DIR/build_report.txt << EOF
免杀构建报告
=============

构建时间: $(date)
项目名称: $PROJECT_NAME

生成的文件:
$(ls -la $OUTPUT_DIR/*.exe | awk '{print $9, $5}')

文件哈希:
$(cd $OUTPUT_DIR && sha256sum *.exe)

免杀建议:
1. 定期重新编译以更新文件签名
2. 使用不同的编译参数组合
3. 考虑添加数字签名
4. 修改文件图标和版本信息
5. 使用运行时加密/解密
6. 实施反调试和反虚拟机检测

注意事项:
- 请在合法授权的环境中使用
- 遵守当地法律法规
- 仅用于安全测试目的
EOF

# 步骤6: 清理
echo "步骤6: 清理临时文件..."
rm -rf $TEMP_DIR

# 恢复代码 (如果进行了混淆)
if [ -f "advanced_obfuscation.py" ]; then
    echo "恢复原始代码..."
    python3 advanced_obfuscation.py restore .
fi

echo "========================================="
echo "构建完成!"
echo "输出目录: $OUTPUT_DIR"
echo "请查看 $OUTPUT_DIR/build_report.txt 获取详细信息"
echo "========================================="

# 显示文件列表
echo "生成的文件:"
ls -la $OUTPUT_DIR/
