## Roller Coaster

> based on [Lagopus](https://github.com/WebGPU-Art/lagopus)

Demo https://r.tiye.me/WebGPU-Art/roller-coaster/ .

### 使用者影响

本轮迁移到正式 Calcit/procs 0.31.0，使用已发布的 Lagopus 0.5.13、Quaternion 0.2.17、Memof 0.0.41 和 JS FFI 0.2.7。原 2,000 个方块、10,000 个轨道采样、40 秒相机周期及 `hud!` 页面报错保留；不减少场景复杂度、不更改 shader 或原前端部署路径。

旧 Ref/Option 写法迁移到 `defref` 和 `Option :some/:none`；地面范围保留 -99…99 的原顺序。备用 cycloid 路径中的三维 List 改为显式读取三个坐标生成 JS 数组，避免无证明展开；不改变坐标计算或相机更新顺序。原导入声明去掉多余 `[]`，CI 从 deps.cirru 读取工具链并增加完整 strict。

本地全定义与完整 strict、生产构建通过；实际 WebGPU 页面显示地面、方块与轨道，相机持续推进，浏览器 warning/error 为空。备用 cycloid 路径没有单独浏览器验收，不声称全部相机路径或热重载生命周期均已覆盖。没有放宽类型门禁或基线，没有新增验证脚本。

### Workflow

Uses Calcit 0.31.0, Node 24 and Yarn 4.18.0. Source and formal
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
