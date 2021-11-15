(import _ctrl-c :prefix "" :export true)

(defn await
  [stream]
  (ev/read stream 128)
  nil)