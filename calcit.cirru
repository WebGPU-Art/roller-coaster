
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
            group ({}) (comp-ground)
              comp-cubes $ {} $ :size 1000
              comp-polylines $ {} $ :writer
                fn (write!)
                  -> (range 10000)
                    map $ fn (idx)
                      write! $ :: :vertex
                        helix-calc-position $ * 0.1 idx
                        , 200
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'JsObject)
            :args $ [] $ :: 'Map 'Tag 'Tag
        'comp-cubes $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn comp-cubes (options)
            let
                size $ .unwrap-or (get options :size) 400
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
                        :: :vertex $ v+ base $ v3 0 0 0
                        :: :vertex $ v+ base $ v3 0 h 0
                        :: :vertex $ v+ base $ v3 0 h size
                        :: :vertex $ v+ base $ v3 0 0 size
                        :: :vertex $ v+ base $ v3 size 0 0
                        :: :vertex $ v+ base $ v3 size h 0
                        :: :vertex $ v+ base $ v3 size h size
                        :: :vertex $ v+ base $ v3 size 0 size
                :indices $ -> (range many)
                  map $ fn (idx)
                    ->
                      [] ([] 0 1 2 0 2 3) ([] 0 1 5 0 4 5) ([] 1 2 6 1 6 5) ([] 2 3 6 3 6 7) ([] 0 3 4 3 4 7) ([] 4 5 6 4 6 7)
                      map $ fn (line)
                        map line $ fn (x)
                          + x $ * idx 8
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'JsObject)
            :args $ [] $ :: 'Map 'Tag 'Number
        'comp-ground $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn comp-ground ()
            let
                y -10
                unit 1800
              object $ {} (:shader ground-wgsl)
                :topology $ do :line-strip :triangle-list
                :attrs-list $ [] $ :: :float32x3 :position
                :data $ -> (range -99 100)
                  map $ fn (i)
                    let
                        i+1 $ inc i
                      -> (range -99 100)
                        map $ fn (j)
                          let
                              j+1 $ inc j
                            []
                              :: :vertex $ [] (* unit i) y $ * unit j
                              :: :vertex $ [] (* unit i+1) y $ * unit j
                              :: :vertex $ [] (* unit i) y $ * unit j+1
                              :: :vertex $ [] (* unit i) y $ * unit j+1
                              :: :vertex $ [] (* unit i+1) y $ * unit j
                              :: :vertex $ [] (* unit i+1) y $ * unit j+1
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'JsObject)
            :args $ []
        'rand-pos $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn rand-pos (n)
            v-scale
              v3
                - (random) 0.5
                * 0.1 $ - (random) 0.2
                - (random) 0.5
              , n
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'quaternion.vector/V3)
            :args $ [] 'Number
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require
            lagopus.alias :refer $ group object
            |../shaders/cube.wgsl :default cube-wgsl
            |../shaders/ground.wgsl :default ground-wgsl
            lagopus.comp.curves :refer $ comp-curves comp-polylines
            memof.once :refer $ memof1-call
            app.path :refer $ helix-calc-position
            quaternion.vector :refer $ v+ v-scale v3
            js-ffi.browser :refer $ random
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
          :code $ quote $ defref *store
            {} $ :tab :cube
          :examples $ []
          :schema $ :: 'Ref $ :: 'Map 'Tag 'Tag
        'Op $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Op (:tab 'Tag)
          :examples $ []
          :schema $ :: 'EnumDef
        'canvas $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def canvas (query-canvas!)
          :examples $ []
          :schema $ :: 'lagopus.browser/Canvas
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            if dev? $ console-log! $ str op
            let
                store @*store
                next-store $ match op
                  (:tab t) (assoc store :tab t)
                  _ $ do (eprintln ":unknown op" op) store
              if (not= next-store store) (reset! *store next-store)
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'app.main/Op
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            hint-fn $ {} $ :async true
            if dev? $ load-console-formatter!
            js-await $ initializeContext
            initializeCanvasTextures
            reset-clear-color! $ .unwrap-or bg-color $ :: :rgba 0.85 0.89 0.99 1
            render-app!
            renderControl
            startControlLoop 10 onControlEvent
            set! js/window.__lagopusHandleCompilationInfo handle-compilation
            set! js/window.onresize $ fn (e) (resetCanvasSize canvas) (initializeCanvasTextures) (paintLagopusTree)
            resetCanvasSize canvas
            add-watch! *store :change $ fn (next store) (render-app!)
            setupMouseEvents canvas
            if remote-control? $ setupRemoteControl
            setup-roll!
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (nil? build-errors)
              do (reset-memof1-caches!) (render-app!) (remove-watch! *store :change)
                add-watch! *store :change $ fn (next store) (render-app!)
                setup-roll!
                println |Reloaded.
                hud! |ok~ |OK
              hud! |error build-errors
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            let
                tree $ comp-container @*store
              renderLagopusTree tree dispatch!
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'setup-roll! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn setup-roll! () (set! js/window.roll roll!) (cancel-roll!) (roll!) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
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
            lagopus.config :refer $ bg-color
            |@triadica/lagopus/lib/remote-control.mjs :refer $ setupRemoteControl
            app.path :refer $ roll! cancel-roll!
            lagopus.browser :refer $ query-canvas!
            js-ffi.browser :refer $ console-log!
    'app.path $ %{} 'FileEntry
      :defs $ {}
        '*frame $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *frame (Option :none)
          :examples $ []
          :schema $ :: 'Ref $ :: 'Option 'Number
        'cancel-roll! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn cancel-roll! ()
            match @*frame
              (:some frame) (cancel-animation-frame! frame)
              (:none) &unit
            reset! *frame $ Option :none
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
        'helix-calc-position $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn helix-calc-position (time)
            let
                angle $ * 0.8 time
                r 6000
              v3
                - (* time 10000) 200000
                + 10000 $ * r $ cos angle
                * r $ sin angle
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'quaternion.vector/V3)
            :args $ [] 'Number
        'roll! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn roll! ()
            roll-helix! $ performance-now
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
        'roll-cycloid! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn roll-cycloid! (t)
            when (< t 200000)
              request-animation-frame! $ fn (d)
                hint-fn $ {}
                  :args $ [] 'Number
                  :return 'Unit
                  :features $ #{} :js-ffi
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
                  .!reset atomViewerForward $ js-array
                    .unwrap $ nth front 0
                    .unwrap $ nth front 1
                    .unwrap $ nth front 2
                  .!reset atomViewerPosition $ js-array
                    .unwrap $ nth p 0
                    .unwrap $ nth p 1
                    .unwrap $ nth p 2
                  .!reset atomViewerUpward $ js-array
                    .unwrap $ nth up 0
                    .unwrap $ nth up 1
                    .unwrap $ nth up 2
                  paintLagopusTree
                  roll-cycloid! next
                  , &unit
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Number
            :features $ #{} :js-ffi
        'roll-helix! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn roll-helix! (t0)
            reset! *frame $ Option :some $ request-animation-frame!
              fn (t)
                hint-fn $ {}
                  :args $ [] 'Number
                  :return 'Unit
                  :features $ #{} :js-ffi
                let
                    d $ - t t0
                    dt $ * d 0.001
                    time dt
                    p $ helix-calc-position time
                    p-next $ helix-calc-position $ + time 0.02
                    front $ v-normalize $ &v- p-next p
                    up $ v-normalize $ &v-
                      v3
                        - (* time 10000) 200000
                        , 10000 0
                      , p
                  .!reset atomViewerForward $ v3-js front
                  .!reset atomViewerPosition $ v3-js p
                  .!reset atomViewerUpward $ v3-js up
                  paintLagopusTree
                  if (< dt 40) (roll-helix! t0)
                  , &unit
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Number
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.path
          :require
            |@triadica/lagopus :refer $ paintLagopusTree
            |@triadica/lagopus/lib/perspective.mjs :refer $ atomViewerForward atomViewerPosition atomViewerUpward
            quaternion.vector :refer $ &v- v-normalize v3
            lagopus.comp.button :refer $ v3-js
            js-ffi.browser :refer $ request-animation-frame! cancel-animation-frame!
            js-ffi.shared :refer $ performance-now
