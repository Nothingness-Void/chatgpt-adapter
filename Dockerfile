# 使用官方的 Golang 镜像作为构建环境
FROM --platform=$BUILDPLATFORM golang:1.17 as builder

# 设定工作目录
WORKDIR /app

# 将你的 Go 源代码复制到 Docker 镜像中
COPY . .

# 设置 Go 环境变量并编译你的程序
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN GOOS=linux GOARCH=$(echo $TARGETPLATFORM | cut -f2 -d '/') go build -o exec cmd/exec.go

# 使用 scratch 作为最小化的运行环境
FROM scratch

# 从构建环境中复制编译好的二进制文件到当前镜像
COPY --from=builder /app/exec /app/exec

# 设置容器启动时的默认命令
CMD ["/app/exec", "--port", "8080", "]
