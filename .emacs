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

;; Language
(use-package eglot
  :ensure t
  :hook ((rust-mode c-mode c++-mode) . eglot-ensure)
  :config
  (setq eglot-autoshutdown t)
  (setq eglot-sync-connect nil)
 )

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

(with-eval-after-load 'magit
  (global-set-key (kbd "C-x g") #'magit-status))


(use-package corfu
  :ensure t
  :init
  (global-corfu-mode))

(use-package magit
  :bind (("C-x g" . magit-status)))


(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(rust-mode . ("rust-analyzer"))))

(setq-default eglot-workspace-configuration
              '((:clangd . (:fallbackFlags ["-std=c++20"]))))

(with-eval-after-load 'flymake
  (global-set-key (kbd "C-c ! l")
                  #'flymake-show-buffer-diagnostics))

(setq tab-always-indent 'complete)
(setq corfu-auto t)
(setq corfu-auto-delay 0.2)
(setq corfu-auto-prefix 1)
