(setq custom-file "~/.emacs.d/emacs-custom.el")
(load custom-file)
(require 'package)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
	("org" . "https://orgmode.org/elpa/")
	("melpa" . "http://melpa.org/packages/")))
(package-initialize)
(package-refresh-contents)


(set-face-attribute 'default nil :height 140)

(setq visible-bell nil
      ring-bell-function 'flash-mode-line)
(defun flash-mode-line ()
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil #'invert-face 'mode-line))

(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)

(set-face-attribute 'mode-line nil :foreground "black" :background "gray90")
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(electric-pair-mode 1)
(set-background-color "gray10")
(set-foreground-color "white")
(show-paren-mode 1)

(setq power-mode-shake-strength nil)
(setq power-mode-streak-shake-threshold nil)
(use-package power-mode
  :load-path "~/.emacs.d"
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

(require 'lsp-java)
(add-hook 'java-mode-hook #'lsp)

;(setq ido-everywhere t)
;(setq ido-enable-flex-matching t)
;(setq ido-show-dot-for-dired t)
;(ido-mode t)
(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))

(use-package savehist
  :init
  (savehist-mode))

(use-package marginalia
  :after vertico
  :ensure t
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-x p") 'projectile-command-map)
  (projectile-mode 1))

(use-package dashboard
  :ensure t
  :init
  (progn
    (setq dashboard-items '((recents . 10)
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

;(use-package centaur-tabs
;  :ensure t
;  :config
;  (setq centaur-tabs-set-bar 'over
;	centaur-tabs-set-icons t
;	centaur-tabs-gray-out-icons 'buffer
;	centaur-tabs-height 24
;	centaur-tabs-set-modified-marker t
;	centaur-tabs-modified-marker "*")
; (centaur-tabs-mode t))

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/Documents/RoamNotes")
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup))

(use-package magit
  :ensure t)

(defun brian/evil-hook()
  (dolist (mode '(custom-mode
		  eshell-mode
		  git-rebase-mode
		  erc-mode
		  circe-server-mode
		  circe-chat-mode
		  circe-query-mode
		  sauron-mode
		  term-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

;; Enable Evil
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :hook (evil-mode . brian/evil-hook)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-tabs
  :config
  (global-evil-tabs-mode t))
