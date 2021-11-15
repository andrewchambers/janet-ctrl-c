(import ctrl-c)

(defn run-command-with-cancel
  [args]
  (def signals (ctrl-c/stream))
  (def proc (os/spawn args :p))
  (def sig-handler
    (ev/call 
      (fn []
        (try
          (do
            (ctrl-c/await signals)
            (os/execute ["kill" (string (proc :pid))] :xp))
          ([err f] nil)))))
  (def rc (os/proc-wait proc))
  (ev/cancel sig-handler nil)
  (ev/close signals)
  (unless (= rc 0)
    (errorf "command %j failed: exit-code=%d" args rc))
  nil)

(ctrl-c/mask true)
(print "running background task, press ctrl-c to cancel...")
(run-command-with-cancel ["sh" "-c" "echo hello ; sleep 5; echo goodbyte" ])
