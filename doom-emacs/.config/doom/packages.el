;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! dashboard)
(package! org-super-agenda :pin "a5557ea4f51571ee9def3cd9a1ab1c38f1a27af7")
(package! org-wild-notifier)
(package! mu4e-alert :disable t)
(package! org-gtd :recipe
  (:host github
   :repo "trevoke/org-gtd.el"
   :branch "2.0.0"))
(package! elcord)
;; (package! org-caldav :recipe
;;   (:host github
;;    :repo "whirm/org-caldav"
;;    :branch "sync-todos"))
