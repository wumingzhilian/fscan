#!/bin/bash

# 免杀编译脚本
# 使用多种技术来减少杀毒软件检测

echo "开始免杀编译..."

# 设置编译环境变量
export CGO_ENABLED=0
export GOOS=windows
export GOARCH=amd64

# 创建临时目录
TEMP_DIR="temp_build_$(date +%s)"
mkdir -p $TEMP_DIR

# 复制源代码到临时目录
cp -r . $TEMP_DIR/
cd $TEMP_DIR

# 1. 修改包名和导入路径 (可选)
echo "步骤1: 准备源代码..."

# 2. 使用高级编译参数
echo "步骤2: 编译优化..."

# 编译参数说明:
# -ldflags="-s -w" : 去除符号表和调试信息
# -trimpath : 去除文件路径信息
# -buildmode=exe : 构建可执行文件
# -tags=netgo : 使用纯Go网络实现
# -a : 强制重新构建所有包

go build \
    -ldflags="-s -w -X main.version=1.0.0 -X main.buildTime=$(date +%Y%m%d%H%M%S)" \
    -trimpath \
    -buildmode=exe \
    -tags=netgo \
    -a \
    -o fscan_obfuscated.exe \
    main.go

if [ $? -eq 0 ]; then
    echo "编译成功!"
else
    echo "编译失败!"
    exit 1
fi

# 3. 使用UPX压缩 (可选，但可能增加检测率)
echo "步骤3: 文件压缩..."
if command -v upx &> /dev/null; then
    echo "使用UPX压缩..."
    upx --best --lzma fscan_obfuscated.exe
else
    echo "UPX未安装，跳过压缩步骤"
fi

# 4. 添加资源和图标 (可选)
echo "步骤4: 添加资源..."
if command -v windres &> /dev/null; then
    echo "添加Windows资源..."
    # 这里可以添加图标和版本信息
    # windres -i resource.rc -o resource.o
    # go build -ldflags="-s -w resource.o" ...
else
    echo "windres未安装，跳过资源添加"
fi

# 5. 文件签名 (需要证书)
echo "步骤5: 文件签名..."
if [ -f "certificate.p12" ]; then
    echo "使用证书签名..."
    # osslsigncode sign -pkcs12 certificate.p12 -pass password -in fscan_obfuscated.exe -out fscan_signed.exe
    echo "签名功能需要有效证书"
else
    echo "未找到证书文件，跳过签名步骤"
fi

# 6. 生成随机文件名
echo "步骤6: 生成最终文件..."
RANDOM_NAME="SystemTool_$(openssl rand -hex 4).exe"
cp fscan_obfuscated.exe "../$RANDOM_NAME"

# 清理临时文件
cd ..
rm -rf $TEMP_DIR

echo "编译完成!"
echo "输出文件: $RANDOM_NAME"
echo ""
echo "免杀建议:"
echo "1. 定期重新编译以更新文件哈希"
echo "2. 使用不同的编译参数组合"
echo "3. 考虑使用代码混淆工具"
echo "4. 添加合法的数字签名"
echo "5. 修改文件图标和版本信息"
echo "6. 使用打包工具进一步处理"
