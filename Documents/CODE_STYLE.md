# SoloPro 代码规范

本文档以 `Job` package 的现有实现为基准，约定 SoloPro 后续 Swift / SwiftUI 代码的组织方式、命名、状态管理和验证要求。新增代码应优先保持与现有风格一致，除非有明确的产品或架构原因需要调整。

## 基本原则

- 保持实现直接、局部、可读。优先使用 SwiftUI、SwiftData 和标准库能力，不为简单页面提前抽象复杂架构。
- 页面先表达业务流程，辅助计算和动作放到私有扩展中，避免 `body` 被非 UI 逻辑淹没。
- 类型和 API 的访问级别按模块边界收敛：跨 package 使用的入口设为 `public`，包内细节保持默认 `internal` 或 `private`。
- 代码变更应尽量贴近需求范围，避免顺手重排无关文件或重命名无关类型。

## 文件与模块组织

| 场景 | 规范 | 示例 |
| --- | --- | --- |
| 页面入口 | 放在对应功能目录下，文件名与 View 类型一致 | `TodayJobsPage.swift` |
| 子视图 | 放在页面附近的 `Views` 目录 | `Today/Views/JobRowView.swift` |
| 表单相关类型 | 与表单目录放在一起 | `Form/JobFormView.swift`, `Form/Views/JobFormMode.swift` |
| 模型 | 放在 `Model/Sources/Model/Models` | `Job.swift`, `Customer.swift` |
| Mock 数据 | 放在 `Model/Sources/Model/Mocks` | `Job+Mock.swift` |

建议目录按功能聚合，而不是按通用 UI 类型平铺。只有被多个功能稳定复用的 View 或工具，才考虑上移到共享位置。

## Import 顺序

- 系统框架在前，项目模块在后。
- 每个文件只导入实际需要的模块。
- 常见顺序：`SwiftData`、`SwiftUI`、`Model`。

```swift
import SwiftData
import SwiftUI
import Model
```

仅使用 SwiftUI 视图能力时，不要额外导入 `SwiftData`。仅模型文件按需要导入 `Foundation`、`SwiftData`。

## 命名规范

- 类型、枚举、协议使用 PascalCase：`JobPage`、`JobFormMode`、`JobStatusFilter`。
- 属性、方法、局部变量使用 camelCase：`selectedDate`、`filteredJobs`、`deleteJobs(at:)`。
- 布尔状态使用清晰语义，优先 `is` / `has` / `did` 前缀：`isPresentingJobForm`、`didSeedSampleJobs`。
- View 类型以 `View` 或 `Page` 结尾：页面级入口用 `Page`，可复用片段用 `View`。
- 用户可见文案使用 Title Case，并保持简短：`"Today Jobs"`、`"Add Job"`。

## SwiftUI View 结构

View 文件推荐按以下顺序组织：

1. `import`
2. View 类型声明
3. 环境、查询、绑定属性
4. 外部输入属性
5. `@State` 等本地状态
6. 私有计算属性
7. `body`
8. `#Preview`
9. `private extension` 中的辅助逻辑
10. 文件私有辅助类型

示例结构：

```swift
struct JobsPage: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Job.date) private var jobs: [Job]

    @State private var selectedDate = Date()
    @State private var statusFilter: JobStatusFilter = .all

    var body: some View {
        List {
            // UI content
        }
    }
}

#Preview {
    JobsPage()
        .modelContainer(.mock)
}

private extension JobsPage {
    private var filteredJobs: [Job] {
        // Derived data
    }

    private func deleteJobs(at offsets: IndexSet) {
        // Actions
    }
}
```

## 状态与数据流

- SwiftUI 状态使用 `@State private var`，不要暴露为 internal 或 public。
- SwiftData 上下文通过 `@Environment(\.modelContext)` 获取。
- SwiftData 查询通过 `@Query` 声明，排序条件应写清楚：`@Query(sort: \Job.date)`。
- 可编辑模型使用 `@Bindable`，例如详情页直接编辑 `Job` 的 `status`。
- 表单使用本地 `@State` 缓存输入，保存时再写回模型，避免用户输入过程中直接污染持久化对象。
- 派生数据优先写成私有计算属性，例如 `todayJobs`、`filteredJobs`、`selectedDateInterval`。

## 表单与校验

- 表单页使用 `NavigationStack` + `Form`。
- 必填校验集中在 `canSave` 等私有计算属性中。
- 保存前统一清理输入：使用 `trimmingCharacters(in: .whitespacesAndNewlines)`。
- 空字符串写入可选字段时转换为 `nil`，例如 `notes`。
- 数值输入需要容错，无法解析时使用业务允许的默认值。
- 保存成功后调用 `dismiss()` 关闭表单。

## 列表、导航与工具栏

- 主列表优先使用 `List` 和 `Section`，iOS 页面使用 `.listStyle(.insetGrouped)`。
- 页面级空状态使用 `ContentUnavailableView` 放在 `List.overlay` 中，不要作为 `List` 的 row 或 `Section` 内容；文案说明用户下一步可以做什么。
- 详情导航使用 `NavigationLink(value:)` + `.navigationDestination(for:)`。
- 新增、筛选、删除等操作使用系统控件和 SF Symbols：`Label("Add Job", systemImage: "plus")`。
- 删除入口需使用明确的破坏性语义：`Button(role: .destructive)`。

## UI 风格

- 优先使用系统组件、系统字体和语义色：`.headline`、`.subheadline`、`.secondary`。
- 图标使用 SF Symbols，按钮和菜单项优先使用 `Label`。
- 行内容使用 `HStack` / `VStack` 组织，间距使用小而一致的数值，例如 `6`、`8`、`12`、`16`。
- 金额、日期等展示使用 Swift 格式化 API：`.formatted(.currency(code: "USD"))`、`.dateTime.hour().minute()`。
- 动画默认使用 `.smooth`，只有在交互语义明确需要其他曲线时才单独指定。
- 不在业务页面中加入无关装饰或复杂自定义样式；保持原生、清晰、可扫描。

## 访问控制

| 代码类型 | 访问级别 |
| --- | --- |
| 跨 package 页面入口 | `public struct` + `public init()` |
| package 内部页面或子视图 | 默认 `struct` |
| View 本地状态 | `@State private var` |
| 环境与查询属性 | `private var` |
| 辅助计算属性和动作 | `private` |
| 文件内辅助枚举 | `private enum` |

当一个 View 需要被 App 或其他 package 引用时，显式提供空的 `public init()`，避免默认 initializer 访问级别不足。

## 模型规范

- SwiftData 模型使用 `@Model public final class`。
- 模型属性按身份、核心字段、元数据、关联对象排序。
- initializer 参数使用合理默认值，必填业务字段不提供默认值。
- 避免 force unwrap。可选关系用 `?` 表达，并在 UI 层提供兜底文案。

```swift
@Model
public final class Job {
    public var id: UUID
    public var title: String
    public var date: Date
    public var customer: Customer?
}
```

## 私有扩展

非 UI 辅助逻辑优先放进同文件的 `private extension`：

- 列表过滤、排序、分组。
- 按钮动作和删除逻辑。
- 表单填充和保存逻辑。
- 小型格式化或标题生成。

只有在逻辑被多个文件复用、且语义稳定时，才抽出独立类型或共享扩展。

## Preview 规范

- 每个 View 文件应尽量提供 `#Preview`。
- 需要 SwiftData 的预览必须注入 `.modelContainer(.mock)`。
- 页面预览按实际导航环境包裹 `NavigationStack`。
- 多状态表单可以提供命名预览，例如 `#Preview("Create")`、`#Preview("Edit")`。

## 注释规范

- 不为显而易见的 SwiftUI 结构写注释。
- 只有复杂业务规则、非直觉容错、临时兼容逻辑需要简短注释。
- 保留 Xcode 自动文件头不是强制要求；新增文件可以不添加文件头，重点保持同一文件内部整洁。

## 错误处理与边界

- 用户输入、日期区间、数值解析等边界要有兜底。
- 日期范围优先使用 `Calendar.current.dateInterval(of:for:)`，失败时提供明确 fallback。
- 展示可选数据时提供短兜底文案，例如 `"No Customer"`。
- 删除和写入 SwiftData 时保持逻辑局部清晰，不在 View 中隐藏副作用。

## 测试与验证

- 修改 SwiftUI 或 SwiftData 代码后，优先用 Xcode 的代码诊断或构建验证。
- 影响模型、筛选、表单保存等业务逻辑时，应补充或更新单元测试。
- 影响导航、表单提交流程、空状态等用户路径时，应考虑 UI 测试。
- 测试框架优先使用 Swift Testing；UI 测试使用 XCUIAutomation。

## 提交前检查

- 新增类型、属性、方法命名是否符合 PascalCase / camelCase。
- 访问级别是否收敛，是否只把跨模块入口设为 `public`。
- `body` 是否主要保留 UI 结构，业务逻辑是否下沉到私有属性或方法。
- 表单输入是否做了清理和必填校验。
- Preview 是否可运行，并使用 mock container。
- 是否避免了无关格式化、重命名或重构。
