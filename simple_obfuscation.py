#!/usr/bin/env python3
"""
简化的Go代码混淆脚本
用于基本的字符串和函数名混淆
"""

import os
import re
import random
import string

class SimpleGoObfuscator:
    def __init__(self):
        self.function_map = {}
        
    def generate_random_name(self, prefix="", length=8):
        """生成随机名称"""
        chars = string.ascii_letters + string.digits
        random_part = ''.join(random.choice(chars) for _ in range(length))
        return f"{prefix}{random_part}"
    
    def obfuscate_function_names(self, content):
        """混淆敏感函数名"""
        # 敏感函数名列表
        sensitive_functions = [
            'exploit', 'attack', 'crack', 'brute', 'hack',
            'shellcode', 'payload', 'backdoor', 'trojan'
        ]
        
        for func in sensitive_functions:
            if func not in self.function_map:
                self.function_map[func] = self.generate_random_name("func_", 8)
            
            # 替换函数定义和调用
            pattern = r'\b' + func + r'\b'
            content = re.sub(pattern, self.function_map[func], content, flags=re.IGNORECASE)
        
        return content
    
    def obfuscate_comments(self, content):
        """混淆敏感注释"""
        sensitive_keywords = [
            'exploit', 'attack', 'hack', 'crack', 'vulnerability',
            'backdoor', 'trojan', 'malware', 'virus', 'shellcode'
        ]
        
        lines = content.split('\n')
        for i, line in enumerate(lines):
            if line.strip().startswith('//'):
                for keyword in sensitive_keywords:
                    if keyword.lower() in line.lower():
                        lines[i] = '// Normal operation'
                        break
        
        return '\n'.join(lines)
    
    def obfuscate_file(self, file_path):
        """混淆单个文件"""
        print(f"混淆文件: {file_path}")
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # 备份原文件
            backup_path = f"{file_path}.backup"
            with open(backup_path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            # 应用混淆
            content = self.obfuscate_comments(content)
            content = self.obfuscate_function_names(content)
            
            # 写入混淆后的内容
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            print(f"混淆完成: {file_path}")
            
        except Exception as e:
            print(f"混淆文件失败 {file_path}: {e}")
    
    def obfuscate_project(self, project_dir):
        """混淆整个项目"""
        print(f"开始混淆项目: {project_dir}")
        
        # 查找所有Go文件
        go_files = []
        for root, dirs, files in os.walk(project_dir):
            for file in files:
                if file.endswith('.go') and not file.endswith('_test.go'):
                    go_files.append(os.path.join(root, file))
        
        print(f"找到 {len(go_files)} 个Go文件")
        
        # 混淆每个文件
        for file_path in go_files:
            self.obfuscate_file(file_path)
        
        print("项目混淆完成!")
    
    def restore_project(self, project_dir):
        """恢复项目到原始状态"""
        print(f"恢复项目: {project_dir}")
        
        backup_files = []
        for root, dirs, files in os.walk(project_dir):
            for file in files:
                if file.endswith('.go.backup'):
                    backup_files.append(os.path.join(root, file))
        
        for backup_file in backup_files:
            original_file = backup_file[:-7]  # 移除.backup后缀
            if os.path.exists(original_file):
                os.remove(original_file)
            os.rename(backup_file, original_file)
            print(f"恢复: {original_file}")
        
        print("项目恢复完成!")

def main():
    import sys
    
    if len(sys.argv) < 2:
        print("用法: python3 simple_obfuscation.py <command> [project_dir]")
        print("命令:")
        print("  obfuscate <dir>  - 混淆项目")
        print("  restore <dir>    - 恢复项目")
        return
    
    command = sys.argv[1]
    project_dir = sys.argv[2] if len(sys.argv) > 2 else "."
    
    obfuscator = SimpleGoObfuscator()
    
    if command == "obfuscate":
        obfuscator.obfuscate_project(project_dir)
    elif command == "restore":
        obfuscator.restore_project(project_dir)
    else:
        print(f"未知命令: {command}")

if __name__ == "__main__":
    main()
