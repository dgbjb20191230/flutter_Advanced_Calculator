# Flutter 高级科学计算器项目开发文档

## 目录
- [项目简介](#项目简介)
- [开发环境搭建](#开发环境搭建)
- [项目结构说明](#项目结构说明)
- [主要技术栈](#主要技术栈)
- [界面设计与功能详解](#界面设计与功能详解)
- [核心组件与命名建议](#核心组件与命名建议)
- [状态管理与 Provider/Riverpod 示例](#状态管理与-providerriverpod-示例)
- [国际化配置与多语言切换](#国际化配置与多语言切换)
- [测试与质量保证](#测试与质量保证)
- [扩展性与维护建议](#扩展性与维护建议)
- [典型开发流程建议](#典型开发流程建议)
- [打包与发布](#打包与发布)
- [自动上传 Release](#自动上传-release)
- [常见问题与建议](#常见问题与建议)
- [附录：代码片段与进阶用法](#附录代码片段与进阶用法)

---

## 项目简介
本项目是一个基于 Flutter 的高级科学计算器应用，支持基本与科学计算、内存操作、历史记录、主题切换等功能。UI 现代、响应式，支持 Windows、macOS、Linux、Android、iOS 多平台。

---

## 开发环境搭建
1. 安装 Flutter SDK
   - 官网：https://flutter.dev
   - 推荐版本：3.x 及以上
2. 安装 Dart SDK（一般随 Flutter 自带）
3. 配置环境变量
   - 将 `flutter/bin` 加入系统 PATH
4. 安装开发工具
   - 推荐 VSCode、Android Studio、IntelliJ IDEA
5. 安装依赖
   ```bash
   flutter pub get
   ```

---

## 项目结构说明
```
├── lib/
│   ├── main.dart           # 应用入口
│   ├── screens/            # 各界面
│   ├── widgets/            # 通用组件
│   ├── models/             # 数据模型
│   ├── services/           # 业务逻辑与服务
│   └── utils/              # 工具类
├── assets/                 # 图片、字体等资源
├── test/                   # 单元测试
├── pubspec.yaml            # 依赖与资源配置
├── README.md               # 项目说明
└── FLUTTER_CALCULATOR_DEV_GUIDE.md # 本开发文档
```

---

## 主要技术栈
- **框架**：Flutter 3.x
- **语言**：Dart
- **状态管理**：Provider / Riverpod / Bloc（任选其一，推荐 Provider）
- **本地存储**：shared_preferences / hive
- **打包工具**：Flutter build, FVM, 脚本自动化
- **测试**：Flutter test

---

## 界面设计（详细）
### 1. 主界面结构
#### 1.1 显示区（Display Area）
- 主结果区：大号字体显示当前输入或最终结果，支持溢出自动缩小字体。
- 表达式区：较小字体显示完整输入表达式，支持多行滚动。
- 状态指示：如“角度/弧度”、“内存已存储”等小图标或文字。

#### 1.2 科学功能区（Scientific Functions）
- 第一行：sin、cos、tan、ln、log、π、e
- 第二行：x²、xʸ、√、∛、1/x、|x|、( )
- 角度/弧度切换：独立按钮，切换后高亮显示当前模式
- 括号输入：自动提示括号配对，错误时高亮

#### 1.3 数字与基本运算区（Numeric & Basic Operations）
- 布局：
  ```
  [ 7 ] [ 8 ] [ 9 ] [ ÷ ]
  [ 4 ] [ 5 ] [ 6 ] [ × ]
  [ 1 ] [ 2 ] [ 3 ] [ - ]
  [ 0 ] [ . ] [ = ] [ + ]
  ```
- 功能键：
  - C/AC（清除/全清）
  - ⌫（退格）
  - +/-（正负号切换）

#### 1.4 内存与历史区（Memory & History）
- 内存操作：MC（清空）、MR（读取）、M+（加）、M-（减）、MS（存储）
- 历史记录：按钮弹窗，展示最近 N 条历史，支持点击回填、单条删除、全部清空

#### 1.5 主题与设置
- 主题切换：明暗色一键切换，跟随系统或手动切换
- 设置入口：可选，进入高级设置（如精度、历史条数、声音开关等）

#### 1.6 响应式适配
- 桌面端：按钮大间距，支持键盘快捷键（数字、运算符、Enter、Backspace 等）
- 移动端：按钮适配屏幕宽度，支持滑动操作

---

## 功能说明（详细）
### 2.1 基本运算
- 支持连续输入与优先级自动识别（如 2 + 3 × 4 = 14）
- 支持小数、负数、括号嵌套
- 自动校验非法输入（如连续运算符、括号不匹配）

### 2.2 科学运算
- 三角函数（sin、cos、tan）：支持角度/弧度切换
- 反三角函数（asin、acos、atan）：可通过长按或二级菜单切换
- 对数（ln、log₁₀）、指数（eˣ）、幂运算（xʸ）、开方（√、∛）
- 常数 π、e 直接输入
- 绝对值、倒数、平方、立方等

### 2.3 内存功能
- MC：清空内存
- MR：读取内存（显示并可直接参与下次运算）
- MS：当前结果存入内存
- M+ / M-：当前结果加/减到内存
- 内存状态指示（如有存储高亮）

### 2.4 历史记录
- 自动保存最近 N 条运算（如 20 条，可设置）
- 历史弹窗展示，点击某条可回填到输入区
- 支持单条删除与全部清空
- 历史数据本地持久化

### 2.5 主题与设置
- 明暗色主题一键切换
- 可选“跟随系统”模式
- 设置项包括：历史条数、声音/震动、精度、按钮布局等

### 2.6 键盘与触控支持
- 桌面端支持键盘输入（数字、运算符、Enter、Backspace、Esc）
- 移动端支持长按、滑动清除等手势
- 按钮有点击动画和声音反馈（可设置）

### 2.7 错误处理与提示
- 非法表达式输入高亮提示
- 运算溢出/无效结果（如除零）弹窗或红色提示
- 括号不匹配自动提示

### 2.8 国际化与可扩展性
- 支持中英文切换（国际化）
- 代码结构组件化，便于后续扩展如函数绘图、单位换算等

---

## UI 组件与命名建议
### 1. 主要组件划分
- `CalculatorScreen`：主界面容器
  - `DisplayPanel`：顶部表达式与结果显示区
  - `ScientificPad`：科学功能按钮区
  - `NumberPad`：数字与基本运算按钮区
  - `MemoryPanel`：内存操作按钮区
  - `HistoryPanel`：历史记录弹窗/侧栏
  - `ThemeSwitcher`：主题切换按钮
  - `SettingsDrawer`：设置抽屉/弹窗

### 2. 推荐命名与职责
| 组件名            | 作用描述                                   |
|-------------------|------------------------------------------|
| DisplayPanel      | 当前表达式、结果、状态指示显示           |
| ScientificPad     | sin/cos/tan、幂、根号、π、e 等按钮        |
| NumberPad         | 0-9、.、+、-、×、÷、=、C/AC、⌫、±        |
| MemoryPanel       | MC、MR、MS、M+、M-                        |
| HistoryPanel      | 展示、回填、删除历史记录                  |
| ThemeSwitcher     | 明暗色切换                                |
| SettingsDrawer    | 设置项（历史条数、精度、声音等）          |

---

## 代码结构与状态管理建议
- 推荐使用 Provider 或 Riverpod 进行全局状态管理，管理如下状态：
  - 当前输入表达式
  - 当前结果
  - 历史记录列表
  - 内存值
  - 当前主题
  - 角度/弧度模式
  - 错误提示状态
- 业务逻辑与 UI 分离，复杂运算逻辑可放在 `services/calculator_service.dart`，便于测试与维护。

---

## 测试与质量保证
### 1. 单元测试
- 对核心计算逻辑（加减乘除、科学函数、括号优先级）编写单元测试，确保各种边界输入下结果正确。
- 推荐目录：`test/services/calculator_service_test.dart`

### 2. UI 测试
- 编写 Widget 测试，确保主要界面组件渲染和交互无误。
- 推荐目录：`test/widgets/`

### 3. 集成测试
- 跨平台打包后，分别在 Windows、macOS、Android、iOS 上实际运行，测试主要功能和适配性。

---

## 扩展性与维护建议
- 组件化设计，便于后续添加新功能（如单位换算、函数绘图、历史导出等）。
- 采用国际化方案（如 `flutter_localizations`），方便后续多语言支持。
- 代码风格统一，建议使用 `flutter format` 和 `dart analyze` 保持代码规范。
- 文档持续更新，重要变更及时同步到开发文档和 README。

---

## 典型开发流程建议
1. 先实现主界面静态布局，确保响应式适配。
2. 分步实现核心功能（基本运算 → 科学运算 → 内存/历史 → 主题/设置）。
3. 边开发边补充单元和 Widget 测试。
4. 每完成一个阶段，在主流平台（桌面/移动）实际运行体验。
5. 版本发布前，整理好 `releases/` 文件夹，按文档上传 Release。

---

## 打包与发布
### 1. 版本设置
在 `pubspec.yaml` 文件中设置版本号：
```yaml
version: 1.2.0+3  # 格式为 版本名+版本号
```
- 版本名(1.2.0): 用户可见版本，遵循语义化版本规范
- 版本号(3): 构建编号，每次发布递增

### 2. 桌面端打包
```bash
# Windows
flutter build windows --release  # 默认打包
flutter build windows --release --target-platform=windows-x64  # 指定64位架构

# macOS
flutter build macos --release
flutter build macos --release --build-name=2.0.0 --build-number=10  # 覆盖版本信息

# Linux
flutter build linux --release
flutter build linux --release --target-platform=linux-x64  # 指定64位架构
```

### 3. 移动端打包
```bash
# Android
flutter build apk  # 默认打包
flutter build apk --split-per-abi  # 分别生成不同架构的APK
flutter build apk --target-platform android-arm,android-arm64  # 指定特定架构
flutter build apk --build-name=2.0.0 --build-number=10  # 覆盖版本信息
flutter build appbundle  # 生成AAB格式(Google Play推荐)

# iOS
flutter build ios --release  # 生成iOS应用
flutter build ipa --build-name=2.0.0 --build-number=10  # 生成IPA文件并覆盖版本信息
```

### 4. 架构配置
#### Android架构配置
在 `android/app/build.gradle.kts` 中配置支持的架构：
```kotlin
android {
    // ...
    defaultConfig {
        // ...
        ndk {
            abiFilters += listOf("armeabi-v7a", "arm64-v8a", "x86_64")
        }
    }
}
```

#### 减小APK体积
```bash
# 仅打包arm64架构(最常见的手机架构)
flutter build apk --target-platform=android-arm64 --split-per-abi
```

### 5. 打包后文件位置
- **Windows**: `build\windows\runner\Release\`
- **macOS**: `build/macos/Build/Products/Release/`
- **Linux**: `build/linux/x64/release/bundle/`
- **Android APK**: `build/app/outputs/flutter-apk/`
- **Android AAB**: `build/app/outputs/bundle/release/`
- **iOS**: `build/ios/iphoneos/`
- **iOS IPA**: `build/ios/ipa/`

### 6. 整理发布包
- 建议统一放入 `releases/` 文件夹，并采用英文命名

---

## 自动上传 Release
1. **安装 GitHub CLI**
   - https://cli.github.com/
   - Windows 可用 winget 安装：
     ```powershell
     winget install --id GitHub.cli
     ```
2. **登录 GitHub**
   ```bash
   gh auth login
   ```
3. **上传安装包到 Release**
   - 进入项目根目录，执行：
     ```bash
     gh release create v1.0.0 releases/Calculator_1.0.0_windows.zip releases/Calculator_1.0.0_android.apk --title "Calculator v1.0.0" --notes "Flutter 多平台安装包"
     ```
   - 或追加上传：
     ```bash
     gh release upload v1.0.0 releases/Calculator_1.0.0_windows.zip
     ```

---

## 常见问题与建议
- 打包桌面端需先配置好各平台依赖（如 Windows 需 MSVC、macOS 需 Xcode）。
- Android 需配置签名，iOS 需 Apple 账号和证书。
- 推荐使用英文文件名，避免兼容性问题。
- 遇到依赖冲突可尝试 `flutter pub upgrade`。
- 打包失败请先清理：
  ```bash
  flutter clean
  ```
- 发布新版本只需更改版本号和文件名，无需重复创建 Release。

---

如有问题欢迎提交 Issue 或联系开发者。

---

## 附录：Riverpod 状态管理与复杂国际化用法

### 1. Riverpod 状态管理示例

#### 1.1 添加依赖

在 `pubspec.yaml` 增加（任选其一，推荐 Riverpod）：

```yaml
dependencies:
  flutter_riverpod: ^2.4.0
  # 或
  provider: ^6.0.5
```

#### 1.2 Riverpod 示例：计算器表达式与结果状态

**lib/providers/calculator_provider.dart**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 计算器状态类
class CalculatorState {
  final String expression;
  final String result;
  CalculatorState({required this.expression, required this.result});

  CalculatorState copyWith({String? expression, String? result}) {
    return CalculatorState(
      expression: expression ?? this.expression,
      result: result ?? this.result,
    );
  }
}

// 状态管理器
class CalculatorNotifier extends StateNotifier<CalculatorState> {
  CalculatorNotifier() : super(CalculatorState(expression: '', result: '0'));

  void input(String value) {
    state = state.copyWith(expression: state.expression + value);
  }

  void clear() {
    state = CalculatorState(expression: '', result: '0');
  }

  void calculate() {
    // 实际应调用计算服务
    state = state.copyWith(result: '42');
  }
}

// Provider
final calculatorProvider =
    StateNotifierProvider<CalculatorNotifier, CalculatorState>(
        (ref) => CalculatorNotifier());
```

**在 Widget 中使用**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculator_provider.dart';

class DisplayPanel extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(state.expression, style: TextStyle(fontSize: 24)),
        Text(state.result, style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class NumberPad extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(calculatorProvider.notifier);
    return Row(
      children: [
        ElevatedButton(
          onPressed: () => notifier.input('1'),
          child: Text('1'),
        ),
        ElevatedButton(
          onPressed: () => notifier.clear(),
          child: Text('C'),
        ),
        ElevatedButton(
          onPressed: () => notifier.calculate(),
          child: Text('='),
        ),
      ],
    );
  }
}
```

**main.dart 启用 Riverpod**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: CalculatorApp()));
}
```

---

### 2. 更复杂的国际化用法

#### 2.1 支持多语言切换

**a. 支持更多语言**

在 `pubspec.yaml` 的 `supportedLocales` 增加更多语言：

```dart
supportedLocales: const [
  Locale('en', ''),
  Locale('zh', ''),
  Locale('ja', ''),
  Locale('es', ''),
  // ...
],
```

并为每种语言创建对应的 `.arb` 文件（如 `app_ja.arb`、`app_es.arb`）。

**b. 动态切换语言**

在设置页或主题切换按钮旁添加语言切换功能：

```dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: Localizations.localeOf(context),
      onChanged: (Locale? locale) {
        if (locale != null) {
          // 需要结合 Provider/Riverpod 维护全局 Locale 状态
          // 例如 context.read(localeProvider.notifier).state = locale;
        }
      },
      items: [
        DropdownMenuItem(child: Text('English'), value: Locale('en')),
        DropdownMenuItem(child: Text('简体中文'), value: Locale('zh')),
        DropdownMenuItem(child: Text('日本語'), value: Locale('ja')),
      ],
    );
  }
}
```

**c. 通过 Provider 管理 Locale**

```dart
final localeProvider = StateProvider<Locale>((ref) => Locale('en'));

class CalculatorApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      // ...
      locale: locale,
      // ...
    );
  }
}
```

**d. 使用国际化字符串**

```dart
Text(AppLocalizations.of(context)!.equals)
```

---

Riverpod 可优雅地管理所有全局状态（表达式、结果、主题、语言等）。国际化推荐用 ARB 文件集中管理，支持动态切换和多语言扩展。结合 Provider/Riverpod，可以实现全局主题、语言、历史记录等的统一管理。

如需具体某个功能的完整代码实现（如历史记录、主题切换、国际化 Provider 方案），请继续提问！
