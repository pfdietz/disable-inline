(require 'package)
(setq inhibit-startup-screen t)
(setq-default indent-tabs-mode nil)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))
    ))
(package-initialize)

;; (add-to-list 'load-path "~/slime")
;; (require 'slime-autoloads)

(global-set-key (kbd "M-&") 'query-replace-regexp)
(global-set-key (kbd "M-@") 'goto-line)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (use-package cl-lib docker-cli docker dockerfile-mode docker-compose-mode docker-tramp markdown-mode jsonrpc json-rpc eglot slime-repl-ansi-color ac-slime slime-docker magit slime)))
 '(safe-local-variable-values
   (quote
    ((whitespace-style quote
                       (face trailing empty tabs))
     (whitespace-action))))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Mono" :foundry "DAMA" :slant normal :weight normal :height 158 :width normal)))))

(setf inferior-lisp-program "sbcl")
;; (slime-setup '(slime-repl slime-fancy))
(slime-setup '(slime-fancy slime-repl-ansi-color))
(setq slime-net-coding-system 'utf-8-unix)
(setq slime-lisp-implementations
      '((ccl ("/home/pdietz/bin/ccl"))
        (ecl ("ecl"))
        (gcl ("/usr/lib/gcl-2.6.12/unixport/saved_ansi_gcl"))
        (sbcl ("sbcl"))
;;        (sbcl147 ("/home//pdietz/sbcl-1.4.7/bin/sbcl")
;;                 :env ("SBCL_HOME=/home/pdietz/sbcl-1.4.7/lib/sbcl"))
        (sbcl-dev ("/home/pdietz/bin/sbcl")
                  :env ("SBCL_HOME=/home/pdietz/lib/sbcl"))
;;        (sbcl-no-unicode
;;         ("/pdietz/sbcl-no-unicode/bin/sbcl")
;;         :env ("SBCL_HOME=/pdietz/sbcl-no-unicode/lib/sbcl"))
;;        (sbcl32 ("/pdietz/sbcl32/bin/sbcl")
;;                :env ("SBCL_HOME=/pdietz/sbcl32/lib/sbcl"))
        (clasp ("/home//pdietz/clasp/build/boehm/cclasp-boehm"))
        (clisp ("/home//pdietz/bin/clisp"))
        (cmucl ("/home/pdietz/bin/lisp"))
        (abcl ("java" "-jar" "/home/pdietz/abcl-bin-1.8.0/abcl.jar"))
        (ssr ("/home/pdietz/quicklisp/local-projects/ssr/bin/ssr" "--interactive" "/home/pdietz/quicklisp/local-projects/ssr/test/etc/t1.c" "-"))))
(setq slime-default-lisp 'sbcl)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; Modifications to make lisp mode, paredit work
;; with curry-compose-reader-macros
;; Syntax table
(modify-syntax-entry ?\[ "(]" lisp-mode-syntax-table)
(modify-syntax-entry ?\] ")[" lisp-mode-syntax-table)
(modify-syntax-entry ?\{ "(}" lisp-mode-syntax-table)
(modify-syntax-entry ?\} "){" lisp-mode-syntax-table)
;; optional UTF8 characters
(modify-syntax-entry ?\« "(»" lisp-mode-syntax-table)
(modify-syntax-entry ?\» ")«" lisp-mode-syntax-table)
(modify-syntax-entry ?\‹ "(‹" lisp-mode-syntax-table)
(modify-syntax-entry ?\› ")›" lisp-mode-syntax-table)

;; Paredit keys
(eval-after-load "paredit"
  '(progn
    (define-key paredit-mode-map "[" 'paredit-open-parenthesis)
    (define-key paredit-mode-map "]" 'paredit-close-parenthesis)
    (define-key paredit-mode-map "(" 'paredit-open-bracket)
    (define-key paredit-mode-map ")" 'paredit-close-bracket)
    (define-key paredit-mode-map "{" 'paredit-open-curly)
    (define-key paredit-mode-map "}" 'paredit-close-curly)
    (define-key paredit-mode-map "«" 'paredit-open-special)
    (define-key paredit-mode-map "»" 'paredit-close-special)
    (define-key paredit-mode-map "‹" 'paredit-open-special)
    (define-key paredit-mode-map "›" 'paredit-close-special)))

;;; For ‹ and ›
(global-set-key (kbd "\C-x 8 (") (lambda () (interactive) (insert-char #x2039)))
(global-set-key (kbd "\C-x 8 )") (lambda () (interactive) (insert-char #x203A)))

(font-lock-add-keywords
 'lisp-mode
 '(("\\<\\(lambda-bind\\)\\>" . font-lock-keyword-face)
   ("\\<\\(lambda-registers\\)\\>" . font-lock-keyword-face)
   ("\\<\\(when-let\\)\\>" . font-lock-keyword-face)
   ("\\<\\(if-let\\)\\>" . font-lock-keyword-face)
   ;; others
   ("\\<\\(defevo\\)\\>" . font-lock-keyword-face)
   ;; fancy character for smaller lambda-bind
   ("(?\\(lambda-bind\\>\\)"
    (0 (progn (compose-region (match-beginning 1) (match-end 1) ?\β) nil)))
   ("(?\\(lambda-registers\\>\\)"
    (0 (progn (compose-region (match-beginning 1) (match-end 1) ?\Ρ) nil)))))

;;; Specify indentation levels for specific functions.
(mapc (lambda (pair) (put (car pair) 'lisp-indent-function (cadr pair)))
      '((make-instance 1)
        (if-let 1)
        (if-let* 1)
        (when-let 1)
        (when-let* 1)
        (mvlet* 1)
        (fbind 1)
        (defixture 1)
        (lambda-bind 1)
        (register-groups-bind 2)
        (eval-always 1)))

(defun define-feature-lisp-indent
    (path state indent-point sexp-column normal-indent)
  "Indentation function called by `lisp-indent-function' for define-feature."
  ;; (message "CALLED: %S"
  ;;          (list 'define-feature-lisp-indent
  ;;                path state indent-point sexp-column normal-indent))
  (cond
   ((equalp path '(2)) 2)   ; Doc string for enclosing define-feature.
   ((equalp path '(3)) 2)   ; Extractor function definition.
   ((equalp path '(3 2)) 4) ; Doc string for extractor.
   ((equalp path '(4)) 2)   ; Merge function definition.
   (t nil)))                ; Otherwise do the default.
(put 'define-feature 'lisp-indent-function 'define-feature-lisp-indent)
(require 'eglot)
(add-to-list 'eglot-server-programs '(lisp-mode . ("localhost" 10003)))
(add-to-list 'eglot-server-programs '(js-mode . ("localhost" 10003)))
(add-to-list 'eglot-server-programs '(python-mode . ("localhost" 10003)))
(add-to-list 'eglot-server-programs '(c-mode . ("localhost" 10003)))

(global-set-key (kbd "M-*") 'eglot-code-actions)
