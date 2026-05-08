<div align="center">

# KeSchedule
### 一个基于 Flutter 的课程表应用

<a href="README_EN.md">English</a>
&nbsp;&nbsp;|&nbsp;&nbsp;
简体中文
</p>

[![GitHub release](https://img.shields.io/github/v/release/Mashiro0619/KeSchedule?color=black&label=Stable&logo=github)](https://github.com/Mashiro0619/KeSchedule/releases/latest/)
[![GitHub all releases](https://img.shields.io/github/downloads/Mashiro0619/KeSchedule/total?label=Downloads&logo=github)](https://github.com/Mashiro0619/KeSchedule/releases/)
[![GitHub Repo stars](https://img.shields.io/github/stars/Mashiro0619/KeSchedule?color=informational&label=Stars)](https://github.com/Mashiro0619/KeSchedule/stargazers)
[![Flutter](https://img.shields.io/badge/Flutter-App-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-AGPL%20v3-A42E2B?logo=gnu)](LICENSE)

</div>


<p align="center">
  <a href="https://play.google.com/store/apps/details?id=com.mashiro.classmate">
    <img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" alt="Get it on Google Play" height="100">
  </a>
  <br>
  <a href="https://github.com/Mashiro0619/KeSchedule/releases">
    <img src="https://img.shields.io/badge/Get%20it%20on-GitHub%20Releases-blue?style=for-the-badge&logo=github" alt="Get it on GitHub Releases" height="28">
  </a>
</p>

## 截图展示

<div align="center">
<img src="docs/screenshots/s1.jpg" width="20%" />
<img src="docs/screenshots/s2.jpg" width="20%" />
<img src="docs/screenshots/s3.jpg" width="20%" />
<img src="docs/screenshots/s4.jpg" width="20%" />
<img src="docs/screenshots/s5.jpg" width="20%" />
<img src="docs/screenshots/s6.jpg" width="20%" />
<img src="docs/screenshots/s7.jpg" width="20%" />
</div>

## 功能特性

- 多课表管理：支持新建、切换、编辑、删除课表，并按周切换查看学期进度
- 课程编辑：支持课程名称、地点、教师、周次、时间、关联节次、备注与自定义字段编辑
- 节次时间集：支持复用、编辑、导入导出，并可在多个课表之间共享
- 课程提醒与展示：支持当前课程 / 下一节课程高亮、保留空白时间、显示已结束课程 / 之后课程，以及课表网格线开关
- 主题设置：支持浅色 / 深色 / 跟随系统，支持单色主题与多彩界面配色
- 学校网页 / HTML 导入：支持在应用内打开学校网站导入当前页面，也支持手动粘贴 HTML 内容导入
- 导入预览与合并：导入前可查看解析结果、选择节次时间集，并决定导入为新课表或替换当前课表
- 数据导入导出：支持课表 JSON 文件导入导出、文本导入导出，以及分享
- 学校站点管理：支持新增、编辑、删除学校登录地址，并导入导出学校站点 JSON


欢迎大家通过提交 PR 为 `assets/school_sites.json` 补充和扩展学校站点配置。


## 项目结构

```text
lib/
├─ config/       # 应用配置与接口地址
├─ data/         # 平台相关的数据存储实现
├─ l10n/         # 本地化资源、语言元数据与生成代码
├─ models/       # 课表、课程、学校站点、导入响应等数据模型
├─ providers/    # 应用状态管理
├─ screens/      # 页面，如主页、设置页、导入页、学校站点管理页
├─ services/     # 导入导出、解析、分享、更新等服务
└─ widgets/      # 课表网格、课程编辑、课程详情、导入结果等组件

assets/
├─ default_period_times.json
└─ school_sites.json

web/
└─ api.php
```

## 隐私政策

课表、课表设置、节次时间集和学校站点配置保存在设备或浏览器本地，不会自动上传到开发者服务器。
只有在你主动使用导入、导出、分享、外部链接、更新检查或网页解析等功能时，应用才会读取相关内容或把对应操作交给系统或你配置的解析接口处理。

首次进入应用时会显示隐私政策确认；隐私政策全文可在 [https://mashiro.tech/KeSchedule/privacy.html](https://mashiro.tech/KeSchedule/privacy.html) 查看。


## 学校网页导入后端

项目提供了一个可自部署的 PHP 中转接口：[web/api.php](web/api.php)。应用默认会从 [lib/config/app_config.dart](lib/config/app_config.dart) 读取学校网页导入接口地址和更新源地址，也可以通过 `--dart-define` 覆盖。

- `SCHOOL_IMPORT_API_BASE_URL`：学校网页 / HTML 导入接口地址
- `KeSchedule_UPDATE_VERSION_URL`：自定义更新信息地址

### 后端配置

你需要修改 `web/api.php` 顶部配置区：

- `$relayUrl`：上游 AI 接口地址
- `$relayToken`：你的 API Key
- `$model`：使用的模型
- `$timeoutSeconds`：请求超时时间，当前默认 120 秒
- `$sourceByteLimit`：单次提交内容大小上限，当前默认 300KB
- `$maxParsesPerIpPerDay`：同一 IP 每日最大解析次数，当前默认 5 次

### 后端行为

- 通过你自己的 PHP 服务转发解析请求，不直接在客户端暴露上游密钥
- 返回统一 JSON 响应，便于客户端展示解析结果和错误信息
- 对提交内容执行大小限制与按 IP 的每日解析次数限制
- 支持学校网页导入和手动粘贴 HTML 导入场景
- 会把页面内容、可选页面标题、页面 URL 和当前应用语言一并提交到解析接口


## 开源协议与第三方说明

- 本项目源码基于 [GNU Affero General Public License v3.0](LICENSE) 开源
- 项目内分发的启动图标及相关平台图标资源包含第三方授权内容，详见 [NOTICE](NOTICE)
- Flutter 依赖与第三方库许可可在应用内“设置 → 开源许可”查看
