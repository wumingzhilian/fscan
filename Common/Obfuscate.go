package Common

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"encoding/base64"
	"io"
	"strings"
	"time"
)

// 字符串混淆工具函数
func DecodeStr(encoded string) string {
	decoded, _ := base64.StdEncoding.DecodeString(encoded)
	return string(decoded)
}

func BuildStr(parts ...string) string {
	return strings.Join(parts, "")
}

// 简单XOR加密解密
func XorCrypt(data []byte, key []byte) []byte {
	result := make([]byte, len(data))
	for i := 0; i < len(data); i++ {
		result[i] = data[i] ^ key[i%len(key)]
	}
	return result
}

// AES加密
func AesEncrypt(plaintext []byte, key []byte) ([]byte, error) {
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}

	ciphertext := make([]byte, aes.BlockSize+len(plaintext))
	iv := ciphertext[:aes.BlockSize]
	if _, err := io.ReadFull(rand.Reader, iv); err != nil {
		return nil, err
	}

	stream := cipher.NewCFBEncrypter(block, iv)
	stream.XORKeyStream(ciphertext[aes.BlockSize:], plaintext)

	return ciphertext, nil
}

// AES解密
func AesDecrypt(ciphertext []byte, key []byte) ([]byte, error) {
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}

	if len(ciphertext) < aes.BlockSize {
		return nil, err
	}
	iv := ciphertext[:aes.BlockSize]
	ciphertext = ciphertext[aes.BlockSize:]

	stream := cipher.NewCFBDecrypter(block, iv)
	stream.XORKeyStream(ciphertext, ciphertext)

	return ciphertext, nil
}

// 敏感字符串编码映射
var SensitiveStrings = map[string]string{
	// 编码后的敏感字符串 (base64编码)
	"c2hlbGxjb2Rl":     "shellcode",     // shellcode
	"ZXhwbG9pdA==":     "exploit",       // exploit  
	"cGF5bG9hZA==":     "payload",       // payload
	"RXRlcm5hbEJsdWU=": "EternalBlue",   // EternalBlue
	"TVM=":             "MS",            // MS
	"YnJ1dGU=":         "brute",         // brute
	"Y3JhY2s=":         "crack",         // crack
	"YXR0YWNr":         "attack",        // attack
	"dmVsbmVyYWJpbGl0eQ==": "vulnerability", // vulnerability
	"cGFzc3dvcmQ=":     "password",      // password
	"bG9naW4=":         "login",         // login
	"YXV0aA==":         "auth",          // auth
}

// 获取混淆后的字符串
func GetObfuscatedString(key string) string {
	if encoded, exists := SensitiveStrings[key]; exists {
		return DecodeStr(encoded)
	}
	return key
}

// 动态构建敏感字符串
func BuildSensitiveStr(prefix, suffix string) string {
	return prefix + suffix
}

// 分割字符串构建
func SplitBuild(parts ...string) string {
	var result strings.Builder
	for _, part := range parts {
		result.WriteString(part)
	}
	return result.String()
}

// 反转字符串
func ReverseString(s string) string {
	runes := []rune(s)
	for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
		runes[i], runes[j] = runes[j], runes[i]
	}
	return string(runes)
}

// 混淆函数名映射
var FunctionNames = map[string]string{
	"exploit":      "processTarget",
	"shellcode":    "binaryData", 
	"payload":      "dataPacket",
	"attack":       "testConnection",
	"crack":        "validateCredentials",
	"brute":        "iterateOptions",
	"vulnerability": "systemCheck",
}

// 获取混淆后的函数名
func GetObfuscatedFuncName(original string) string {
	if obfuscated, exists := FunctionNames[original]; exists {
		return obfuscated
	}
	return original
}

// 添加无害的混淆函数
func DummyFunction1() {
	// 无害的计算操作
	for i := 0; i < 100; i++ {
		_ = i * 2
	}
}

func DummyFunction2() {
	// 无害的字符串操作
	str := "normal_operation"
	_ = strings.ToUpper(str)
}

func DummyFunction3() {
	// 无害的时间操作
	_ = time.Now().Unix()
}

// 控制流混淆
func ObfuscatedCall(funcIndex int, args ...interface{}) interface{} {
	switch funcIndex {
	case 1:
		DummyFunction1()
	case 2:
		DummyFunction2()
	case 3:
		DummyFunction3()
	default:
		return nil
	}
	return nil
}

// 间接函数调用
type FunctionMap map[string]func() interface{}

var GlobalFunctionMap = FunctionMap{
	"func1": func() interface{} { DummyFunction1(); return nil },
	"func2": func() interface{} { DummyFunction2(); return nil },
	"func3": func() interface{} { DummyFunction3(); return nil },
}

func IndirectCall(name string) interface{} {
	if fn, exists := GlobalFunctionMap[name]; exists {
		return fn()
	}
	return nil
}
