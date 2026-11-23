# BeautifulRust 上游维护

BeautifulRust 是本仓库 Rust skill 的一个[持续跟踪来源](idiomatic-rust.md)。在仓库根目录运行以下命令即可检查更新。

```sh
bash scripts/check-beautiful-rust
```

脚本只读查询上游 `main` 并与[最近已评估的提交](beautiful-rust.rev)比较。退出码 `0` 表示相同，`1` 表示有待评估的版本并输出两个完整 SHA 和比较链接，`2` 表示查询或基线出错。遇到网络错误可以稍后重试，保留原基线。业务仓库使用随插件发布的本地指南。

## 有更新时怎么处理

1. 打开输出的比较链接，按打印出的两个提交评估。跟踪 `rust-best-practices` 和 `rust-review`，以及影响这两者的参考资料、lint、示例和许可证。若历史被改写，直接对照两个提交的文件树；旧版本无法核实时，先查明来源再更新记录。
2. 判断哪些变化会改善本地 Rust 实现、审查或诊断。采纳的规则按本项目语言重写，用具体场景核对；遇到与现有契约冲突的规则，简记原因。仅涉及迁移专题 `rust-port`、上游网站或工具包装的变化，记为范围外即可。混合更新仍评估其中相关的部分。
3. 评估完成后，在下方追加简短记录，把 `.rev` 改成本次实际读过的完整 SHA，与规则和必要的许可变更一起交付。即使本次没有采纳内容，也可推进基线。只有运行时指南或插件行为发生变化时，才按项目惯例更新插件版本。

## 评估记录

- 2026-11-23，首次接入 [BeautifulRust 1.6.0](https://github.com/morganlinton/BeautifulRust/tree/b9718436d77ee7bcf17cdcb6aa27628feb95d97a)。实现指南吸收统一构造校验、调用点建模、所有权、公共 API、错误、异步与 FFI。审查指南吸收按调用路径检查和按影响报告的做法，库存导入示例用于说明跨入口的校验遗漏。测试、独立审查和严重度沿用本项目规则，Cargo 验证使用目标 crate 的工具链和 feature 组合。[库存审查示例](https://github.com/morganlinton/BeautifulRust/blob/b9718436d77ee7bcf17cdcb6aa27628feb95d97a/examples/review-inventory.md) · [上游许可](../../skills/idiomatic-rust/LICENSE-BeautifulRust)
