
(require 'android-defs)

(define (logi . messages)
  (android.util.Log:i "on-create.scm" (apply string-append messages)))
   
(logi "Starting")
  
(let* ((act::android.app.Activity (current-activity))
      (t::android.widget.TextView
       (android.widget.TextView act))
      )
  (t:set-text "Hello World")
  (act:setContentView t)
  )

(logi "Ending")
