(declare-project
  :name "ctrl-c" # required
  :description "Allow a janet program to intercept or act on INT signals.")

(declare-native
 :name "ctrl-c"
 :source ["ctrl.c"])
