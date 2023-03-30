; basic init.el


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 3)
(setq-default tab-width 3)
(setq-default c-default-style "bsd")
(show-paren-mode 1)
(auto-revert-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(wombat))
 '(custom-safe-themes
   '("d606ac41cdd7054841941455c0151c54f8bff7e4e050255dbd4ae4d60ab640c1" default))
 '(package-selected-packages
   '(go-mode cmake-mode powerline markdown-mode rust-mode foggy-night-theme ##)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(require 'package)
(add-to-list
 'package-archives
 '("melpa" . "https://melpa.org/packages/"))
(add-to-list
 'package-archives
 '("gnu" . "https://elpa.gnu.org/packages"))
(package-initialize)

(load-theme 'wombat)

(require 'powerline)
(powerline-default-theme)
