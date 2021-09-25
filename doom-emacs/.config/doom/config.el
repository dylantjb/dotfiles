;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Dylan Barker"
      user-mail-address "dylan@dylantjb.com")

(setq doom-scratch-buffer-major-mode nil)

;; (use-package! dashboard
;;   :init
;;   (setq dashboard-set-heading-icons t)
;;   (setq dashboard-set-file-icons t)
;;   (setq dashboard-banner-logo-title "Emacs Is More Than A Text Editor!")
;;   (setq dashboard-startup-banner (expand-file-name "dashboard.png" doom-private-dir))
;;   (setq dashboard-center-content t)
;;   (setq dashboard-items '((recents . 5)
;;                           (agenda . 5 )
;;                           (bookmarks . 5)
;;                           (projects . 5)
;;                           (registers . 5)))
;;   :config
;;   (dashboard-setup-startup-hook)
;;   (dashboard-modify-heading-icons '((recents . "file-text")
;;                                     (bookmarks . "book"))))

;; (setq doom-fallback-buffer-name "*dashboard*")

(remove-hook 'doom-first-input-hook #'evil-snipe-mode)

(setq doom-theme 'doom-one)

(setq org-directory "~/documents/org")

(setq display-line-numbers-type 'relative)

(after! evil-escape (setq evil-escape-key-sequence "jj"))

(use-package! org-caldav
  :commands (org-caldav-sync)
  :init
  (setq org-caldav-url "https://cloud.dylantjb.com/remote.php/dav/calendars/dylan")
  (setq org-caldav-calendars
        '((:calendar-id "personal"
           :files ("~/documents/org/calendars/personal.org")
           :inbox "~/documents/org/calendars/personal-inbox.org")
          (:calendar-id "tasks"
           :files ("~/documents/org/calendars/tasks.org")
           :inbox "~/documents/org/calendars/tasks-inbox.org")))
  (setq org-caldav-backup-file "~/.cache/org-caldav/backup.org")
  (setq org-caldav-save-directory "~/.cache/org-caldav")
  (setq org-caldav-sync-todo 'all)
  :config
  (setq org-icalendar-timezone "Europe/London"))

(after! mu4e
  (setq user-mail-address "dylanbarker59@gmail.com"
        user-full-name  "Dylan Barker"
        ;; mu4e-update-interval (* 10 60)
        mu4e-change-filenames-when-moving t
        mu4e-main-buffer-hide-personal-addresses t

        sendmail-program (executable-find "msmtp")
        message-sendmail-f-is-evil t
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-send-mail-function #'message-send-mail-with-sendmail

        mu4e-get-mail-command "mbsync -ac ~/.config/mbsync/config"
        mu4e-sent-folder "/dylanbarker59@gmail.com/[Gmail]/Sent Mail"
        mu4e-drafts-folder "/dylanbarker59@gmail.com/[Gmail]/Drafts"
        mu4e-trash-folder "/dylanbarker59@gmail.com/[Gmail]/Bin"
        mu4e-maildir-shortcuts
        '(("/dylanbarker59@gmail.com/INBOX" . ?i)
          ("/dylanbarker59@gmail.com/[Gmail]/Sent Mail" . ?s)
          ("/dylanbarker59@gmail.com/[Gmail]/Drafts" . ?d)
          ("/dylanbarker59@gmail.com/[Gmail]/Bin" . ?t))))

(defvar my-mu4e-account-alist
  '(("dylanbarker59@gmail.com"
     (user-mail-address "dylanbarker59@gmail.com")
     (mu4e-sent-folder "/dylanbarker59@gmail.com/[Gmail]/Sent Mail")
     (mu4e-drafts-folder "/dylanbarker59@gmail.com/[Gmail]/Drafts")
     (mu4e-trash-folder "/dylanbarker59@gmail.com/[Gmail]/Bin")
     (mu4e-compose-signature
       (concat
         "Dylan Barker\n"
         "dylanbarker59@gmail.com\n"))
    ("dylan@dylantjb.com"
     (user-mail-address "dylan@dylantjb.com")
     (mu4e-sent-folder "/dylan@dylantjb.com/Sent")
     (mu4e-drafts-folder "/dylan@dylantjb.com/Drafts")
     (mu4e-trash-folder "/dylan@dylantjb.com/Trash")
     (mu4e-compose-signature
       (concat
         "Dylan Barker\n"
         "dylan@dylantjb.com\n")))
    ("k20001430@kcl.ac.uk"
     (user-mail-address "k20001430@kcl.ac.uk")
     (mu4e-sent-folder "/k20001430@kcl.ac.uk/Sent")
     (mu4e-drafts-folder "/k20001430@kcl.ac.uk/Drafts")
     (mu4e-trash-folder "/k20001430@kcl.ac.uk/Trash")
     (mu4e-compose-signature
       (concat
         "Dylan Barker\n"
         "k20001430@kcl.ac.uk\n"))))))

(defun greedily-do-daemon-setup ()
  (require 'org)
  (when (require 'mu4e nil t)
    (setq mu4e-confirm-quit t)
    (setq +mu4e-lock-greedy t)
    (setq +mu4e-lock-relaxed t)
    (when (+mu4e-lock-available t)
      (mu4e~start))))

(when (daemonp)
  (add-hook 'emacs-startup-hook #'greedily-do-daemon-setup)
  (add-hook! 'server-after-make-frame-hook (switch-to-buffer doom-fallback-buffer-name)))
