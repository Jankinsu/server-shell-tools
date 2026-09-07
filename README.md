# server-shell-tools

个人 Linux / VPS Shell 工具仓库。第一阶段提供 SSH 登录欢迎页；后续可继续加入网络、系统状态、Docker、systemd 和常用运维工具。

## 设计原则

公共展示逻辑放在 Git 中，节点差异放在每台服务器本地的 `node.conf` 中。这样多台服务器可以共用同一套脚本，节点身份又不会写死或提交到仓库。

## 目录

```text
bin/welcome.sh           SSH 登录欢迎页
config/node.conf.example 节点配置模板
install.sh               安装和更新入口
.gitignore               本地配置与临时文件忽略规则
.gitattributes            强制仓库文本使用 LF 换行
LICENSE                  MIT License
```

## 安装

在服务器上执行：

```bash
git clone <your-repository-url> ~/server-shell-tools
cd ~/server-shell-tools
bash install.sh
```

安装脚本会创建 `~/bin` 和 `~/.config/xm-server`，将 `~/bin/welcome.sh` 软链接到仓库脚本，并在 `~/.config/xm-server/node.conf` 不存在时复制模板。它只追加一次欢迎页调用，不覆盖已有 `.bashrc` 或已有配置。

编辑本机身份：

```bash
nano ~/.config/xm-server/node.conf
```

每台服务器只需要修改 `NODE_ID` 和 `NODE_NAME`，然后重新 SSH 登录测试。

## 多节点使用

每台服务器分别执行一次安装流程，并分别配置自己的 `~/.config/xm-server/node.conf`：

```bash
NODE_ID="XM / NODE-01"
NODE_NAME="Oracle-AMD-1"
```

公共脚本随仓库更新；节点配置只存在本机，不进入 Git。

## 更新

由于安装使用软链接，更新仓库后脚本自动使用新版本：

```bash
cd ~/server-shell-tools
git pull --ff-only
```

## 卸载

先从 `~/.bashrc` 删除 `# xm-server welcome` 及其下一行，再执行：

```bash
rm -f ~/bin/welcome.sh
```

如不再需要节点配置，可手动删除 `~/.config/xm-server/node.conf`。卸载不会自动删除用户配置。

## 修改欢迎页

编辑 `bin/welcome.sh`，提交并推送后，在各服务器执行 `git pull --ff-only`。每台服务器的身份信息只修改本地 `~/.config/xm-server/node.conf`。

## Shell 文件换行格式

所有 Shell 脚本必须使用 LF 换行。Windows 编辑 Shell 脚本时，务必保存为 LF；否则可能遇到：

```text
/usr/bin/env: 'bash\r': No such file or directory
```

这是 CRLF 换行导致的。可在 Linux 服务器上修复：

```bash
sed -i 's/\r$//' file.sh
```

欢迎页中的公网 IPv4 / IPv6 查询分别使用 `curl -4` / `curl -6`，各自最多等待 2 秒；查询失败时显示 `Unavailable`，不会阻塞 SSH 登录。
