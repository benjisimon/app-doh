(require 'android-defs)

(define (logi . messages)
 (android.util.Log:i "on-create.scm" (apply string-append messages)))
 
(logi "Starting")

((current-activity):setContentView
 (android.widget.TextView (current-activity)
   text: "Hello World"))

(logi "Ending")
  