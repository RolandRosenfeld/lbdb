;;; lbdb.el - Little brother database interface.
;; Copyright 2000 by Dave Pearson <davep@davep.org>
;; $Revision$

;; lbdb.el is free software distributed under the terms of the GNU
;; General Public Licence, version 2. For details see the file COPYING.

;;; Commentary:
;;
;; lbdb.el is an emacs interface to the little brother database. You can
;; find out more about lbdb at <URL:http://www.spinnaker.de/lbdb/>.

;;; INSTALLATION:
;;
;; o Drop lbdb.el somwehere into your `load-path'. Try your site-lisp
;;   directory for example (you might also want to byte-compile the file).
;;
;; o Add the following autoload statement to your ~/.emacs file:
;;
;;   (autoload 'lbdb "lbdb" "Query the little brother database" t)

;;; Code:

;; Things we need:

(eval-when-compile
  (require 'cl))

;; Attempt to handle older/other emacs.
(eval-and-compile
  ;; If customize isn't available just use defvar instead.
  (unless (fboundp 'defgroup)
    (defmacro defgroup  (&rest rest) nil)
    (defmacro defcustom (symbol init docstring &rest rest)
      `(defvar ,symbol ,init ,docstring))))

;; Customize options.

(defgroup lbdb nil
  "Little brother database interface"
  :group  'external
  :prefix "lbdb-")

(defcustom lbdb-query-command "lbdbq"
  "*Command for querying the little brother database."
  :type 'string
  :group 'lbdb)

(defcustom lbdb-sort-display 'name
  "*The method used to sort the results display."
  :type '(choice
          (const :tag "Sort by name"          name)
          (const :tag "Sort by email address" email)
          (const :tag "Don't sort"            nil))
  :group 'lbdb)

(defcustom lbdb-mode-hook nil
  "*Hooks for `lbdb-mode'."
  :type  'hook
  :group 'lbdb)

(defcustom lbdb-name-format-function (lambda (entry) (lbdb-name entry))
  "*Function to format the name before insertion into the current buffer."
  :type  'function
  :group 'lbdb)

(defcustom lbdb-address-format-function (lambda (entry)
                                          (format "<URL:mailto:%s>" (lbdb-email entry)))
  "*Function to format the email address before insertion into the current
buffer."
  :type  'function
  :group 'lbdb)

(defcustom lbdb-full-format-function (lambda (entry)
                                       (format "\"%s\" <%s>"
                                               (lbdb-name entry)
                                               (lbdb-email entry)))
  "*Function to format the name and email address before insertion into the
current buffer."
  :type  'function
  :group 'lbdb)

;; Constants.

(defconst lbdb-buffer-name "*lbdb*"
  "Name of the little brother database buffer.")

;; Non-customize variables.

(defvar lbdb-mode-map nil
  "Local keymap for a `lbdb-mode' buffer.")

(defvar lbdb-last-buffer nil
  "`current-buffer' when `lbdb' was called.")

(defvar lbdb-results nil
  "The results of the current query.")

;; Data access functions.

(defsubst lbdb-email (entry)
  "Return the email address of a lbdb entry."
  (nth 0 entry))

(defsubst lbdb-name (entry)
  "Return the name of a lbdb entry."
  (nth 1 entry))

(defsubst lbdb-method (entry)
  "Return the acquisition method of a lbdb entry."
  (nth 2 entry))

;; Support functions.

(defun lbdb-generate-format-string (results)
  "Generate a `format' string for displaying RESULTS."
  (let ((email-len 0)
        (name-len 0))
    (loop for line in results
          do (progn
               (setq email-len (max email-len (length (lbdb-email line))))
               (setq name-len  (max name-len  (length (lbdb-name  line))))))
    (format "%%-%ds %%-%ds %%s" name-len email-len)))

(defun lbdb-line-as-list ()
  "Split the current line into its component parts.

The return value is a list, the component parts of that list are:

  (ADDRESS NAME METHOD)

Where ADDRESS is the email address, NAME is the name associated with that
email address and METHOD is the method lbdbq used to find that address."
  (split-string (buffer-substring-no-properties
                 (point)
                 (save-excursion
                   (end-of-line)
                   (point)))
                "\t"))

(defun lbdb-buffer-to-list ()
  "Convert the current buffer into a lbdb result list.

It is assumed that the current buffer contains the output of a call to
lbdbq."
  (save-excursion
    (setf (point) (point-min))
    (loop until (eobp)
          unless (looking-at "^$") collect (lbdb-line-as-list)
          do (forward-line))))

(defun lbdb-sort (results)
  "Sort a lbdb result list.

The type of sort is controlled by `lbdb-sort-display'."
  (if lbdb-sort-display
      (sort results (case lbdb-sort-display
                      (name
                       (lambda (x y)
                         (string< (downcase (lbdb-name x)) (downcase (lbdb-name y)))))
                      (email
                       (lambda (x y)
                         (string< (downcase (lbdb-email x)) (downcase (lbdb-email y)))))))
    results))

;; Main code.

;;;###autoload
(defun lbdb (query)
  "Interactively query the little brother database."
  (interactive "sQuery: ")
  (let* ((results (lbdbq query (interactive-p)))
         (format  (lbdb-generate-format-string results)))
    (if results
        (progn
          (setq lbdb-results results)
          (unless (string= (buffer-name) lbdb-buffer-name)
            (setq lbdb-last-buffer (current-buffer)))
          (pop-to-buffer lbdb-buffer-name)
          (let ((buffer-read-only nil))
            (setf (buffer-string) "")
            (loop for line in results
                  do (insert
                      (format format (lbdb-name line) (lbdb-email line) (lbdb-method line))
                      "\n")))
          (setf (point) (point-min))
          (lbdb-mode))
      (error "No matches found in the little brother database"))))

(defun lbdbq (query &optional interactive)
  "Query the little brother database and return a list of results."
  (with-temp-buffer
    (when interactive
      (message "Querying the little brother database..."))
    (call-process lbdb-query-command nil (current-buffer) nil (format "\"%s\"" query))
    (prog1
        (lbdb-sort (lbdb-buffer-to-list))
      (when interactive
        (message "Querying the little brother database...done")))))

;; lbdb mode.

(unless lbdb-mode-map
  (let ((map (make-sparse-keymap)))
    (suppress-keymap map t)
    (define-key map "a"           #'lbdb-insert-address)
    (define-key map "n"           #'lbdb-insert-name)
    (define-key map [return]      #'lbdb-insert-full)
    (define-key map "q"           #'lbdb-mode-quit)
    (define-key map [(control g)] #'lbdb-mode-quit)
    (define-key map "?"           #'describe-mode)
    (setq lbdb-mode-map map)))

(put 'lbdb-mode 'mode-class 'special)

(defun lbdb-mode ()
  "A mode for browsing the results a an `lbdb' query.

The key bindings for `lbdb-mode' are:

\\{lbdb-mode-map}"
  (interactive)
  (kill-all-local-variables)
  (use-local-map lbdb-mode-map)
  (setq major-mode 'lbdb-mode
        mode-name  "lbdb")
  (run-hooks 'lbdb-mode-hook)
  (setq buffer-read-only t
        truncate-lines t)
  (buffer-disable-undo (current-buffer)))

(defun lbdb-mode-quit ()
  "Quit the current lbdb buffer."
  (interactive)
  (kill-buffer lbdb-buffer-name)
  (switch-to-buffer lbdb-last-buffer)
  (delete-other-windows))

(defun lbdb-insert (type)
  "Insert the details of the lbdb entry under the cursor.

TYPE dictates what will be inserted, options are:

  `name'    - Insert the name.
              `lbdb-name-format-function' is used to format the name.

  `address' - Insert the address.
              `lbdb-address-format-function' is used to format the address.

  `full'    - Insert the name and the address.
              `lbdb-full-format-function' is used to format the name
              and address."
  (let ((line (nth (save-excursion
                     (beginning-of-line)
                     (count-lines (point-min) (point)))
                   lbdb-results)))
    (if line
        (with-current-buffer lbdb-last-buffer
          (insert
           (case type
             ('name    (funcall lbdb-name-format-function line))
             ('address (funcall lbdb-address-format-function line))
             ('full    (funcall lbdb-full-format-function line)))))
      (error "No details on that line"))
    line))

(defmacro lbdb-make-inserter (type)
  "Macro to make a key-response function for use in `lbdb-mode-map'."
  `(defun ,(intern (format "lbdb-insert-%S" type)) ()
    ,(format "Insert the result of calling `lbdb-insert' with `%s'." type)
    (interactive)
    (when (lbdb-insert ',type)
      (lbdb-mode-quit))))

(lbdb-make-inserter name)
(lbdb-make-inserter address)
(lbdb-make-inserter full)

(provide 'lbdb)

;;; lbdb.el ends here
