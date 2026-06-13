# Solo Contractor Assistant 技术设计文档

## 1. 技术架构

### 客户端
- SwiftUI
- SwiftData
- Observation
- Async/Await

### 云同步
- CloudKit

### 地图
- MapKit
- CoreLocation

### 通知
- UserNotifications

### AI
- Apple Foundation Models（优先）
- OpenAI API（备用）

---

## 2. 分层架构

### Presentation Layer
负责：
- SwiftUI View
- Navigation
- Widget
- Live Activities

### Domain Layer
负责：
- Business Logic
- UseCase
- Validation

### Data Layer
负责：
- SwiftData
- CloudKit
- Network

---

## 3. SwiftData 模型

### Customer

```swift
@Model
final class Customer {
    var id: UUID
    var name: String
    var phone: String?
    var email: String?
    var address: String?
    var notes: String?
    var createdAt: Date

    @Relationship(deleteRule: .cascade)
    var jobs: [Job]
}
```

### Job

```swift
@Model
final class Job {
    var id: UUID
    var title: String
    var date: Date
    var location: String
    var price: Double
    var notes: String?
    var status: JobStatus

    var customer: Customer?
}
```

### JobStatus

```swift
enum JobStatus: String, Codable {
    case scheduled
    case inProgress
    case completed
    case canceled
}
```

---

## 4. 模块设计

### 客户管理

功能：
- 创建客户
- 编辑客户
- 删除客户
- 客户搜索
- 客户标签

### 工作管理

功能：
- 创建工单
- 修改工单
- 工作状态流转
- 工作历史

### 日历

功能：
- 月视图
- 周视图
- 日视图

### 收入统计

功能：
- 日收入
- 周收入
- 月收入
- 年收入

---

## 5. CloudKit

Container:

```text
iCloud.com.company.contractor
```

同步策略：

- Customer
- Job
- Settings

全部自动同步

冲突策略：

```text
Last Write Wins
```

---

## 6. 地图模块

### Job Route

输入：

- 今日工单

输出：

- 导航顺序

支持：

- Apple Maps
- Google Maps

---

## 7. Widget

### Small Widget

显示：

- 下一项工作
- 开始时间

### Medium Widget

显示：

- 今日工作数量
- 今日收入

---

## 8. Live Activities

显示：

- 下一客户
- 出发倒计时
- 地址

---

## 9. AI模块

### AI Quick Entry

输入：

Tomorrow 2pm cleaning John $150

输出：

- Customer
- Date
- Price

### Voice Input

语音转工单

---

## 10. 订阅系统

StoreKit 2

Product:

```text
monthly_pro
yearly_pro
```

权限：

- Unlimited Customers
- Unlimited Jobs
- AI Features

---

## 11. MVP 开发顺序

Phase 1
- Customer
- Job
- Calendar

Phase 2
- Notification
- Dashboard

Phase 3
- MapKit
- Route

Phase 4
- AI

---

## 12. 非功能需求

性能：

- App启动 < 2秒
- 页面切换 < 300ms

稳定性：

- Crash Free > 99.8%

支持系统：

- iOS 26+
