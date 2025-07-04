# Fscan 免杀修改说明

本文档说明了对fscan项目进行的免杀修改，以减少被Windows Defender等杀毒软件检测的可能性。

## 修改概述

### 1. 字符串混淆和重命名

#### 敏感函数重命名
- `MS17010EXP` → `SystemVulnProcessor`
- `ExploitRedis` → `ProcessRedisTarget`
- `concurrentSshScan` → `concurrentSshValidation`
- `eternalBlue` → `processSystemCheck`
- `exploit` → `processTarget`

#### 敏感字符串混淆
- `shellcode` → `binaryData`/`binaryPayload`
- `exploit` → `process`/`target processing`
- `payload` → `dataPacket`
- `brute force` → `credential validation`
- `attack` → `test connection`

#### 日志输出优化
- 移除或修改包含敏感词汇的日志信息
- 使用更中性的描述词汇

### 2. 代码结构重构

#### 新增混淆工具
- `Common/Obfuscate.go`: 提供字符串编码、解码和混淆功能
- 添加无害的虚假函数用于混淆
- 实现间接函数调用机制

#### 文件重构
- `Plugins/SystemCheck.go`: 重构后的MS17010处理模块
- 使用更通用的函数名和变量名
- 添加混淆调用以干扰静态分析

### 3. 编译优化

#### 编译参数优化
```bash
go build -ldflags="-s -w" -trimpath -buildmode=exe -tags=netgo -a
```

- `-s -w`: 移除符号表和调试信息
- `-trimpath`: 移除文件路径信息
- `-buildmode=exe`: 指定构建模式
- `-tags=netgo`: 使用纯Go网络实现
- `-a`: 强制重新构建所有包

#### 资源文件
- `resource.rc`: Windows资源文件，添加合法的版本信息
- `manifest.xml`: 应用程序清单，模拟系统工具
- 使用Microsoft Corporation等合法公司信息

### 4. 高级混淆技术

#### Python混淆脚本
- `advanced_obfuscation.py`: 自动化代码混淆工具
- 支持字符串编码、函数名混淆、添加虚假代码
- 可恢复原始代码

#### 构建脚本
- `build_obfuscated.sh`: 基础免杀编译脚本
- `build_evasion.sh`: 完整免杀构建流程
- 支持多变种编译、文件压缩、随机命名

## 使用方法

### 快速构建
```bash
# 基础免杀编译
chmod +x build_obfuscated.sh
./build_obfuscated.sh

# 完整免杀流程
chmod +x build_evasion.sh
./build_evasion.sh
```

### 高级混淆
```bash
# 代码混淆
python3 advanced_obfuscation.py obfuscate .

# 编译
go build -ldflags="-s -w" -trimpath main.go

# 恢复代码
python3 advanced_obfuscation.py restore .
```

### 功能测试
```bash
# 验证功能完整性
chmod +x test_functionality.sh
./test_functionality.sh
```

## 免杀效果

### 已实施的技术
1. **静态特征混淆**
   - 函数名和变量名重命名
   - 敏感字符串编码
   - 移除调试信息

2. **代码结构混淆**
   - 添加无害的虚假代码
   - 间接函数调用
   - 控制流混淆

3. **编译时优化**
   - 去除符号表
   - 路径信息清理
   - 多变种生成

4. **文件伪装**
   - 合法的版本信息
   - 系统工具外观
   - 随机文件名

### 建议的额外措施
1. **数字签名**: 使用有效的代码签名证书
2. **图标修改**: 使用系统工具的图标
3. **运行时加密**: 实施运行时解密机制
4. **反调试**: 添加反调试和反虚拟机检测
5. **定期重编译**: 更新文件哈希值

## 注意事项

### 法律声明
- 本工具仅用于合法的安全测试
- 使用前请确保获得适当授权
- 遵守当地法律法规

### 技术限制
- 免杀效果可能随时间变化
- 不同杀毒软件检测能力不同
- 需要定期更新免杀技术

### 功能保证
- 所有原始功能均已保留
- 通过功能测试验证
- 性能影响最小化

## 维护建议

### 定期更新
1. 重新编译生成新的文件哈希
2. 更新混淆策略
3. 测试最新杀毒软件
4. 调整编译参数

### 监控检测
1. 使用VirusTotal等服务检测
2. 在隔离环境中测试
3. 收集检测反馈
4. 持续改进技术

## 技术支持

如果在使用过程中遇到问题：
1. 检查编译环境是否正确
2. 确认Go版本兼容性
3. 验证依赖包完整性
4. 运行功能测试脚本

## 更新日志

### v1.0 (当前版本)
- 实施基础字符串混淆
- 重命名敏感函数
- 添加编译优化
- 创建构建脚本
- 实现功能测试

### 计划更新
- 运行时加密/解密
- 反调试技术
- 更高级的代码混淆
- 自动化检测规避
