 ;;; -*- lexical-binding: t -*-

(setq custom-file "~/.emacs.custom.el") ;; set customized variables
(load-file custom-file)

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

(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'"  . js-mode))
(add-to-list 'auto-mode-alist '("\\.mjs\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.cjs\\'" . js-mode))

;; Language
(use-package eglot
  :ensure t
  :hook ((rust-mode c-mode c++-mode js-mode) . eglot-ensure)
  :config
  (setq eglot-autoshutdown t)
  (setq eglot-sync-connect nil)
  )


(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(rust-mode . ("rust-analyzer")))
  (add-to-list 'eglot-server-programs
	       '(js-mode . ("typescript-language-server" "--stdio")))
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

;; function folding
(add-hook 'prog-mode-hook #'hs-minor-mode)

(require 'project)

;; Keybindings
(global-set-key (kbd "C-c p f") #'project-find-file)
(global-set-key (kbd "C-c p s") #'project-shell)
(global-set-key (kbd "C-c d") 'duplicate-line)
(with-eval-after-load 'magit
  (global-set-key (kbd "C-x g") #'magit-status))


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
  :bind (("C-c n" . mc/mark-next-like-this)
         ("C-c p" . mc/mark-previous-like-this)
         ("C-c a" . mc/mark-all-like-this)
         ("C-c l" . mc/edit-lines)))

;; Restore classic C-j behavior in Emacs Lisp buffers
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (local-set-key (kbd "C-j") #'eval-print-last-sexp)))
