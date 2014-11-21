(begin

  (require 'android-defs)
  
  (define (logi . messages)
   (android.util.Log:i "on-create.scm" (apply string-append messages)))
   
  (logi "Starting")
  
  (let ((t (android.widget.TextView (current-activity))))
   (t:set-text "Hello World")
   
   (<android.app.Activity>:setContentView
    (current-activity) (as android.view.View t)))
  
  (logi "Ending"))