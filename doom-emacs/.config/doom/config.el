;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Dylan Barker"
      user-mail-address "dylan@dylantjb.com")

(with-eval-after-load "emojify"
  (delete 'mu4e-headers-mode emojify-inhibit-major-modes))

(use-package! dashboard
  :init
  (setq dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-banner-logo-title "Emacs Is More Than A Text Editor!"
        dashboard-center-content t
        dashboard-items '((recents . 5)
                          (agenda . 5 )
                          (bookmarks . 5)
                          (projects . 5)
                          (registers . 5)))
  :config
  (dashboard-setup-startup-hook)
  (dashboard-modify-heading-icons '((recents . "file-text")
                                    (bookmarks . "book"))))

(setq doom-fallback-buffer-name "*dashboard*"
      +doom-dashboard-name "*dashboard*")

(remove-hook 'doom-first-input-hook #'evil-snipe-mode)

(setq doom-theme 'doom-one)

(after! org
  (setq org-directory "~/documents/org")
  (setq org-log-done 'time)
  (setq org-todo-keywords '((sequence "TODO(t)" "PROJ(p)" "HOMEWORK(h)" "COURSEWORK(c)"
                                      "|" "DONE(d)" "CANCELLED(c)"))))

(setq display-line-numbers-type 'relative)

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
        mu4e-change-filenames-when-moving t
        mu4e-main-buffer-hide-personal-addresses t

        sendmail-program (executable-find "msmtp")
        message-sendmail-f-is-evil t
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-send-mail-function #'message-send-mail-with-sendmail

        mu4e-compose-signature "---\nDylan Barker"

        mu4e-get-mail-command "mbsync -ac ~/.config/mbsync/config")

  (set-email-account! "Domain"
                      '((mu4e-sent-folder       . "/Domain/Sent")
                        (mu4e-drafts-folder     . "/Domain/Drafts")
                        (mu4e-trash-folder      . "/Domain/Trash")
                        (smtpmail-smtp-user     . "dylan@dylantjb.com")
                        (mu4e-maildir-shortcuts . (("/Domain/INBOX" . ?i)
                                                   ("/Domain/Sent" . ?s)
                                                   ("/Domain/Drafts" . ?d)
                                                   ("/Domain/Trash" . ?b)))) t)
  (set-email-account! "School"
                      '((mu4e-sent-folder       . "/School/Sent")
                        (mu4e-drafts-folder     . "/School/Drafts")
                        (mu4e-trash-folder      . "/School/Trash")
                        (smtpmail-smtp-user     . "k20001430@kcl.ac.uk")
                        (mu4e-maildir-shortcuts . (("/School/INBOX" . ?i)
                                                   ("/School/Sent" . ?s)
                                                   ("/School/Drafts" . ?d)
                                                   ("/School/Trash" . ?t)))) t)
  (set-email-account! "Google"
                      '((mu4e-sent-folder       . "/Google/Sent Mail")
                        (mu4e-drafts-folder     . "/Google/Drafts")
                        (mu4e-trash-folder      . "/Google/Bin")
                        (smtpmail-smtp-user     . "dylanbarker59@gmail.com")
                        (mu4e-maildir-shortcuts . (("/Google/INBOX" . ?i)
                                                   ("/Google/Sent Mail" . ?s)
                                                   ("/Google/Drafts" . ?d)
                                                   ("/Google/Bin" . ?t)))) t))

(defun greedily-do-daemon-setup ()
  (require 'org)
  (when (require 'mu4e nil t)
    (setq mu4e-confirm-quit t)
    (mu4e)))

(when (daemonp)
  (add-hook 'emacs-startup-hook #'greedily-do-daemon-setup)
  (add-hook! 'server-after-make-frame-hook (switch-to-buffer doom-fallback-buffer-name)))
