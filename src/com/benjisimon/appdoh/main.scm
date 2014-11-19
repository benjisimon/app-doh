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

(define (exn->string (ex :: java.lang.Throwable))
  (let ((buffer (open-output-string)))
    (ex:printStackTrace buffer)
    (get-output-string buffer)))

(define (logi message)
  (Log:i "main.scm" message))

(define app-doh-root "/mnt/sdcard/AppDoh")

(define (app-doh-path . any)
  (if (null? any)
    app-doh-root
    (string-append app-doh-root "/" (apply string-append any))))


(define (prep-directories)
  (for-each (lambda (p)
              (if (not (file-directory? p))
                (create-directory p)))
            (list (app-doh-path))))
    
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
  (<kawa.standard.Scheme>:registerEnvironment)
  ((this):do-load "on-create"))

  ((do-load event)
   (let* ((scm (app-doh-path event ".scm")))
     (try-catch
      (parameterize ((current-activity (this)))
        (load scm))
      (ex java.lang.Throwable
          ((this):setContentView 
           (android.widget.TextView (this)
                                    text: (exn->string ex)))))))
  
  )

