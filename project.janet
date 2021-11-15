(declare-project
  :name "ctrl-c"
  :description "Allow a janet program to intercept or act on INT signals.")

(declare-source
  :source ["ctrl-c.janet"])

(declare-native
 :name "_ctrl-c"
 :source ["ctrl.c"])
