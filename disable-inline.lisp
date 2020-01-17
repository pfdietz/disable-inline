(defpackage :disable-inline
  (:use :common-lisp)
  (:shadow #:inline)
  (:export #:with-no-inline))

(in-package :disable-inline)

;;; This shadowed version of INLINE is a declaration no-op
(declaim (declaration inline))

(defvar *disabled* t)

(defun make-macroexpand-hook (old-hook)
  (lambda (fn form env)
    (typecase form
      ((cons (eql defpackage)
             (cons T T))
       (setf form
             `(defpackage ,(cadr form)
                (:shadowing-import-from :disable-inline inline)
                ,@(cddr form)))))
    (funcall old-hook fn form env)))

(defmacro with-no-inline (&body body)
  `(let ((*macroexpand-hook* (make-macroexpand-hook *macroexpand-hook*)))
     ,@body))
