# maccms10 Docker 部署包

## 目录结构
```
.
├── Dockerfile          # PHP 7.4-fpm + 所需扩展 + 源码
├── docker-compose.yml  # nginx + php + mariadb 三服务编排
├── nginx.conf          # ThinkPHP5 伪静态规则
├── .env.example        # 环境变量示例
└── maccms10-master/    # CMS 源码 (从官方仓库解压)
```

## 本地测试部署

```bash
cp .env.example .env
# 编辑 .env，改成自己的密码
docker compose up -d --build
```

访问 `http://localhost:8080/install/index.php` 走安装向导。

数据库连接信息填：
- 主机: `db`
- 端口: `3306`
- 数据库名 / 用户名 / 密码：对应 `.env` 里设置的值

## 推送到 GitHub 供 Coolify 使用

```bash
cd 这个目录
git init
git add .
git commit -m "maccms10 docker deploy kit"
git branch -M main
git remote add origin https://github.com/你的用户名/你的仓库名.git
git push -u origin main
```

## Coolify 部署步骤

1. 新建资源 → **Public Repository**（或 Private，如果仓库是私有的要配置 Deploy Key）
2. 填入你 push 上去的仓库地址
3. Build Pack 选择 **Docker Compose**
4. **Docker Compose Location** 填 `docker-compose.yml`（注意后缀是 `.yml`）
5. 在 Environment Variables 里设置 `DB_ROOT_PASSWORD` / `DB_NAME` / `DB_USER` / `DB_PASSWORD`
6. Deploy
7. 部署完成后，把 `nginx` 服务的 80 端口映射到你的域名（Coolify 会自动配 Traefik + HTTPS）
8. 访问 `https://你的域名/install/index.php` 完成安装向导

## 注意事项

- 首次构建会比较慢，因为要装 PHP 扩展。
- `runtime/` 和 `upload/` 目录已在 Dockerfile 里设置 777 权限，安装/使用中如果遇到写入报错，检查这两个目录权限。
- 安装完成后建议删除或限制访问 `/install` 目录，防止被重新初始化。
- PHP 版本锁定在 7.4，如果要升级到 8.x，需要先确认 maccms10 代码兼容性（老代码可能有已废弃函数调用）。
