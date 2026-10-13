## Roller Coaster

> based on [Lagopus](https://github.com/WebGPU-Art/lagopus)

Demo https://r.tiye.me/WebGPU-Art/roller-coaster/ .

### Workflow

Uses Calcit 0.29.1, Node 24 and Yarn 4.18.0. Source and formal
dependencies are declared in `calcit.cirru` and `deps.cirru`.

```sh
caps --ci --strict
yarn install --immutable
calcit --check-only --all-defs
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
