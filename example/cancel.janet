(import ctrl-c)

(ctrl-c/mask true)

(print "running background task, press ctrl-c to cancel...")

(def proc
  (os/spawn ["sleep" "10"] :p))

(def signals (ctrl-c/stream))

(def sig-handler
  (ev/call 
    (fn []
      (:read signals 128)
      (os/proc-kill proc))))

(os/proc-wait proc)
(ev/cancel sig-handler nil)
(:close signals)
(print "fiber cancelled")
(pp (fiber/status sig-handler))
(pp (fiber/last-value sig-handler))