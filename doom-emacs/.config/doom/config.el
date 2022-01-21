(setq user-full-name "Dylan Barker"
      user-mail-address "dylan@dylantjb.com"
      auth-sources '("~/.local/share/authinfo.gpg"))

(setq display-line-numbers-type 'relative)

(run-with-idle-timer 30 t #'save-some-buffers t)

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font"))
(custom-set-faces
 '(magit-diff-base ((((type tty)) (:extend t) (:foreground "#cc4c00"))))
 '(magit-diff-our ((((type tty)) (:inherit magit-diff-removed))))
 '(magit-diff-added ((((type tty)) (:extend t) (:foreground "#afff00"))))
 '(magit-diff-their ((((type tty)) (:inherit magit-diff-added))))
 '(magit-diff-context ((((type tty)) (:extend t) (:foreground "#888888"))))
 '(magit-diff-removed ((((type tty)) (:extend t) (:background "#4d3434") (:foreground "#ff0000"))))
 '(magit-diff-hunk-region ((((type tty)) (:inherit bold))))
 '(magit-diff-file-heading ((((type tty)) (:extend t) (:weight bold) (:foreground "#e4e4e4"))))
 '(magit-diff-hunk-heading ((((type tty)) (:extend t))))
 '(magit-diff-lines-heading ((((type tty)) (:extend t) (:background "#ff0000") (:foreground "#ffd700"))))
 '(magit-diff-our-highlight ((((type tty)) (:inherit magit-diff-removed-highlight))))
 '(magit-diff-base-highlight ((((type tty)) (:weight bold) (:extend t) (:foreground "#ff5f00"))))
 '(magit-diff-lines-boundary ((((type tty)) (:extend t) (:inherit magit-diff-lines-heading))))
 ;; '(magit-diff-added-highlight ((((type tty)) (:weight bold) (:extend t) (:foreground "LimeGreen"))))
 ;; '(magit-diff-their-highlight ((((type tty)) (:foreground ""))))
 ;; '(magit-diff-conflict-heading ((((type tty)) (:foreground ""))))
 ;; '(magit-diff-revision-summary ((((type tty)) (:foreground ""))))
 ;; '(magit-diff-context-highlight ((((type tty)) (:foreground ""))))
 ;; '(magit-diff-removed-highlight ((((type tty)) (:foreground ""))))
 ;; '(magit-diff-whitespace-warning ((((type tty)) (:foreground ""))))
 ;; '(magit-diff-file-heading-highlight ((((type tty)) (:foreground ""))))
 ;; '(magit-diff-file-heading-selection ((((type tty)) (:foreground ""))))
 ;; '(magit-diff-hunk-heading-highlight ((((type tty)) (:foreground ""))))
 ;; '(magit-diff-hunk-heading-selection ((((type tty)) (:foreground ""))))
 ;; '(magit-diff-revision-summary-highlight ((((type tty)) (:foreground ""))))

 ;; '(magit-diff-added ((((type tty)) (:foreground "green"))))
 ;; '(magit-diff-added-highlight ((((type tty)) (:foreground "LimeGreen"))))
 ;; '(magit-diff-context-highlight ((((type tty)) (:foreground "default"))))
 ;; '(magit-diff-file-heading ((((type tty)) nil)))
 ;; '(magit-diff-none ((((type tty) (class color) (min-colors 256)) (:inherit diff-context))
 ;;                    (((type graphic)) (:inherit diff-context))))
 ;; '(magit-diff-removed ((((type tty)) (:foreground "red"))))
 ;; '(magit-diff-removed-highlight ((((type tty)) (:foreground "IndianRed"))))
 ;; '(magit-section-highlight ((((type tty)) nil))))
 )

(setq byte-compile-warnings '(cl-functions))

(setq projectile-project-search-path '("~/repos"))

(require 'elcord)

(defvar-local my-flycheck-local-cache nil)
(defun my-flycheck-checker-get (fn checker property)
  (or (alist-get property (alist-get checker my-flycheck-local-cache))
      (funcall fn checker property)))
(advice-add 'flycheck-checker-get :around 'my-flycheck-checker-get)

(setq lsp-clients-clangd-args '("-j=4"
                                "--background-index"
                                "--clang-tidy"
                                "--completion-style=detailed"
                                "--header-insertion=never"
                                "--header-insertion-decorators=0"))
(after! lsp-clangd (set-lsp-priority! 'clangd 2))
(add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++11")))
(add-hook 'lsp-managed-mode-hook
          (lambda ()
            (when (derived-mode-p 'c++-mode)
              (setq my-flycheck-local-cache '((lsp . ((next-checkers . (c/c++-clang)))))))))

(defun my-pyvenv-autoload ()
  (require 'projectile)
  (let* ((pdir (projectile-project-root)) (pfile (concat pdir ".venv")))
    (if (file-exists-p pfile)
        (pyvenv-workon (with-temp-buffer
                         (insert-file-contents pfile)
                         (nth 0 (split-string (buffer-string)))))
      (pyvenv-deactivate))))
(add-hook 'python-mode-hook 'my-pyvenv-autoload)
(add-hook 'lsp-managed-mode-hook
          (lambda ()
            (when (derived-mode-p 'python-mode)
              (setq my-flycheck-local-cache '((lsp . ((next-checkers . (python-pylint)))))))))

(add-hook 'lsp-managed-mode-hook
          (lambda ()
            (when (derived-mode-p 'scala-mode)
              (setq my-flycheck-local-cache '((lsp . ((next-checkers . (scala)))))))))

(defun my-open-calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-file-source "School" "~/documents/gtd/timetable.org" "IndianRed"))))
(map! :leader :prefix ("o" . "open")
      :desc "Calendar" "c" #'my-open-calendar)

(use-package! dashboard
  :init
  (setq dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-center-content t
        dashboard-items '((recents   . 5)
                          (bookmarks . 5)
                          (projects  . 5)))
  :config
  (dashboard-setup-startup-hook)
  (dashboard-modify-heading-icons '((recents   . "file-text")
                                    (bookmarks . "book"))))

(require 'org-habit)
(require 'org-checklist)
(after! org
  (setq org-directory "~/documents/org"
        org-log-done 'time
        org-log-into-drawer t
        org-hide-emphasis-markers t
        org-tag-alist
        '((:startgroup . nil)
          ("@home"    . ?h)
          ("@library" . ?l)
          ("@uni"     . ?u)
          (:endgroup   . nil)
          ("chore"    . ?c)
          ("event"    . ?e)
          ("fit"      . ?f)
          ("health"   . ?H)
          ("module"   . ?m)
          ("shop"     . ?s)
          ("uni"      . ?U)
          ("tutorial" . ?t))
        org-todo-keywords
        '((sequence
           "NEXT(n)"
           "TODO(t)"
           "WAIT(w@)"
           "|"
           "DONE(d)"
           "CANCELED(c@)"))))

(use-package! org-wild-notifier
  :init (add-hook 'after-init-hook 'org-wild-notifier-mode)
  :config (setq alert-default-style 'libnotify))

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
  :config (setq org-icalendar-timezone "Europe/London"))

(use-package! org-super-agenda
  :after org-gtd
  :config (org-super-agenda-mode)
  :init
  (setq org-agenda-skip-scheduled-if-done t
        org-agenda-property-list '("DELEGATED_TO")
        org-agenda-start-day "today"
        org-agenda-skip-deadline-if-done t
        org-agenda-include-deadlines t
        org-agenda-tags-column 100
        org-super-agenda-header-map nil
        org-agenda-compact-blocks nil
        org-agenda-files `(,org-gtd-directory)
        org-agenda-custom-commands '(("g" "GTD View"
                                      ((agenda "" ((org-agenda-span 1)
                                                   (org-super-agenda-groups
                                                    '((:name ""
                                                       :date nil
                                                       :scheduled nil
                                                       :order 0)
                                                      (:date today)
                                                      (:auto-parent t)))))
                                       (alltodo "" ((org-agenda-overriding-header "")
                                                    (org-super-agenda-groups
                                                     '((:discard (:habit t))
                                                       (:auto-parent t))))))))))

(use-package! org-capture
  :after org-gtd
  :config
  (setq org-capture-templates `(("i" "Inbox"
                                 entry (file ,(org-gtd-inbox-path))
                                 "* %?\n%U\n\n  %i"
                                 :kill-buffer t)
                                ("t" "Todo with link"
                                 entry (file ,(org-gtd-inbox-path))
                                 "* %?\n%U\n\n  %i\n  %a"
                                 :kill-buffer t))))

(require 'org-gtd)
(require 'org-gtd-refile)
(defun org-gtd-show-agenda (&optional arg)
  (interactive "P")
  (org-agenda arg "g"))
(defun org-gtd-match-tags (&optional arg)
  (interactive "P")
  (org-agenda arg "m"))

(add-hook 'org-after-refile-insert-hook #'save-buffer)

(use-package org-gtd
  :after org
  :demand t
  :custom
  (org-gtd-directory "~/documents/gtd")
  (org-agenda-property-position 'next-line)
  (org-edna-use-inheritance t)
  :config (org-edna-mode)
  :init
  (map! :after org
        :map org-mode-map
        :leader
        (:prefix-map ("d" . "GTD")
         :desc "Agenda view"            "a" #'org-gtd-show-agenda
         :desc "Inbox Capture"          "i" #'org-gtd-capture
         :desc "Show All Next"          "n" #'org-gtd-show-all-next
         :desc "Process Inbox"          "p" #'org-gtd-process-inbox
         :desc "Show Stuck Projects"    "s" #'org-gtd-show-stuck-projects
         :desc "Show Matched Tags"      "t" #'org-gtd-match-tags))
  :bind (:map org-gtd-process-map
         ("C-c c" . org-gtd-choose)))

(after! mu4e
  (setq mu4e-change-filenames-when-moving t
        mu4e-main-buffer-hide-personal-addresses t
        mu4e-get-mail-command "~/.local/bin/scripts/syncmail"
        message-sendmail-f-is-evil t

        sendmail-program (executable-find "msmtp")
        message-sendmail-extra-arguments '("--read-envelope-from")
        send-mail-function #'smtpmail-send-it
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

(defun my-daemon-setup ()
  (when (require 'mu4e nil t)
    (setq mu4e-confirm-quit t)
    (mu4e~start))
  (setq doom-theme 'doom-one
        doom-fallback-buffer-name "*dashboard*"))

(when (daemonp))
  (add-hook 'emacs-startup-hook #'my-daemon-setup)
  (add-hook! 'server-after-make-frame-hook (switch-to-buffer doom-fallback-buffer-name))
