(import _ctrl-c :prefix "" :export true)

(defn await
  [stream]
  (truthy? (ev/read stream 128)))