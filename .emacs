;;; -*- lexical-binding: t -*-

;; Package management
(require 'package)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
	("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))


(menu-bar-mode -1)

(global-display-line-numbers-mode)

(add-to-list 'load-path "~/.emacs.local/")
(require 'simpc-mode)

(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'")

(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "multimarkdown"))

(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'"  . js-mode))
(add-to-list 'auto-mode-alist '("\\.mjs\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.cjs\\'" . js-mode))

;; Language Server Protocol
(use-package eglot
  :ensure t
  :hook ((rust-mode c-mode c++-mode js-mode simpc-mode) . eglot-ensure)
  :config
  (setq eglot-autoshutdown t)
  (setq eglot-sync-connect nil)
  )


(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(rust-mode . ("rust-analyzer")))
  (add-to-list 'eglot-server-programs
	       '(js-mode . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs '(c-mode . ("clangd")))
  (add-to-list 'eglot-server-programs '(c++-mode . ("clangd")))
  (add-to-list 'eglot-server-programs '(simpc-mode . ("clangd")))
  )


(setq-default eglot-workspace-configuration
              '((:clangd . (:fallbackFlags ["-std=c++20"]))))

;; Disable startup screen
(setq inhibit-startup-screen t)

;; Highlight current line
(global-hl-line-mode t)

;; Auto-pair parentheses, brackets, quotes
(electric-pair-mode 1)

;; Delete selected text when typing
(delete-selection-mode 1)

;; Keep files ending with newline
(setq require-final-newline t)

;; Enable syntax highting everywhere
(global-font-lock-mode t)

;; 备份和自动保存文件设置
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))
(setq create-lockfiles nil)  ; 禁用 .#file 符号链接锁文件

;; function folding
(add-hook 'prog-mode-hook #'hs-minor-mode)

(require 'project)

;; Keybindings
;;(global-set-key (kbd "C-c p f") #'project-find-file)
;;(global-set-key (kbd "C-c p s") #'project-shell)
(global-set-key (kbd "C-c d") 'duplicate-line)
(global-set-key (kbd "C-x c") 'compile)
(with-eval-after-load 'magit
  (global-set-key (kbd "C-x g") #'magit-status))

(use-package company
  :ensure t
  :init (global-company-mode)
  :config
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 1))

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode))

(use-package magit
  :bind (("C-x g" . magit-status)))

(use-package flymake
  :ensure nil  ; Flymake 是 Emacs 内置包，无需从 ELPA 安装
  :bind ("C-c ! l" . flymake-show-buffer-diagnostics)
  :config
  ;; 如果你还有其他 Flymake 相关的配置，可以放在这里
  )
(setq tab-always-indent 'complete)
(setq corfu-auto t)
(setq corfu-auto-delay 0.2)
(setq corfu-auto-prefix 1)
(xterm-mouse-mode 1)
(mouse-wheel-mode 1)

(use-package multiple-cursors
  :ensure t
  :bind (("M-n" . mc/mark-next-like-this)
         ("M-p" . mc/mark-previous-like-this)
         ("C-c C-a" . mc/mark-all-like-this)))
(global-set-key (kbd "C-c |") 'align-regexp)
(use-package iedit
  :bind ("C-;" . iedit-mode))


;; Restore classic C-j behavior in Emacs Lisp buffers
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (local-set-key (kbd "C-j") #'eval-print-last-sexp)))


(with-eval-after-load 'rust-mode
  (define-key rust-mode-map (kbd "C-c C-f") #'rust-format-buffer))

;;(load-theme 'modus-vivendi t)
(load-theme 'gruber-darker t)

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess up it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(treemacs-projectile treemacs expand-region rust-mode multiple-cursors magit gruber-darker-theme corfu)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess up it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; C-c c Capture
;; C-c C-s schedule
;; C-c a Agenda
;; C-c C-e export
;; C-c C-c make sure
;; C-c ' edit the code block
(setq org-todo-keywords
      '((sequence "TODO(t)" "DOING(i)" "BLOCKED(b)" "|" "DONE(d)" "CANCELLED(c)")))
(setq org-agenda-files '("~/org"))
(setq org-capture-templates
      '(("t" "Todo" entry
         (file "~/org/inbox.org")
         "* TODO %?\n  %U")))


(defun my-split-window-right-and-move ()
  "Split window horizontally and move focus to new window."
  (interactive)
  (split-window-right)
  (other-window 1))

(defun my-split-window-below-and-move ()
  "Split window vertically and move focus to new window."
  (interactive)
  (split-window-below)
  (other-window 1))

(global-set-key (kbd "C-x 3") 'my-split-window-right-and-move)
(global-set-key (kbd "C-x 2") 'my-split-window-below-and-move)

(setq compile-command "")

(global-set-key (kbd "C-x C-b") 'ibuffer)

(defun syscpy ()
  (interactive)
  (when (use-region-p)
    (shell-command-on-region
     (region-beginning)
     (region-end)
     "pbcopy")
    (deactivate-mark)))

(defun copy-current-line ()
  (interactive)
  (kill-new
   (buffer-substring
    (line-beginning-position)
    (line-beginning-position 2)))
  (message "Line copied"))
(global-set-key (kbd "C-c l") #'copy-current-line)

;; Avy navigation
(use-package avy
  :ensure t
  :bind (("M-s" . avy-goto-char-timer)))
(setq avy-all-windows t)     ;; 跨窗口
(setq avy-background t)      ;; 不遮挡文本
(setq avy-timeout-seconds 0.3) ;; 输入停顿判定（可调）

;; Treemacs
(use-package treemacs
  :ensure t
  :bind (("C-x t t" . treemacs)))
(setq compilation-scroll-output t)
