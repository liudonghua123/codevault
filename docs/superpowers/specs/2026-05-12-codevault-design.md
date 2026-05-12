# CodeVault - 跨平台代码查看器设计文档

**日期：** 2026-05-12
**版本：** v1.0

---

## 1. 项目概述

**项目名称：** CodeVault
**类型：** 跨平台 Flutter 应用程序
**核心功能：** 本地文件浏览 + 代码编辑/查看，支持语法高亮、折叠、跳转，深色模式，跨平台运行

---

## 2. 技术架构

### 2.1 技术栈

| 类别 | 技术选型 |
|------|----------|
| 框架 | Flutter 3.x |
| Flutter SDK | ~/apps/flutter |
| 状态管理 | Riverpod |
| 路由 | go_router |
| 编辑器核心 | flutter_code_editor + code_text_field |
| 语法高亮 | flutter_highlight / highlight |
| 文件浏览 | flutter_fancy_tree_view |
| 文件操作 | file_picker, path_provider |
| 持久化 | shared_preferences |
| 平台 | Windows, macOS, Linux, iOS, Android, Web |

### 2.2 目录结构

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── theme/
│   ├── constants/
│   └── utils/
├── features/
│   ├── file_explorer/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── editor/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── settings/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── shared/
    ├── widgets/
    └── providers/
```

---

## 3. UI/UX 设计

### 3.1 整体布局

```
┌──────────────────────────────────────────────────────────┐
│  工具栏 (文件操作 / 搜索 / 设置 / 主题切换)              │
├─────────────┬────────────────────────────────────────────┤
│             │  标签栏 (已打开文件)                        │
│   文件树    ├────────────────────────────────────────────┤
│   浏览器    │                                            │
│             │            代码编辑区                       │
│   150-400px │         (支持多标签)                       │
│   可拖拽    │                                            │
│             │                                            │
├─────────────┴────────────────────────────────────────────┤
│  状态栏 (光标位置 / 文件编码 / 语言 / 行号)              │
└──────────────────────────────────────────────────────────┘
```

### 3.2 主题设计

**默认深色主题 (VS Code 风格)：**

| 元素 | 颜色 |
|------|------|
| 背景 (主) | #1E1E1E |
| 背景 (侧边栏) | #252526 |
| 背景 (编辑器) | #1E1E1E |
| 前景 (文字) | #D4D4D4 |
| 主色调 | #007ACC |
| 边框 | #3C3C3C |
| 选中项 | #094771 |

**浅色主题：**

| 元素 | 颜色 |
|------|------|
| 背景 (主) | #FFFFFF |
| 背景 (侧边栏) | #F3F3F3 |
| 前景 (文字) | #333333 |
| 主色调 | #0066B8 |
| 边框 | #E0E0E0 |

### 3.3 字体

- 代码编辑器：JetBrains Mono / Source Code Pro / monospace
- UI 界面：系统默认字体
- 默认字号：14px (可配置 10-24px)

---

## 4. 功能模块

### 4.1 文件浏览器

**功能列表：**
- 打开本地目录作为工作区
- 文件树展示，支持展开/折叠
- 文件类型图标区分
- 右键菜单：新建文件/文件夹、删除、重命名
- 最近打开目录记录 (最近 10 个)
- 刷新目录
- 文件搜索过滤

**文件操作：**
- 新建文件
- 新建文件夹
- 删除 (带确认)
- 重命名
- 复制路径

### 4.2 代码编辑器

**核心功能：**
- 语法高亮 (60+ 语言预设)
- 代码折叠 (region 折叠、基于缩进的折叠)
- 跳转到行 (Ctrl+G)
- 搜索和替换 (Ctrl+F, Ctrl+H)
- 撤销/重做 (Ctrl+Z, Ctrl+Y)
- 自动保存 (可配置间隔)
- 行号显示
- 当前行高亮
- 选择区域高亮
- 光标位置同步到状态栏

**支持的语法高亮语言 (预设)：**
dart, python, javascript, typescript, java, kotlin, swift, go, rust, c, cpp, csharp, ruby, php, html, css, json, yaml, xml, markdown, sql, bash, powershell, dockerfile, toml, ini, xml, graphql, vue, svelte, lua, perl, r, scala, groovy, cmake, makefile, nginx, apache

**用户自定义文件类型映射：**
- 预设语言映射表
- 用户可添加自定义扩展名 (如 `.abc` → `dart`)
- 用户可编辑/删除现有映射
- 配置存储在 shared_preferences

### 4.3 设置系统

**设置项：**

| 分类 | 设置项 | 默认值 |
|------|--------|--------|
| 主题 | 深色/浅色切换 | 深色 |
| 编辑器 | 字体大小 | 14 |
| 编辑器 | 字体家族 | JetBrains Mono |
| 编辑器 | 行高 | 1.5 |
| 编辑器 | TAB 大小 | 4 |
| 编辑器 | 显示行号 | true |
| 编辑器 | 自动保存 | true |
| 编辑器 | 自动保存间隔(秒) | 30 |
| 外观 | 侧边栏宽度 | 250 |
| 外观 | 工具栏图标大小 | 24 |
| 文件关联 | 语言映射表 | 预设 |

### 4.4 平台适配

**桌面端 (Windows/macOS/Linux)：**
- 完整功能
- 文件树 + 编辑器布局
- 键盘快捷键完整支持

**移动端 (iOS/Android)：**
- 简化工具栏
- 文件树可收起
- 支持手势操作
- 触摸友好的按钮大小

**Web 端：**
- 文件打开功能替换为文件上传
- drag & drop 支持
- 所有核心编辑功能保留

---

## 5. GitHub Actions CI/CD

### 5.1 触发条件

```yaml
on:
  push:
    tags: ['v*']
  workflow_dispatch:
    inputs:
      platforms:
        type: multi-select
        options: [windows, macos, linux, web]
```

### 5.2 构建矩阵

| 平台 | 输出格式 |
|------|----------|
| Windows | .exe (NSIS installer) |
| macOS | .dmg |
| Linux | .AppImage, .deb |
| Web | dist/ (用于 gh-pages) |

### 5.3 发布目标

- **GitHub Release (latest):** 所有平台安装包
  - 使用 `peaceiris/actions-gh-pages@v3` 发布到 latest release
- **gh-pages 分支:** Web build
  - 使用 `softprops/action-gh-release@v1` 创建 release

### 5.4 workflow 文件结构

```
.github/
└── workflows/
    └── release.yml
```

---

## 6. 里程碑规划

### Milestone 1: 项目基础
- Flutter 项目初始化
- 依赖配置
- 主题系统
- 基础布局框架

### Milestone 2: 文件浏览器
- 目录打开功能
- 文件树展示
- 文件操作 (CRUD)

### Milestone 3: 代码编辑器
- 基础编辑功能
- 语法高亮
- 代码折叠

### Milestone 4: 高级功能
- 搜索/替换
- 设置系统
- 用户自定义文件类型

### Milestone 5: CI/CD
- GitHub Actions 配置
- 多平台构建
- 发布流程

### Milestone 6: 平台适配
- 移动端适配
- Web 适配
- 测试和优化

---

## 7. 扩展性设计

- **插件化架构预留：** 模块之间通过接口通信，便于后续扩展
- **主题可扩展：** 支持导入外部主题
- **语言包预留：** i18n 支持
- **快捷键可配置：** 用户自定义快捷键