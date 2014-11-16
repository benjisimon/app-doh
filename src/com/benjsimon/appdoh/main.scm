;;
;; The main entry point to appdoh. This does almost nothing,
;; it just loads our creation's scm files
;;

(require 'android-defs)

(define-alias Bundle android.os.Bundle)

(define app-doh-root "/mnt/sdcard/AppDoh")

(define (app-doh-path . any)
  (if (null? any)
    app-doh-root
    (string-append app-doh-root "/" (car any))))


(define (prep-directories)
  (for-each (lambda (p)
              (if (not (file-directory? p))
                (create-directory p)))
            (list (app-doh-path)
                  (app-doh-path "creation")
                  (app-doh-path "logs"))))
    

(define-simple-class main (android.app.Activity)
  
  ((onCreate (savedInstance :: Bundle))
   (invoke-special android.app.Activity (this) 'onCreate savedInstance)

   (prep-directories)
   (let* ((on-create-scm (app-doh-path "creation/on-create.scm"))
          (ready? (file-exists? on-create-scm)))
     (if ready?
       (fluid-let ((the-activity (this)))
         (load on-create-scm))
       ((this):setContentView 
        (android.widget.TextView (this)
                                 text: (string-append "Doing nothing. File not found: " on-create-scm))))))
  
  )

