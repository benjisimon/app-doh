;;
;; The main entry point to appdoh. This does almost nothing,
;; it just loads our creation's scm files
;;

(require 'android-defs)

(define-alias Bundle android.os.Bundle)
(define-alias Log android.util.Log)
(define-alias MenuItem  android.view.MenuItem)
(define-alias Intent  android.content.Intent)

(define && string-append)

(define (logi message)
  (Log:i "main.scm" message))

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

 ((on-create-options-menu (menu :: android.view.Menu))
  (let ((inflator ((this):get-menu-inflater)))
    (inflator:inflate R$menu:main menu)
    #t))
 
 ((on-options-item-selected (item :: MenuItem))
  (let ((selected (MenuItem:getItemId item)))
    (cond ((equal? selected R$id:refresh)
           ((this):do-load "on-create")
           #t)
          (else #f))))
 
 ((onCreate (savedInstance :: Bundle))
  (invoke-special android.app.Activity (this) 'onCreate savedInstance)
  (prep-directories)
  ((this):do-load "on-create"))

  ((do-load event)
   (let* ((scm (app-doh-path (&& "creation/" event ".scm"))))
     (cond ((file-exists? scm)
            (<kawa.standard.Scheme>:registerEnvironment)
            (parameterize ((current-activity (this)))
              (load scm)))
           (else 
            ((this):setContentView 
             (android.widget.TextView (this)
                                      text: (&& "Doing nothing. No event file found for: " event " (" scm ")")))))))
  
  
  )

