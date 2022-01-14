(setq custom-file "~/.emacs.d/emacs-custom.el")
(load custom-file)
(require 'package)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
	("org" . "https://orgmode.org/elpa/")
	("melpa" . "http://melpa.org/packages/")))

(setq visible-bell nil
      ring-bell-function 'flash-mode-line)
(defun flash-mode-line ()
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil #'invert-face 'mode-line))

(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)

(set-face-attribute 'mode-line nil :foreground "black" :background "cyan")

(electric-pair-mode 1)
(set-background-color "gray8")
(set-foreground-color "white")
(show-paren-mode 1)

(setq power-mode-shake-strength nil)
(setq power-mode-streak-shake-threshold nil)
(use-package power-mode
  :load-path "~/.emacs.d/power-mode.el"
  :init
  (add-hook 'after-init-hook #'power-mode))

;; Move cursor to end of current line
;; Insert new line below current line
;; it will also indent newline
(global-set-key (kbd "<C-return>") (lambda ()
		   (interactive)
		   (end-of-line)
		   (newline-and-indent)))

;; Move cursor to previous line
;; Go To end of the line
;; Insert new line below current line (So it actually insert new line above with indentation)
;; it will also indent newline
(global-set-key (kbd "<C-S-return>") (lambda ()
		       (interactive)
		       (previous-line)
		       (end-of-line)
		       (newline-and-indent)
		       ))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)))

(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match
that used by the user's shell.

This is particularly useful under Mac OS X and macOS, where GUI
apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
			  "[ \t\n]*$" "" (shell-command-to-string
					  "$SHELL --login -c 'echo $PATH'"
						    ))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-PATH)

(which-key-mode)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  (yas-global-mode))

(setq ido-everywhere t)
(setq ido-enable-flex-matching t)
(setq ido-show-dot-for-dired t)
(ido-mode t)

(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-x p") 'projectile-command-map)
  (projectile-mode 1))

(use-package dashboard
  :ensure t
  :init
  (progn
    (setq dashboard-items '((recents . 5)
			    (projects . 3)
			    (agenda . 5))))
  (setq dashboard-center-content t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-startup-banner "~/.emacs.d/sticker.png")
  (setq dashboard-banner-logo-title "'Writepo :(' - Baby")
  (setq dashboard-image-banner-max-height 150)
  (setq dashboard-image-banner-max-width 150)
  :config
  (dashboard-setup-startup-hook))

(setq org-agenda-start-with-log-mode t)
(setq org-log-done 'time)
(setq org-log-into-drawer t)

(use-package expand-region
  :ensure t
  :config
  (global-set-key (kbd "C-=") 'er/expand-region))

(use-package centaur-tabs
  :ensure t
  :config
  (setq centaur-tabs-set-bar 'over
	centaur-tabs-set-icons t
	centaur-tabs-gray-out-icons 'buffer
	centaur-tabs-height 24
	centaur-tabs-set-modified-marker t
	centaur-tabs-modified-marker "*")
  (centaur-tabs-mode t))
