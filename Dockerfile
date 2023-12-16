# 使用官方的 Golang 镜像作为构建环境
FROM golang:1.17 as builder

# 设定工作目录
WORKDIR /app

# 将你的 Go 源代码复制到 Docker 镜像中
COPY . .

# 设置 Go 环境变量并编译你的程序
# 这里我们使用 linux/amd64 作为示例，你可以根据需要更改
RUN GOOS=linux GOARCH=amd64 go build cmd/exec.go

# 使用 scratch 作为最小化的运行环境
FROM scratch

# 从构建环境中复制编译好的二进制文件到当前镜像
COPY --from=builder /app/exec /app/exec

# 设置容器启动时的默认命令
CMD ["/app/exec", "--port", "8080", "]
