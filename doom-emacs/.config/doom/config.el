;;; config.el -*- lexical-binding: t; -*-
(setq user-full-name "Dylan Barker"
      user-mail-address "dylan@dylantjb.com"
      auth-sources '("~/.local/share/authinfo.gpg"))

(setq display-line-numbers-type 'relative)

(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font"))

(setq byte-compile-warnings '(cl-functions))

(setq emms-lyrics-dir "~/.local/share/lyrics")

(defun my-open-calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-file-source "School" "~/documents/org/timetable.org" "IndianRed"))))
(map! :leader :prefix ("o" . "open")
      :desc "Calendar" "c" #'my-open-calendar)

(setq doom-fallback-buffer-name "*dashboard*"
      +doom-dashboard-name "*dashboard*")

(use-package! dashboard
  :init
  (setq dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-center-content t
        dashboard-items '((recents   . 10)
                          (bookmarks . 5)
                          (projects  . 5)))
  :config
  (dashboard-setup-startup-hook)
  (dashboard-modify-heading-icons '((recents   . "file-text")
                                    (bookmarks . "book"))))

(setq org-directory "~/documents/org")
(after! org
  (setq org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-log-done 'time
        org-journal-dir "~/documents/org/journal/"
        org-journal-date-format "%B %d, %Y (%A) "
        org-journal-file-format "%Y-%m-%d.org"
        org-hide-emphasis-markers t))

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

(use-package! org-super-agenda
  :commands org-super-agenda-mode)
(after! org-agenda
  (org-super-agenda-mode))

(setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-tags-column 100
      org-agenda-compact-blocks t)

(setq org-agenda-custom-commands
      '(("o" "Overview"
         ((agenda "" ((org-agenda-span 'day)
                      (org-super-agenda-groups
                       '((:name "Today"
                          :time-grid t
                          :date today
                          :todo "TODAY"
                          :scheduled today
                          :order 1)))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:name "Next to do"
                           :todo "NEXT"
                           :order 1)
                          (:name "Important"
                           :tag "Important"
                           :priority "A"
                           :order 6)
                          (:name "Due Today"
                           :deadline today
                           :order 2)
                          (:name "Due Soon"
                           :deadline future
                           :order 8)
                          (:name "Overdue"
                           :deadline past
                           :face error
                           :order 7)
                          (:name "Assignments"
                           :tag "Assignment"
                           :order 10)
                          (:name "Issues"
                           :tag "Issue"
                           :order 12)
                          (:name "Emacs"
                           :tag "Emacs"
                           :order 13)
                          (:name "Projects"
                           :tag "Project"
                           :order 14)
                          (:name "Research"
                           :tag "Research"
                           :order 15)
                          (:name "To read"
                           :tag "Read"
                           :order 30)
                          (:name "Waiting"
                           :todo "WAITING"
                           :order 20)
                          (:name "University"
                           :tag "uni"
                           :order 32)
                          (:name "Trivial"
                           :priority<= "E"
                           :tag ("Trivial" "Unimportant")
                           :todo ("SOMEDAY")
                           :order 90)
                          (:discard (:tag ("Chore" "Routine" "Daily")))))))))))

(after! mu4e
  (setq mu4e-change-filenames-when-moving t
        mu4e-main-buffer-hide-personal-addresses t
        mu4e-compose-signature "---\nDylan Barker"
        mu4e-get-mail-command "~/.local/bin/scripts/syncmail"
        message-sendmail-f-is-evil t
        sendmail-program (executable-find "msmtp")
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-send-mail-function #'message-send-mail-with-sendmail
        mu4e-bookmarks '((:name "Unread messages" :query "flag:unread AND (maildir:/Google/INBOX OR maildir:/School/INBOX OR maildir:/Domain/INBOX)" :key ?u)
                         (:name "Today's messages" :query "date:today..now AND (maildir:/Google/INBOX OR maildir:/School/INBOX OR maildir:/Domain/INBOX)" :key ?t)
                         (:name "Last 7 days" :query "date:7d..now AND (maildir:/Google/INBOX OR maildir:/School/INBOX OR maildir:/Domain/INBOX)" :hide-unread t :key ?w)
                         ("flag:flagged" "Flagged messages" ?f)))

  (set-email-account! "Domain"
                      '((mu4e-sent-folder       . "/Domain/Sent")
                        (mu4e-drafts-folder     . "/Domain/Drafts")
                        (mu4e-trash-folder      . "/Domain/Trash")
                        (smtpmail-smtp-user     . "dylan@dylantjb.com")
                        (user-mail-address      . "dylan@dylantjb.com")
                        (mu4e-maildir-shortcuts . ((:maildir "/Domain/INBOX"  :key ?i)
                                                   (:maildir "/Domain/Sent"   :key ?s)
                                                   (:maildir "/Domain/Drafts" :key ?d)
                                                   (:maildir "/Domain/Trash"  :key ?t)))) t)
  (set-email-account! "School"
                      '((mu4e-sent-folder       . "/School/Sent")
                        (mu4e-drafts-folder     . "/School/Drafts")
                        (mu4e-trash-folder      . "/School/Trash")
                        (smtpmail-smtp-user     . "k20001430@kcl.ac.uk")
                        (user-mail-address      . "k20001430@kcl.ac.uk")
                        (mu4e-maildir-shortcuts . ((:maildir "/School/INBOX"  :key ?i)
                                                   (:maildir "/School/Sent"   :key ?s)
                                                   (:maildir "/School/Drafts" :key ?d)
                                                   (:maildir "/School/Trash"  :key ?t)))) t)
  (set-email-account! "Google"
                      '((mu4e-sent-folder       . "/Google/[Gmail]/Sent Mail")
                        (mu4e-drafts-folder     . "/Google/[Gmail]/Drafts")
                        (mu4e-trash-folder      . "/Google/[Gmail]/Bin")
                        (smtpmail-smtp-user     . "dylanbarker59@gmail.com")
                        (user-mail-address      . "dylanbarker59@gmail.com")
                        (mu4e-maildir-shortcuts . ((:maildir "/Google/INBOX"             :key ?i)
                                                   (:maildir "/Google/[Gmail]/Sent Mail" :key ?s)
                                                   (:maildir "/Google/[Gmail]/Drafts"    :key ?d)
                                                   (:maildir "/Google/[Gmail]/Bin"       :key ?b)))) t))

(defun greedily-do-daemon-setup ()
  (require 'org)
  (require 'org-habit)
  (require 'org-checklist)
  (when (require 'mu4e nil t)
    (setq mu4e-confirm-quit t)
    (mu4e~start)))

(when (daemonp)
  (add-hook 'emacs-startup-hook #'greedily-do-daemon-setup)
  (add-hook! 'server-after-make-frame-hook (switch-to-buffer doom-fallback-buffer-name)))
