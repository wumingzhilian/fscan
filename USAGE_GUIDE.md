# Fscan 免杀版本使用指南

## 快速开始

### 1. 环境准备
```bash
# 确保Go环境已安装
go version

# 确保Python3已安装（用于高级混淆）
python3 --version

# 安装可选工具
# UPX (用于文件压缩)
# windres (用于Windows资源)
```

### 2. 一键构建
```bash
# 克隆或下载项目
cd fscan

# 执行免杀构建
chmod +x build_evasion.sh
./build_evasion.sh
```

### 3. 验证功能
```bash
# 运行功能测试
chmod +x test_functionality.sh
./test_functionality.sh
```

## 详细使用方法

### 基础编译
```bash
# 标准免杀编译
chmod +x build_obfuscated.sh
./build_obfuscated.sh
```

### 高级混淆编译
```bash
# 1. 代码混淆
python3 advanced_obfuscation.py obfuscate .

# 2. 编译
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build \
    -ldflags="-s -w -X main.version=1.0.0" \
    -trimpath \
    -buildmode=exe \
    -tags=netgo \
    -a \
    -o fscan_evasion.exe \
    main.go

# 3. 恢复代码
python3 advanced_obfuscation.py restore .
```

### 自定义构建
```bash
# 修改编译参数
export CGO_ENABLED=0
export GOOS=windows
export GOARCH=amd64

# 自定义ldflags
go build -ldflags="-s -w -X main.version=custom -X main.buildTime=$(date +%s)" \
    -trimpath \
    -o custom_fscan.exe \
    main.go
```

## 使用示例

### 基本扫描
```bash
# 端口扫描
fscan_evasion.exe -h 192.168.1.1/24

# 指定端口
fscan_evasion.exe -h 192.168.1.1 -p 22,80,443,3389

# 主机存活检测
fscan_evasion.exe -h 192.168.1.0/24 -m icmp
```

### 服务扫描
```bash
# SSH服务扫描
fscan_evasion.exe -h 192.168.1.1 -m ssh

# Redis扫描
fscan_evasion.exe -h 192.168.1.1 -m redis

# 多服务扫描
fscan_evasion.exe -h 192.168.1.1 -m ssh,ftp,redis
```

### Web扫描
```bash
# Web标题获取
fscan_evasion.exe -u http://example.com

# Web漏洞扫描
fscan_evasion.exe -u http://example.com -m webpoc
```

### 高级功能
```bash
# 使用代理
fscan_evasion.exe -h 192.168.1.1 -proxy http://127.0.0.1:8080

# 自定义线程数
fscan_evasion.exe -h 192.168.1.1/24 -t 50

# 输出到文件
fscan_evasion.exe -h 192.168.1.1/24 -o result.txt
```

## 免杀优化建议

### 1. 定期重编译
```bash
# 每次使用前重新编译
./build_evasion.sh

# 或使用不同的编译参数
go build -ldflags="-s -w -X main.buildTime=$(date +%s)" main.go
```

### 2. 文件名随机化
```bash
# 使用随机文件名
mv fscan.exe "SystemTool_$(openssl rand -hex 4).exe"
```

### 3. 添加数字签名
```bash
# 如果有代码签名证书
osslsigncode sign -pkcs12 cert.p12 -pass password \
    -in fscan.exe -out fscan_signed.exe
```

### 4. 修改文件属性
```bash
# 使用资源编辑器修改
# - 文件版本信息
# - 图标
# - 描述信息
```

## 检测规避技巧

### 1. 运行环境
- 在真实物理机上运行
- 避免在虚拟机中测试
- 使用不同的操作系统版本

### 2. 网络行为
- 使用合理的扫描间隔
- 避免过于激进的扫描
- 模拟正常的网络流量

### 3. 文件存储
- 存储在系统目录中
- 使用合法的文件名
- 避免在桌面或下载目录

### 4. 执行方式
- 通过脚本间接执行
- 使用计划任务
- 从内存中执行

## 故障排除

### 编译问题
```bash
# 检查Go环境
go env

# 清理模块缓存
go clean -modcache

# 重新下载依赖
go mod download
```

### 运行问题
```bash
# 检查文件权限
chmod +x fscan.exe

# 检查依赖库
ldd fscan  # Linux
otool -L fscan  # macOS
```

### 功能问题
```bash
# 运行功能测试
./test_functionality.sh

# 检查日志输出
fscan.exe -h 127.0.0.1 -v
```

## 安全注意事项

### 法律合规
- 仅在授权环境中使用
- 遵守当地法律法规
- 获得明确的测试许可

### 技术安全
- 在隔离环境中测试
- 避免对生产系统造成影响
- 保护扫描结果的机密性

### 道德使用
- 仅用于防御性安全测试
- 不用于恶意攻击
- 负责任地披露发现的漏洞

## 技术支持

### 常见问题
1. **编译失败**: 检查Go版本和环境变量
2. **功能异常**: 运行功能测试脚本
3. **检测问题**: 尝试不同的混淆参数
4. **性能问题**: 调整线程数和超时设置

### 获取帮助
- 查看详细的错误日志
- 运行诊断脚本
- 检查网络连接
- 验证目标可达性

### 更新维护
- 定期检查项目更新
- 更新免杀技术
- 测试新的杀毒软件
- 改进混淆策略

## 版本信息

当前版本: v1.0 (免杀优化版)
- 基础字符串混淆
- 函数名重命名
- 编译优化
- 构建脚本
- 功能测试

计划更新:
- 运行时加密
- 反调试技术
- 更高级混淆
- 自动化规避
