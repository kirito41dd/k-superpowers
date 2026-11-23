# idiomatic-rust 的实践来源与取舍

[idiomatic-rust](../../skills/idiomatic-rust/SKILL.md) 由 K Superpowers 独立维护。业务仓库离线使用发布版本中的规则。维护者在本仓库判断哪些实践值得纳入日常 Rust 实现、审查和诊断。

## 现有来源

| 来源 | 用途 | 何时检查 |
|---|---|---|
| [BeautifulRust](beautiful-rust.md) | 持续跟踪 Rust 编写与审查建议，记录采用范围、上次评估的提交和许可 | 发布插件前，或主动跟进该项目时 |
| Rust 标准库 | 核对 trait 和 API 的语义契约。已用于说明借用键查询时的相等性与哈希要求。[Borrow](https://doc.rust-lang.org/std/borrow/trait.Borrow.html) · [HashMap::get](https://doc.rust-lang.org/std/collections/struct.HashMap.html#method.get) | 修改对应规则，或目标工具链的行为有疑问时 |

## 怎样吸收一条实践

从具体问题出发。官方文档用来核对语言和库的保证，社区项目、代码评审和生产故障可以提供值得复用的取舍。先看现有规则能否解释这个场景，能补充新的判断依据时再写入对应段落。同一条规则可以有多个依据，正文按 Rust 问题组织。

遇到不同建议时，区分必须满足的契约和有条件的工程偏好。例如，判断是否应跨 `.await` 持锁时，要看具体锁类型，也要看等待期间是否需要独占资源。保留会改变判断的条件，并尊重目标项目的 MSRV、公共 API 和约定。

新增来源时，记下它支持哪条规则，以及可回查的文档、版本或脱敏案例。长期吸收某个项目的更新时，再登记检查方式和独立基线。一次性参考可在修改相关规则时复核。引用或复用外部内容时保留相应出处和许可。
