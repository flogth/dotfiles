;; init --- My personal init -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:

;;; straight.el ============================================
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;; functions for configuration ============================
(require 'cl-lib)

(defmacro set! (&rest args)
  "Customize user options with ARGS like `setq'."
  (declare (debug setq))
  `(progn ,@(cl-loop for (name val) on args by #'cddr
                                        ;if (null val) return (user-error "Not enough arguments")
                     collecting `(customize-set-variable ',name ,val)
                     into ret
                     finally return ret)))

(defmacro defmap! (name &rest bindings )
  "Define a keymap NAME with defined BINDINGS."
  `(progn (defvar ,name
            (let ((keymap (make-keymap)))
              ,@(cl-loop for (key val) on bindings by #'cddr
                         collecting `(define-key keymap ,key ,val)
                         into ret
                         finally return ret)
              keymap))
          (defalias ',name ,name)))

;;; basic settings =========================================
(set! inhibit-startup-message t
      use-short-answers t        ; yes-or-no-p -> y-or-no-p
      vc-follow-symlinks t       ; do not warn when following symlinks
      visible-bell nil           ; do not flash a visual bell
      window-resize-pixelwise t  ; more flexible resizing
      frame-resize-pixelwise t
      use-dialog-box nil)

;; customization
(set! custom-file
      (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; backups
(setq backup-directory-alist
      `(("." . ,(expand-file-name ".backups" user-emacs-directory))))
(set! auto-save-default nil
      backup-by-copying t
      delete-old-versions t
      create-lockfiles nil)

;;; ui =====================================================

(set-fringe-mode 10)                    ; add padding to frame
(set! blink-cursor-mode nil)            ; do not blink cursor

;; theme

(straight-use-package 'doom-themes)

(set!
 doom-themes-enable-bold t
 doom-themes-enable-italic t)

(straight-use-package 'modus-themes)
(set! modus-themes-italic-constructs t
      modus-themes-bold-constructs t)
(load-theme 'modus-operandi t)

;; font

(custom-set-faces
 '(default ((t (:weight regular :height 140 :family "JuliaMono")))))

(straight-use-package 'all-the-icons)
;; modeline

(straight-use-package 'doom-modeline)
(add-hook 'after-init-hook #'doom-modeline-mode)

(set!
 doom-modeline-buffer-file-name-style 'auto
 doom-modeline-github nil
 doom-modeline-lsp nil
 doom-modeline-buffer-encoding nil
 doom-modeline-minor-modes nil)

(column-number-mode t)

;;; editor =================================================
(set! tab-width 4
      indent-tabs-mode nil)

;; kill ring
(set! save-interprogram-paste-before-kill t
      kill-do-not-save-duplicates t)

;; insert brackets,parens,... as pairs
(straight-use-package 'elec-pair)
(set! electric-pair-mode t)

;; show matching parentheses
(straight-use-package 'paren)
(set! show-paren-mode t
      show-paren-delay 0
      show-paren-context-when-offscreen t)

;; indenting
(straight-use-package 'aggressive-indent)
(add-hook 'prog-mode-hook #'aggressive-indent-mode)

;; editorconfig
(straight-use-package 'editorconfig)
(editorconfig-mode t)

;; buffer-env
(straight-use-package 'buffer-env)

;; scrolling
(set! scroll-margin 1
      scroll-step   1
      scroll-conservatively 101
      scroll-preserve-screen-position t
      fast-but-imprecise-scrolling t)

(straight-use-package 'paredit)
(add-hook 'lisp-mode-hook #'enable-paredit-mode)

;;; completion =============================================

;; history
(straight-use-package 'savehist)

(set! savehist-mode t
      history-delete-duplicates t
      history-length 1000
      savehist-save-minibuffer-history t)

;; recent files
(straight-use-package 'recentf)
(set! recentf-mode t)

; save position in files
(set! save-place-mode t)

;; completion in the minibuffer
(straight-use-package 'vertico)
(set! vertico-mode t
      vertico-cycle t
      vertico-resize t)

;; completion popup
(straight-use-package 'corfu)

(global-corfu-mode)

(set! corfu-auto t
      corfu-auto-delay 0
      corfu-preview-current nil
      corfu-cycle t
      corfu-echo-documentation 0.25
      tab-always-indent 'complete)

; completion at point extensions
(straight-use-package 'cape)
(add-to-list 'completion-at-point-functions #'cape-tex)
(add-to-list 'completion-at-point-functions #'cape-keyword)
(add-to-list 'completion-at-point-functions #'cape-file)
(add-to-list 'completion-at-point-functions #'cape-dabbrev)

;; snippets
(straight-use-package 'tempel)
(require 'tempel)

(defun tempel-setup-capf ()
  "Setup tempel as a capf backend."
  (setq-local completion-at-point-functions
              (cons #'tempel-expand
                    completion-at-point-functions)))

(add-hook 'prog-mode-hook 'tempel-setup-capf)
(add-hook 'text-mode-hook 'tempel-setup-capf)

(define-key tempel-map (kbd "TAB") #'tempel-next)

;; show useful information in the minibuffer marginalia
(straight-use-package 'marginalia)
(set! marginalia-mode t)

;; completion style matching space-separated words in any order
(straight-use-package 'orderless)
(set! completion-styles '(orderless basic))

;; useful functions in the minibuffer
(straight-use-package 'consult)
(setq completion-in-region-function #'consult-completion-in-region)

;; help
(set! help-window-select t)

(straight-use-package 'elisp-demos)
(advice-add 'describe-function-1 :after #'elisp-demos-advice-describe-function-1)

;;; applications ===========================================
;; calendar
(set! calendar-week-start-day 1
      calendar-date-style 'iso)
(set! calendar-holidays
      '((holiday-fixed 1 1 "Neujahrstag")
        (holiday-fixed 1 6 "Heilige Drei Könige")
        (holiday-fixed 2 14 "Valentinstag")
        (holiday-fixed 5 1 "1. Mai")
        (holiday-fixed 10 3 "Tag der Deutschen Einheit")
        (holiday-float 12 0 -4 "1. Advent" 24)
        (holiday-float 12 0 -3 "2. Advent" 24)
        (holiday-float 12 0 -2 "3. Advent" 24)
        (holiday-float 12 0 -1 "4. Advent" 24)
        (holiday-fixed 12 25 "1. Weihnachtstag")
        (holiday-fixed 12 26 "2. Weihnachtstag")
        (holiday-fixed 1 6 "Heilige Drei Könige")
        (holiday-easter-etc -48 "Rosenmontag")
        (holiday-easter-etc -3 "Gründonnerstag")
        (holiday-easter-etc  -2 "Karfreitag")
        (holiday-easter-etc   0 "Ostersonntag")
        (holiday-easter-etc  +1 "Ostermontag")
        (holiday-easter-etc +39 "Christi Himmelfahrt")
        (holiday-easter-etc +49 "Pfingstsonntag")
        (holiday-easter-etc +50 "Pfingstmontag")
        (holiday-easter-etc +60 "Fronleichnam")
        (holiday-fixed 8 15 "Mariae Himmelfahrt")
        (holiday-fixed 11 1 "Allerheiligen")
        (holiday-float 11 3 1 "Buss- und Bettag" 16)
        (holiday-float 11 0 1 "Totensonntag" 20))
      calendar-mark-holidays-flag t)

;; eshell
(straight-use-package 'eshell)
(set! eshell-banner-message "")

;; mail
; general mail settings
(set! user-mail-address "f.guthmann@mailbox.org"
      smtpmail-smtp-server "smtp.mailbox.org"
      smtpmail-smtp-user user-mail-address
      smtpmail-smtp-service 465
      smtpmail-stream-type 'ssl)

; gnus
(set! gnus-select-method '(nnnil)
      gnus-secondary-select-methods
      '((nntp "gmane" (nntp-address "news.gmane.io"))
        (nnimap "personal"
                (gnus-search-engine gnus-search-imap)
                (nnimap-user "f.guthmann@mailbox.org")
                (nnimap-server-port 993)
                (nnimap-address "imap.mailbox.org")
                (nnimap-stream ssl))
        (nnimap "uni"
                (gnus-search-engine gnus-search-imap)
                (nnimap-user "florian.guthmann@fau.de")
                (nnimap-address "faumail.fau.de")
                (nnimap-stream starttls))))

(set! gnus-use-full-window nil
      gnus-gcc-mark-as-read t
      gnus-novice-user nil
      gnus-expert-user t
      gnus-large-newsgroup nil
      gnus-parameters
      '(("^nnimap"
         (gcc-self . t)
         (gnus-use-scoring . nil)
         (display . all)
         (agent-predicate . always))))

(add-hook 'gnus-group-mode-hook #'gnus-topic-mode)

;;; development ============================================

(add-hook 'prog-mode-hook
          (lambda ()
            (display-line-numbers-mode t)
            (hs-minor-mode t)))

;; git
(straight-use-package 'magit)
(setq-default magit-define-global-key-bindings nil)

(straight-use-package 'diff-hl)
(add-hook 'prog-mode-hook #'diff-hl-mode)

;; compilation
(set! compilation-scroll-output 'first-error
      compilation-ask-about-save nil)

;; lsp
(straight-use-package 'eglot)

(set! eglot-autoshutdown t
      eldoc-echo-area-use-multiline-p nil
      eldoc-idle-delay 0.2
      eglot-confirm-server-initiated-edits nil)

;; syntax checking
(straight-use-package 'flymake)
(add-hook 'prog-mode-hook #'flymake-mode)
(set! help-at-pt-display-when-idle t)


(straight-use-package 'tree-sitter)
(straight-use-package 'tree-sitter-langs)

(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

;; xref
(set! xref-search-program 'ripgrep
      xref-show-xrefs-function #'consult-xref
      xref-show-definitions-function #'consult-xref)

;; project
(straight-use-package 'neotree)

;;; prose languages ========================================
;; HTML
(straight-use-package 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
;; LaTeX
(straight-use-package 'auctex)
(straight-use-package 'auctex-latexmk)

(add-hook 'TeX-mode-hook #'visual-line-mode)
(add-hook 'TeX-mode-hook #'TeX-fold-mode)
(add-hook 'TeX-mode-hook #'LaTeX-math-mode)
(add-hook 'TeX-mode-hook #'reftex-mode)

; disable cape-tex in TeX-mode
(add-hook 'TeX-mode-hook
          (lambda ()
            (setq-local completion-at-point-functions
                        (remove #'cape-tex completion-at-point-functions))))
(set! TeX-master 'dwim
      TeX-engine 'luatex
      TeX-PDF-mode t
      TeX-auto-save t
      TeX-parse-self t
      TeX-electric-math '("$" . "$")
      LaTeX-electric-left-right-brace t)

;; org
(straight-use-package 'org)
(straight-use-package 'org-superstar)

(add-hook 'org-mode-hook #'org-indent-mode)
(add-hook 'org-mode-hook #'visual-line-mode)
(add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))

(set! org-ellipsis " ↴"
      org-highlight-latex-and-related '(latex script entities)
      org-pretty-entities t
      org-preview-latex-image-directory
      (expand-file-name
       "ltxpng"
       (temporary-file-directory))
      org-src-window-setup 'current-window)

(set! org-superstar-special-todo-items t
      org-superstar-leading-bullet ?\s)
                                        ; export
(set! org-html-doctype "xhtml5"
      org-html-html5-fancy t)

;;; programming languages ==================================
;; agda
(load-file (let ((coding-system-for-read 'utf-8))
             (shell-command-to-string "agda-mode locate")))
(add-hook 'agda2-mode-hook (lambda () (aggressive-indent-mode -1)))

;; apl
(straight-use-package 'gnu-apl-mode)
;; c/c++
(straight-use-package 'cc-mode)
(straight-use-package 'cmake-mode)
(add-hook 'c-mode-hook #'eglot-ensure)

;; coq
(straight-use-package 'proof-general)
(set! proof-splash-enable nil
      proof-three-window-enable t
      proof-three-window-mode-policy 'vertical)

(add-hook 'coq-mode-hook
          (defun local/setup-pg-faces ()
            "Setup faces for Proof General."
            (set-face-background 'proof-locked-face "#90ee90")))



;; common-lisp
(straight-use-package 'sly)

;; emacs-lisp
                                        ; overlay evaluation results
(straight-use-package 'eros)
(add-hook 'emacs-lisp-mode #'eros-mode)

;; haskell
(straight-use-package 'haskell-mode)
(add-hook 'haskell-mode-hook #'eglot-ensure)
(add-hook 'haskell-mode-hook #'interactive-haskell-mode)

(set! haskell-completing-read-function #'completing-read)

;; java
(straight-use-package 'antlr-mode)
(add-to-list 'auto-mode-alist '("\\.g4\\'" . antlr-mode))

;; javascript
(straight-use-package 'js2-mode)
(straight-use-package 'json-mode)
(straight-use-package 'rainbow-mode)

(add-hook 'prog-mode-hook #'rainbow-mode)

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; nix
(straight-use-package 'nix-mode)
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))
(defconst nix-electric-pairs
  '(("let" . " in")
    (?= . ";")))

(add-hook 'nix-mode-hook
          (defun nix-add-electric-pairs ()
            (setq-local electric-pair-pairs (append electric-pair-pairs nix-electric-pairs)
                        electric-pair-text-pairs electric-pair-pairs)))
        

;; ocaml
(straight-use-package 'tuareg)

;; prolog
(straight-use-package 'prolog)
(straight-use-package 'ediprolog)

(add-to-list 'auto-mode-alist '("\\.pl\\'" . prolog-mode))
(set! prolog-system 'scryer
      ediprolog-system 'scryer)

;; rust
(straight-use-package 'rust-mode)
(straight-use-package 'cargo)
(add-hook 'rust-mode-hook #'eglot-ensure)

;; shell scripts

(add-hook 'shell-script-mode-hook
          (lambda ()
            (add-hook 'flymake-diagnostic-functions #'flymake-collection-shellcheck)))

;; scheme
(straight-use-package 'geiser)

;;; utilities ==============================================

(defun local/split-window-right ()
  "Like 'split-window-right' , but ask for buffer."
  (interactive)
  (split-window-right)
  (consult-buffer-other-window))

(defun local/split-window-below ()
  "Like 'split-window-below' , but ask for buffer."
  (interactive)
  (split-window-below)
  (consult-buffer-other-window))

(defun local/fill-line (&optional max-column char)
  "Fill rest of current line with CHAR upto column MAX-COLUMN."
  (interactive)
  (or max-column (setq max-column 60))
  (or char (setq char ?=))
  (save-excursion
    (end-of-line)
    (let* ((col (current-column))
           (n (- max-column col)))
      (if (> n 0)
          (insert (make-string n char))))))

(defun local/unix-epoch-show (point)
  "Convert unix epoch at POINT to timestamp and show in overlay."
  (interactive "d")
  (let* ((time-unix (seconds-to-time (thing-at-point 'number)))
         (time-zone "UTC")
         (time-str (format-time-string "%Y-%m-%d %a %H:%M:%S" time-unix time-zone) ))
    (eros--eval-overlay time-str (point))))

(defun local/indent-buffer ()
  "Reformat the whole buffer."
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))

(defun local/mutate-int-at-point (f)
  "Replace integer at point with the result of calling F on it."
  (interactive "aEnter a function:")
  (let ((n (thing-at-point 'number)))
    (if (numberp n)
        (save-excursion
          (message (symbol-name (type-of f)))
          (skip-chars-backward "-0123456789")
          (if (looking-at "-?[0-9]+")
              (let* ((start (point))
                     (end (match-end 0)))
                (delete-region start end)
                (insert (number-to-string (funcall f n))))))
      (message "No number at point"))))

(defun local/inc-at-point ()
  "Increment integer at point."
  (interactive)
  (local/mutate-int-at-point #'1+))

(defun local/dec-at-point ()
  "Decrement integer at point."
  (interactive)
  (local/mutate-int-at-point #'1-))

;;; keybindings ============================================
(straight-use-package 'meow)
(require 'meow)
(set! meow-cheatsheet-layout meow-cheatsheet-layout-qwerty
      meow-use-clipboard t
      meow-expand-hint-remove-delay 0)

(defmap! app-keymap
         "a" #'org-agenda
         "c" #'calc
         "m" #'gnus
         "t" #'eshell)

(defmap! buffer-keymap
         "b" #'consult-buffer
         "k" #'kill-this-buffer
         "r" #'rename-buffer
         "R" #'revert-buffer)

(defmap! code-keymap
         "e" #'consult-flymake
         "f" #'eglot-format
         "o" #'consult-outline)

(defmap! insert-keymap
         "(" #'paredit-wrap-round
         "[" #'paredit-wrap-square
         "{" #'paredit-wrap-curly
         "e" #'emoji-insert
         "y" #'consult-yank-from-kill-ring)

(defmap! project-keymap
         "c" #'project-compile
         "f" #'project-find-file
         "g" #'magit-status
         "r" #'consult-ripgrep
         "t" #'neotree)

(defmap! search-keymap
         "i" #'consult-imenu
         "s" #'consult-line)

(defmap! text-keymap
         "a" #'align-regexp
         "c" #'downcase-dwim
         "C" #'upcase-dwim
         "i" #'local/indent-buffer
         "m" #'consult-mark
         "+" #'local/inc-at-point
         "-" #'local/dec-at-point
         "=" #'local/mutate-int-at-point)

(defmap! window-keymap
         "d" #'delete-window
         "D" #'delete-other-windows
         "s" #'local/split-window-right
         "S" #'local/split-window-below

         "j" #'windmove-down
         "k" #'windmove-up
         "h" #'windmove-left
         "l" #'windmove-right)

;; overwrite magit keybindings for meow
(with-eval-after-load 'magit
  (define-key magit-mode-map "x" #'magit-discard)
  (define-key magit-mode-map "J" #'meow-next-expand)
  (define-key magit-mode-map "K" #'meow-prev-expand)
  (define-key magit-mode-map "L" #'magit-log))

(meow-motion-overwrite-define-key
 '("j" . meow-next)
 '("k" . meow-prev)
 '("h" . meow-left)
 '("l" . meow-right)
 '("<escape>" . ignore))

(meow-leader-define-key
 '("u" . undo-redo)
 '(":" . execute-extended-command)
 '(";" . pp-eval-expression)
 '("." . find-file)
 '("," . consult-buffer)
 '("TAB" . hs-toggle-hiding)
 '("a" . app-keymap)
 '("b" . buffer-keymap)
 '("<" . code-keymap)
 '("i" . insert-keymap)
 '("p" . project-keymap)
 '("s" . search-keymap)
 '("t" . text-keymap)
 '("w" . window-keymap)

 '("1" . meow-digit-argument)
 '("2" . meow-digit-argument)
 '("3" . meow-digit-argument)
 '("4" . meow-digit-argument)
 '("5" . meow-digit-argument)
 '("6" . meow-digit-argument)
 '("7" . meow-digit-argument)
 '("8" . meow-digit-argument)
 '("9" . meow-digit-argument)
 '("0" . meow-digit-argument)
 '("/" . meow-keypad-describe-key)
 '("?" . meow-cheatsheet))

(meow-normal-define-key
 '("0" . meow-expand-0)
 '("9" . meow-expand-9)
 '("8" . meow-expand-8)
 '("7" . meow-expand-7)
 '("6" . meow-expand-6)
 '("5" . meow-expand-5)
 '("4" . meow-expand-4)
 '("3" . meow-expand-3)
 '("2" . meow-expand-2)
 '("1" . meow-expand-1)
 '("-" . negative-argument)
 '(";" . meow-reverse)
 '("," . meow-inner-of-thing)
 '("." . meow-bounds-of-thing)
 '("<" . meow-beginning-of-thing)
 '(">" . meow-end-of-thing)
 '("a" . meow-append)
 '("A" . meow-open-below)
 '("b" . meow-back-word)
 '("B" . meow-back-symbol)
 '("c" . meow-change)
 '("d" . meow-delete)
 '("D" . meow-backward-delete)
 '("e" . meow-next-word)
 '("E" . meow-next-symbol)
 '("f" . meow-find)
 '("g" . meow-cancel-selection)
 '("G" . meow-grab)
 '("h" . meow-left)
 '("H" . meow-left-expand)
 '("i" . meow-insert)
 '("I" . meow-open-above)
 '("j" . meow-next)
 '("J" . meow-next-expand)
 '("k" . meow-prev)
 '("K" . meow-prev-expand)
 '("l" . meow-right)
 '("L" . meow-right-expand)
 '("m" . meow-join)
 '("n" . meow-search)
 '("o" . meow-block)
 '("O" . meow-to-block)
 '("p" . meow-yank)
 '("q" . meow-quit)
 '("Q" . meow-goto-line)
 '("r" . meow-replace)
 '("R" . meow-swap-grab)
 '("s" . meow-kill)
 '("t" . meow-till)
 '("u" . meow-undo)
 '("U" . meow-undo-in-selection)
 '("v" . meow-visit)
 '("w" . meow-mark-word)
 '("W" . meow-mark-symbol)
 '("x" . meow-line)
 '("X" . meow-goto-line)
 '("y" . meow-save)
 '("Y" . meow-sync-grab)
 '("z" . meow-pop-selection)
 '("'" . repeat)
 '("<escape>" . ignore))

(meow-global-mode t)

;;; init.el ends here

