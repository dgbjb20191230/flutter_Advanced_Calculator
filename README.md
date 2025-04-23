# 高级计算器 Flutter 项目开发文档

- [开发详细指南（中文）](./FLUTTER_CALCULATOR_DEV_GUIDE.md)
- [Development Guide (English)](./FLUTTER_CALCULATOR_DEV_GUIDE_EN.md)

<div align="center">

<table>
  <tr>
    <td align="center">
      <img src="/assets/Screenshot_20250423_124747.jpg" alt="主界面截图" width="320" /><br />
      <sub>应用主界面展示</sub>
    </td>
    <td align="center">
      <img src="/assets/Screenshot_20250423_124754.jpg" alt="科学计算截图" width="320" /><br />
      <sub>科学计算功能界面</sub>
    </td>
  </tr>
</table>

</div>

## 1. 项目构建流程

### 1.1 环境准备
- 安装 Flutter SDK
- 配置 Android Studio/Xcode/VSCode
- 配置环境变量

### 1.2 创建项目
```bash
flutter create flutterjisuanqqi20250421
cd flutterjisuanqqi20250421
```

### 1.3 依赖管理
- 使用 `pubspec.yaml` 管理依赖
- 常用依赖如 provider、intl、flutter_screenutil 等

## 2. 设计理念
- **模块化**：将界面与逻辑分离，便于维护和扩展
- **响应式编程**：利用 Flutter 的状态管理（如 Provider、Bloc）
- **美观易用**：采用 Material Design 设计规范
- **跨平台兼容性**：兼容 Android、iOS、Web、Windows、macOS、Linux

## 3. 开发进程的难易点
### 3.1 难点
- 复杂表达式解析与计算
- 自定义键盘组件的交互
- 跨平台 UI 兼容性
- 状态管理的选择与实现

### 3.2 解决方法
- 使用第三方库（如 math_expressions）处理表达式
- 组件化开发，封装自定义控件
- 针对不同平台做适配与测试
- 采用 Provider 进行全局状态管理

## 4. 打包与发布
### 4.1 Android 打包
```bash
flutter build apk
flutter build appbundle
```
### 4.2 iOS 打包
```bash
flutter build ios
```
### 4.3 Web 打包
```bash
flutter build web
```
### 4.4 桌面端打包（Windows/macOS/Linux）
```bash
flutter build windows
flutter build macos
flutter build linux
```
### 4.5 多平台注意事项
- 确保各平台依赖已配置
- 针对不同平台进行 UI 适配

## 5. 上传到 GitHub
### 5.1 初始化 Git 仓库
```bash
git init
git add .
git commit -m "Initial commit"
```
### 5.2 创建 GitHub 仓库并推送
```bash
git remote add origin https://github.com/yourusername/flutterjisuanqqi20250421.git
git branch -M main
git push -u origin main
```

---

# Advanced Calculator Flutter Project Development Guide

## 1. Project Setup
### 1.1 Environment Preparation
- Install Flutter SDK
- Setup Android Studio/Xcode/VSCode
- Configure environment variables

### 1.2 Create Project
```bash
flutter create flutterjisuanqqi20250421
cd flutterjisuanqqi20250421
```

### 1.3 Dependency Management
- Use `pubspec.yaml` to manage dependencies
- Common dependencies: provider, intl, flutter_screenutil, etc.

## 2. Design Philosophy
- **Modularization**: Separate UI and logic for maintainability
- **Reactive Programming**: Use state management (Provider, Bloc)
- **User-friendly UI**: Follow Material Design guidelines
- **Cross-platform compatibility**: Support Android, iOS, Web, Windows, macOS, Linux

## 3. Development Difficulties & Solutions
### 3.1 Difficulties
- Complex expression parsing and evaluation
- Custom keyboard component interactions
- Cross-platform UI compatibility
- State management selection and implementation

### 3.2 Solutions
- Use libraries (e.g., math_expressions) for expression evaluation
- Component-based development, encapsulate custom widgets
- Platform-specific adaptation and testing
- Use Provider for global state management

## 4. Packaging & Release
### 4.1 Android
```bash
flutter build apk
flutter build appbundle
```
### 4.2 iOS
```bash
flutter build ios
```
### 4.3 Web
```bash
flutter build web
```
### 4.4 Desktop (Windows/macOS/Linux)
```bash
flutter build windows
flutter build macos
flutter build linux
```
### 4.5 Multi-platform Notes
- Ensure dependencies are configured for each platform
- Adapt UI for different platforms

## 5. Upload to GitHub
### 5.1 Initialize Git Repository
```bash
git init
git add .
git commit -m "Initial commit"
```
### 5.2 Create GitHub Repo and Push
```bash
git remote add origin https://github.com/yourusername/flutterjisuanqqi20250421.git
git branch -M main
git push -u origin main
```
