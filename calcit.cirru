
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |memof/ |quaternion/ |lagopus/ |js-ffi/
      :type-slots $ {}
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn comp-container (store)
            group nil (comp-ground)
              comp-cubes $ {} $ :size 1000
              comp-polylines $ {} $ :writer
                fn (write!)
                  -> (range 10000)
                    map $ fn (idx)
                      write! $ :: :vertex
                        helix-calc-position $ * 0.1 idx
                        , 200
          :examples $ []
        'comp-cubes $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn comp-cubes (options)
            let
                size $ either (:size options) 400
                h $ * size 20
                many 2000
              object $ {} (:shader cube-wgsl)
                :topology $ do :line-strip :triangle-list
                :attrs-list $ [] $ :: :float32x3 :position
                :data $ -> (range many)
                  map $ fn (idx)
                    let
                        base $ rand-pos 800000
                      []
                        :: :vertex $ v+ base $ [] 0 0 0
                        :: :vertex $ v+ base $ [] 0 h 0
                        :: :vertex $ v+ base $ [] 0 h size
                        :: :vertex $ v+ base $ [] 0 0 size
                        :: :vertex $ v+ base $ [] size 0 0
                        :: :vertex $ v+ base $ [] size h 0
                        :: :vertex $ v+ base $ [] size h size
                        :: :vertex $ v+ base $ [] size 0 size
                :indices $ -> (range many)
                  map $ fn (idx)
                    ->
                      [] ([] 0 1 2 0 2 3) ([] 0 1 5 0 4 5) ([] 1 2 6 1 6 5) ([] 2 3 6 3 6 7) ([] 0 3 4 3 4 7) ([] 4 5 6 4 6 7)
                      map $ fn (line)
                        map line $ fn (x)
                          + x $ * idx 8
          :examples $ []
        'comp-ground $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn comp-ground ()
            let
                y -10
                unit 1800
              object $ {} (:shader ground-wgsl)
                :topology $ do :line-strip :triangle-list
                :attrs-list $ [] $ :: :float32x3 :position
                :data $ -> (range-bothway 100)
                  map $ fn (i)
                    let
                        i+1 $ inc i
                      -> (range-bothway 100)
                        map $ fn (j)
                          let
                              j+1 $ inc j
                            []
                              : vertex $ [] (* unit i) y $ * unit j
                              : vertex $ [] (* unit i+1) y $ * unit j
                              : vertex $ [] (* unit i) y $ * unit j+1
                              : vertex $ [] (* unit i) y $ * unit j+1
                              : vertex $ [] (* unit i+1) y $ * unit j
                              : vertex $ [] (* unit i+1) y $ * unit j+1
          :examples $ []
        'rand-pos $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn rand-pos (n)
            v-scale
              []
                - (js/Math.random) 0.5
                * 0.1 $ - (js/Math.random) 0.2
                - (js/Math.random) 0.5
              , n
          :examples $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require
            lagopus.alias :refer $ group object
            |../shaders/cube.wgsl :default cube-wgsl
            |../shaders/ground.wgsl :default ground-wgsl
            lagopus.comp.curves :refer $ comp-curves comp-polylines
            memof.once :refer $ memof1-call
            quaternion.core :refer $ c+ v+ v-scale
            app.path :refer $ helix-calc-position
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            &= |dev $ .unwrap-or (get-env |mode) |release
          :examples $ []
          :schema $ :: 'Bool
        'inline-shader $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defmacro inline-shader (path)
            read-file $ str |shaders/ path |.wgsl
          :examples $ []
          :schema $ :: 'Macro $ {}
            :capabilities $ #{} :fs-read
            :expansion $ :: 'Expr 'String
            :required $ [] $ :: 'Expr 'String
        'remote-control? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def remote-control?
            .some? $ get-env |remote-control
          :examples $ []
          :schema $ :: 'Bool
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defatom *store
            {} $ :tab :cube
          :examples $ []
        'canvas $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def canvas (js/document.querySelector |canvas)
          :examples $ []
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            if dev? $ js/console.log op
            let
                store @*store
                next-store $ tag-match op
                  (:states cursor s) (update-states store cursor s)
                  (:tab t) (assoc store :tab t)
                  _ $ do (eprintln ":unknown op" op) store
              if (not= next-store store) (reset! *store next-store)
          :examples $ []
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! () (hint-fn async)
            if dev? $ load-console-formatter!
            js-await $ initializeContext
            initializeCanvasTextures
            reset-clear-color! $ either bg-color $ {} (:r 0.85) (:g 0.89) (:b 0.99) (:a 1)
            render-app!
            renderControl
            startControlLoop 10 onControlEvent
            set! js/window.__lagopusHandleCompilationInfo handle-compilation
            set! js/window.onresize $ fn (e) (resetCanvasSize canvas) (initializeCanvasTextures) (paintLagopusTree)
            resetCanvasSize canvas
            add-watch *store :change $ fn (next store) (render-app!)
            setupMouseEvents canvas
            if remote-control? $ setupRemoteControl
            setup-roll!
          :examples $ []
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (nil? build-errors)
              do (reset-memof1-caches!) (render-app!) (remove-watch *store :change)
                add-watch *store :change $ fn (next store) (render-app!)
                setup-roll!
                println |Reloaded.
                hud! |ok~ |OK
              hud! |error build-errors
          :examples $ []
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            let
                tree $ comp-container @*store
              renderLagopusTree tree dispatch!
          :examples $ []
        'setup-roll! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn setup-roll! () (set! js/window.roll roll!)
            if (some? js/window._raf) (js/cancelAnimationFrame js/window._raf)
            roll!
          :examples $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            app.comp.container :refer $ comp-container
            |@triadica/lagopus :refer $ setupMouseEvents onControlEvent paintLagopusTree renderLagopusTree initializeContext resetCanvasSize initializeCanvasTextures
            |@triadica/touch-control :refer $ renderControl startControlLoop
            app.config :refer $ dev? remote-control?
            |bottom-tip :default hud!
            |./calcit.build-errors :default build-errors
            memof.once :refer $ reset-memof1-caches!
            lagopus.util :refer $ handle-compilation reset-clear-color!
            lagopus.cursor :refer $ update-states
            lagopus.config :refer $ bg-color
            |@triadica/lagopus/lib/remote-control.mjs :refer $ setupRemoteControl
            app.path :refer $ roll!
    'app.path $ %{} 'FileEntry
      :defs $ {}
        'helix-calc-position $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn helix-calc-position (time)
            let
                angle $ * 0.8 time
                r 6000
              []
                - (* time 10000) 200000
                + 10000 $ * r $ cos angle
                * r $ sin angle
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'Number
            :return $ :: 'List 'Number
        'roll! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn roll! ()
            roll-helix! $ js/performance.now
            ; roll-cycloid! 0
          :examples $ []
        'roll-cycloid! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn roll-cycloid! (t)
            when (< t 200000)
              js/requestAnimationFrame $ fn (d)
                let
                    dt $ * d 0.001
                    next $ + t dt
                    df $ * dt 2000
                    da $ * 0.3 dt
                    r 100
                    p $ []
                      -
                        + df $ * r $ sin da
                        , 40000
                      + 3000 $ - r $ * r (cos da)
                      , 0
                    front $ [] (cos da) (sin da) 0
                    right $ [] 0 0 1
                    up $ []
                      negate $ sin da
                      cos da
                      , 0
                  .!reset atomViewerForward $ js-array & front
                  .!reset atomViewerPosition $ js-array & p
                  .!reset atomViewerUpward $ js-array & up
                  paintLagopusTree
                  ; js/console.log t
                  roll-cycloid! next
          :examples $ []
        'roll-helix! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn roll-helix! (t0)
            set! js/window._raf $ js/requestAnimationFrame $ fn (t)
              let
                  d $ - t t0
                  dt $ * d 0.001
                  time dt
                  p $ helix-calc-position time
                  p-next $ helix-calc-position $ + time 0.02
                  front $ do
                    v-normalize $ &v- p-next p
                    ; [] 1 0 0
                  up $ do
                    v-normalize $ &v-
                      []
                        - (* time 10000) 200000
                        , 10000 0
                      , p
                    ; [] 0 1 0
                .!reset atomViewerForward $ js-array & front
                .!reset atomViewerPosition $ js-array & p
                .!reset atomViewerUpward $ js-array & up
                paintLagopusTree
                ; js/console.log t
                if (< dt 40) (roll-helix! t0)
          :examples $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.path
          :require
            |@triadica/lagopus :refer $ paintLagopusTree
            |@triadica/lagopus/lib/perspective.mjs :refer $ atomViewerForward atomViewerPosition atomViewerUpward
            quaternion.core :refer $ &v- v-normalize
