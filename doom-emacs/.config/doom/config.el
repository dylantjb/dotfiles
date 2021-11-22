(setq user-full-name "Dylan Barker"
      user-mail-address "dylan@dylantjb.com"
      auth-sources '("~/.local/share/authinfo.gpg"))

(setq display-line-numbers-type 'relative)

(run-with-idle-timer 30 t #'save-some-buffers t)

(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font"))

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
        dashboard-items '((recents   . 5)
                          (bookmarks . 5)
                          (projects  . 5)))
  :config
  (dashboard-setup-startup-hook)
  (dashboard-modify-heading-icons '((recents   . "file-text")
                                    (bookmarks . "book"))))

(use-package! tree-sitter
  :when (bound-and-true-p module-file-suffix)
  :hook (prog-mode . tree-sitter-mode)
  :hook (tree-sitter-after-on . tree-sitter-hl-mode)
  :config
  (require 'tree-sitter-langs)
  (defadvice! doom-tree-sitter-fail-gracefully-a (orig-fn &rest args)
    "Don't break with errors when current major mode lacks tree-sitter support."
    :around #'tree-sitter-mode
    (condition-case e
        (apply orig-fn args)
      (error
       (unless (string-match-p (concat "^Cannot find shared library\\|"
                                       "^No language registered\\|"
                                       "cannot open shared object file")
                               (error-message-string e))
         (signal (car e) (cadr e)))))))

(require 'org-habit)
(after! org
  (setq org-directory "~/documents/org")
  (setq org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-log-done 'time
        org-log-into-drawer t
        org-hide-emphasis-markers t
        org-todo-keywords
        '((sequence
           "TODO(t)"
           "NEXT(n)"
           "WAITING(w)"
           "SOMEDAY(s)"
           "|"
           "DONE(d)"
           "CANCELLED(c)" ))))

(use-package! org-wild-notifier
  :init
  (add-hook 'after-init-hook 'org-wild-notifier-mode)
  :config
  (setq alert-default-style 'libnotify))

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
  :after org-agenda
  :config (org-super-agenda-mode)
  :init
  (setq org-agenda-skip-scheduled-if-done t
        org-agenda-start-day nil
        org-agenda-skip-deadline-if-done t
        org-agenda-include-deadlines t
        org-agenda-block-separator nil
        org-agenda-tags-column 100
        org-agenda-compact-blocks t
        org-agenda-files '("~/documents/org")
        org-agenda-custom-commands
        '(("o" "Overview"
           ((agenda)
            (todo "NEXT" ((org-agenda-overriding-header "Next actions:")))
            (todo "WAITING" ((org-agenda-overriding-header "Waiting on:")))
            (todo "DONE" ((org-agenda-overriding-header "Completed items:")))
            (tags "projects" ((org-agenda-overriding-header "Projects in progress:")))
            (alltodo "" ((org-agenda-overriding-header "")
                         (org-super-agenda-groups
                          '((:name "Next to do"
                             :todo "NEXT"
                             :order 1)
                            (:name "Important"
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
                             :tag "assignment"
                             :order 10)
                            (:name "Emacs"
                             :tag "emacs"
                             :order 13)
                            (:name "Projects"
                             :tag "project"
                             :order 14)
                            (:name "Research"
                             :tag "research"
                             :order 15)
                            (:name "To read"
                             :tag "book"
                             :order 30)
                            (:name "Waiting"
                             :todo "WAITING"
                             :order 20)
                            (:name "University"
                             :tag "uni"
                             :order 32)
                            (:name "Trivial"
                             :priority<= "E"
                             :todo "SOMEDAY"
                             :order 90)
                            (:discard (:tag ("habit"))))))))))))

(setq mu4e-change-filenames-when-moving t
      mu4e-main-buffer-hide-personal-addresses t
      mu4e-compose-signature "---\nDylan Barker"
      mu4e-get-mail-command "mbsync -ac ~/.config/isync/mbsyncrc"
      mu4e-update-interval 900
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
                                                 (:maildir "/Google/[Gmail]/Bin"       :key ?b)))) t)

(defun my-daemon-setup ()
  (when (require 'mu4e nil t)
    (setq mu4e-confirm-quit t)
    (mu4e~start)))

(when (daemonp)
  (add-hook 'emacs-startup-hook #'my-daemon-setup)
  (add-hook! 'server-after-make-frame-hook (switch-to-buffer doom-fallback-buffer-name)))
