# MyAwareness（我的感悟）

一个用于记录和管理每日感悟的 iOS 应用，帮助你捕捉生活中的思考与灵感。

## 项目简介

MyAwareness 是一款简洁实用的个人感悟记录工具，让你随时随地记录生活中的感悟、想法和心得。支持编辑、分享到社交平台等功能，帮助你更好地管理自己的思想碎片。

## 主要功能

### 1. 感悟管理
- **添加感悟**：快速记录你的想法和感悟
- **编辑感悟**：支持对已有感悟进行修改和完善
- **删除感悟**：支持滑动删除不需要的感悟记录
- **时间标记**：自动记录每条感悟的创建时间

### 2. 社交分享
- **微信分享**：支持分享感悟到微信好友
- **朋友圈分享**：支持分享感悟到微信朋友圈
- **多平台支持**：集成 UIActivityViewController，支持更多分享方式

### 3. 设置功能
- **个性签名**：设置和管理个人签名
- **二维码扫描**：内置二维码扫描功能
- **关于页面**：应用信息展示

## 技术架构

### 开发语言与框架
- **语言**：Objective-C
- **平台**：iOS 7.0+
- **IDE**：Xcode

### 核心技术栈

#### 数据持久化
- **FMDB**：SQLite 数据库封装库
  - 用于存储感悟内容
  - 支持 CRUD 操作
  - 提供线程安全的数据库访问

#### 第三方集成
- **微信 SDK (WXApi)**：实现微信分享功能
  - 支持分享到微信会话
  - 支持分享到朋友圈
  - App ID: wx4e0d6fbe4c4bb54b

#### UI 组件
- **UITabBarController**：主界面 Tab 导航
- **UINavigationController**：页面导航管理
- **UITableView**：列表展示感悟内容
- **UITextView**：文本编辑界面

## 项目结构

```
MyAwareness/
├── MyAwareness/                    # 主应用目录
│   ├── AppDelegate.h/m            # 应用代理，配置主界面
│   ├── Defines.h                  # 全局宏定义和常量
│   ├── Awareness/                 # 感悟模块
│   │   ├── ListViewController     # 感悟列表页面
│   │   ├── AwarenessViewController # 感悟编辑页面
│   │   ├── DBManager              # 数据库管理器（单例模式）
│   │   └── Summary                # 感悟数据模型
│   ├── Setting/                   # 设置模块
│   │   ├── SettingViewController  # 设置主页面
│   │   ├── PersonalSignViewController # 个性签名设置
│   │   ├── ScanQRViewController   # 二维码扫描
│   │   └── AboutViewController    # 关于页面
│   ├── Images.xcassets/           # 图片资源
│   └── Info.plist                 # 应用配置文件
├── fmdb/                          # FMDB 数据库框架
│   ├── FMDatabase                 # 数据库核心类
│   ├── FMResultSet                # 查询结果集
│   ├── FMDatabaseQueue            # 数据库队列
│   └── FMDatabasePool             # 数据库连接池
├── WeixinActivity/                # 微信分享模块
│   ├── WeixinSessionActivity      # 微信会话分享
│   ├── WeixinTimelineActivity     # 朋友圈分享
│   └── Resources/                 # 微信 SDK 资源
└── LICENSE                        # Apache 2.0 许可证

```

## 核心实现

### 数据库设计
- **表名**：summary.sqlite
- **字段**：
  - `_id`：主键，自增 ID
  - `content`：感悟内容文本
  - `createTime`：创建时间戳

### 单例模式
使用宏定义实现单例模式（DBManager），确保全局唯一的数据库管理器：
```objective-c
singleton_interface(DBManager)
singleton_implementation(DBManager)
```

### Block 回调
使用 Block 实现页面间数据传递：
- 添加/编辑感悟后回调更新列表
- 更新个性签名后刷新显示

## 安装与运行

### 环境要求
- macOS 系统
- Xcode 6.0 或更高版本
- iOS 7.0 或更高版本的设备/模拟器

### 运行步骤
1. 克隆项目到本地
   ```bash
   git clone [repository-url]
   cd MyAwareness
   ```

2. 打开项目
   ```bash
   open MyAwareness.xcodeproj
   ```

3. 选择目标设备或模拟器

4. 点击运行按钮或使用快捷键 `Cmd + R`

### 微信分享配置
如需使用微信分享功能，需要：
1. 在微信开放平台注册应用
2. 将应用的 App ID 替换到 `AppDelegate.m` 中：
   ```objective-c
   [WXApi registerApp:@"your_app_id"];
   ```
3. 配置 URL Scheme

## 使用说明

### 添加感悟
1. 点击主页右上角的 "+" 按钮
2. 输入你的感悟内容
3. 点击右上角的"保存"按钮

### 编辑感悟
1. 在列表中点击要编辑的感悟
2. 修改内容
3. 点击"保存"完成编辑

### 分享感悟
1. 点击感悟右侧的分享按钮（i 图标）
2. 选择分享目标（微信好友/朋友圈/其他）
3. 完成分享操作

### 删除感悟
在感悟列表中，左滑感悟条目即可删除

## 开发参考

本项目开发过程中参考了以下资源：

- **二维码扫描**：[Swift 二维码扫描 Demo](http://code4app.com/ios/swift%E7%BC%96%E5%86%99%E7%9A%84%E4%BA%8C%E7%BB%B4%E7%A0%81%E6%89%AB%E6%8F%8Fdemo/53d7325c933bf052288b4d43)
- **微信分享**：
  - [分享到微信的 Demo](http://www.cocoachina.com/downloads/code/2013/0225/5718.html)
  - [WeixinActivity](http://code4app.com/ios/WeixinActivity/52a5c8b7cb7e840d118b5e2f)

## 版本信息

- **版本号**：1.0
- **构建版本**：1
- **开发地区**：zh_CN（中国）

## 许可证

本项目采用 Apache License 2.0 开源许可证。详见 [LICENSE](LICENSE) 文件。

## 作者

- **开发者**：luowei (luosai)
- **创建时间**：2015年6月

## 贡献

欢迎提交 Issue 和 Pull Request 来帮助改进这个项目！

---

**注意**：本项目仅供学习和参考使用。使用微信分享功能需要自行申请微信开放平台账号并配置相应的 App ID。