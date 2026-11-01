## Roller Coaster

> based on [Lagopus](https://github.com/WebGPU-Art/lagopus)

Demo https://r.tiye.me/WebGPU-Art/roller-coaster/ .

### 使用者影响：Calcit 0.32.1

CLI / `@calcit/procs` 配对正式 **0.32.1**，需要重新安装依赖并生成 JS。
类型标注存储语法由官方 formatter 迁移；21 个定义的完整官方视图与规范化基线一致，
没有改变执行代码、schema、文档或测试元数据。

模块配对正式 Lagopus 0.5.15、Quaternion 0.2.19、Memof 0.0.43、JS FFI 0.2.9。
原 2,000 个方块、10,000 个轨道采样、40 秒相机周期及 `hud!` 页面报错保留；
不减少场景复杂度、不更改 shader、原前端 CDN 或服务器部署路径。
Memof 仍只使用既有缓存 API，不新增 Anchor 调用或状态协议。

既有 Ref/Option、V3 坐标解码与相机更新顺序保持，不假造类型、不关闭门禁。
原未使用 cycloid 备用路径未做单独浏览器验收，不宣称所有相机路径或物理 gamepad 已覆盖。

本轮完整检查 97/97（含依赖）、完整 strict passed / diagnostics=[]、Caps 四模块和
工具链配对、immutable 安装、前端构建、JS 语法检查及官方格式化幂等通过。
项目没有 attached tests，不将空测试算作通过。实际 WebGPU 场景显示地面、方块和轨道，
相机持续推进；正常刷新后重新启动，error/warn 为空。

npm 新解析候选版本包龄设为 60 分钟，无预批准例外；正常复用 lock 不重新等待。
lock 只更新 procs 版本和校验值。CI 保留原检查、构建与部署条件，多命令步骤显式
遇错退出，取消额外的全局安装脚本启用；格式门禁只比较是否改变 Snapshot，不打印原始 patch。
不增加验证脚本或测试框架，COS 仅用 Action 内置 verify。PR 只检查和构建，本轮不合并或部署。

### Workflow

Uses Calcit 0.32.1, Node 24 and Yarn 4.18.0. Source and formal
dependencies are declared in `calcit.cirru` and `deps.cirru`.

```sh
caps --ci --strict
yarn install --immutable
calcit --check-only --all-defs
calcit fix --workflow strict --verify
calcit js
yarn vite
```

Geometry and camera calculations use `quaternion.vector/V3`. The original
2,000 cubes, ground grid, 10,000 rail samples and 40-second camera animation
are preserved. Reloading cancels the previous animation frame before restart.
The unused template `:states` handler is retired; `:tab` has a typed Op contract.

CI checks and builds PRs without deploying them. Main uploads frontend resources
to `https://cos-sh.tiye.me/WebGPU-Art/roller-coaster/`; setting the COS action's
`public-base-url` enables its built-in per-file checksum verification. The original
page deployment path `/web-assets/repo/${github.repository}` remains unchanged.
Generated `js-out/` and local install state are not tracked. `compact.cirru`
and `package.cirru` are retired.

The touch-control npm package currently only publishes `0.0.4-a1` as latest;
it is pinned exactly, not to a floating prerelease range.

### License

MIT
