package main

import (
	"fmt"
	"net"
	"os"

	"github.com/shadow1ng/fscan/Common"
	"github.com/shadow1ng/fscan/Core"
)

// 混淆函数
func dummyNetworkCheck() {
	_, _ = net.LookupHost("example.com")
}

func dummyCalculation() {
	for i := 0; i < 1000; i++ {
		_ = i*i + i - 1
	}
}

func main() {
	// 添加混淆调用
	dummyCalculation()

	Common.InitLogger()

	var Info Common.HostInfo
	Common.Flag(&Info)

	// 解析 CLI 参数
	if err := Common.Parse(&Info); err != nil {
		os.Exit(1)
	}

	// 初始化输出系统，如果失败则直接退出
	if err := Common.InitOutput(); err != nil {
		Common.LogError(fmt.Sprintf(" 初始化输出系统失败 : %v", err))
		os.Exit(1)
	}
	defer Common.CloseOutput()

	// 执行 CLI 扫描逻辑
	Core.Scan(Info)
}
