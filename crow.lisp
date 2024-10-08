;;;; crow.lisp
;;;; CROW Viewer
(ql:quickload :mcclim)

(in-package :common-lisp-user)

(defpackage "APP"
  (:use :clim :clim-lisp)
  (:export run-app))

(in-package :app)

(define-application-frame superapp ()
  ()
  (:pointer-documentation t)
  (:panes
   (app
    :application
    :display-time t
    :height 300
    :width 600)
   (int
    :height 200
    :width 600))
  (:layouts
   (default (vertically () app int))))

#||
(define-application-frame superapp ()
  ((numbers :initform (loop repeat 20 collect (list (random 100000000)))
	    :accessor numbers)
   (cursor :initform 0 :accessor cursor))
  (:pointer-documentation t)
  (:panes
   (app :application
	:height 400
	:width 600
	:incremental-redisplay t
	:display-function 'display-app)
   (int :interactor
	:height 200
	:width 600))
  (:layouts
   (default (vertically () app int))))

(defun display-app (frame pane)
  (loop
    for current-element in (numbers frame)
    for line from 0
    do (princ (if (= (cursor frame) line) "** " "   ") pane)
    do (updating-output (pane :unique-id current-element
			      :id-test #'eq
			      :cache-value (car current-element)
			      :cache-test #'eql)
			(format pane "~a~%" (car current-element)))))
||#

;;; Command definitions
(define-superapp-command (com-quit :name t) ()
  (frame-exit *application-frame*))

#||
(define-superapp-command (com-add :name t) ((number 'integer))
  (incf (car (elt (numbers *application-frame*)
		  (cursor *application-frame*)))
	number))

(define-superapp-command (com-next :name t) ()
  (incf (cursor *application-frame*))
  (when (= (cursor *application-frame*)
	   (length (numbers *application-frame*)))
    (setf (cursor *application-frame*) 0)))

(define-superapp-command (com-previous :name t) ()
  (decf (cursor *application-frame*))
  (when (minusp (cursor *application-frame*))
    (setf (cursor *application-frame*)
	  (1- (length (numbers *application-frame*))))))
||#

(define-presentation-type name-of-month ()
  :inherit-from 'string)

(define-presentation-type day-of-month ()
  :inherit-from 'integer)

(define-superapp-command (com-out :name t) ()
  (with-output-as-presentation (t "The third month" 'name-of-month)
    (format t "March~%"))
  (with-output-as-presentation (t 15 'day-of-month)
    (format t "fifteen~%")))

(define-superapp-command (com-get-date :name t)
    ((name 'name-of-month) (date 'day-of-month))
  (format (frame-standard-input *application-frame*)
	  "the ~a of ~a~%" date name))

;;; Runner
(defun run-app ()
  (run-frame-top-level (make-application-frame 'superapp)))

;;; Main function
(in-package :common-lisp-user)

(defun main ()
  (app:run-app))
