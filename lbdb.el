;;; lbdb.el - Little Brother's Database interface.
;; Copyright 2000 by Dave Pearson <davep@davep.org>
;; $Revision$

;; lbdb.el is free software distributed under the terms of the GNU
;; General Public Licence, version 2. For details see the file COPYING.

;;; Commentary:
;;
;; lbdb.el is an emacs interface to the Little Brother's Database. You can
;; find out more about LBDB at <URL:http://www.spinnaker.de/lbdb/>.
;;
;; A number of commands are provided, they are:
;;
;; `lbdb' : Perform an interactive LBDB query.
;;
;; `lbdb-region' : Query the LBDB for the content of the current region.
;;
;; `lbdb-maybe-region' : If a mark is active, search for the content of the
;; region in the LBDB, otherwise perform an interactive query.
;;
;; `lbdb-last' : Recall and work with the results of the last query you
;; performed.
;;
;; The latest lbdb.el is always available from:
;;
;;   <URL:http://www.hagbard.demon.co.uk/archives/lbdb.el>
;;   <URL:http://www.acemake.com/hagbard/archives/lbdb.el>

;;; BUGS:
;;
;; o Mouse selection doesn't work in XEmacs.

;;; INSTALLATION:
;;
;; o Drop lbdb.el somwehere into your `load-path'. Try your site-lisp
;;   directory for example (you might also want to byte-compile the file).
;;
;; o Add the following autoload statements to your ~/.emacs file:
;;
;;   (autoload 'lbdb "lbdb" "Query the Little Brother's Database" t)
;;   (autoload 'lbdb-region "lbdb" "Query the Little Brother's Database" t)
;;   (autoload 'lbdb-maybe-region "lbdb" "Query the Little Brother's Database" t)

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
      `(defvar ,symbol ,init ,docstring)))

  ;; If `line-beginning-position' isn't available, provide one.
  (unless (fboundp 'line-beginning-position)
    (defun line-beginning-position ()
      "Return the `point' of the beginning of the current line."
      (save-excursion
        (beginning-of-line)
        (point))))
  
  ;; If `line-end-position' isn't available, provide one.
  (unless (fboundp 'line-end-position)
    (defun line-end-position ()
      "Return the `point' of the end of the current line."
      (save-excursion
        (end-of-line)
        (point)))))

;; Customize options.

(defgroup lbdb nil
  "Little Brother's Database interface"
  :group  'external
  :prefix "lbdb-")

(defcustom lbdb-query-command "lbdbq"
  "*Command for querying the Little Brother's Database."
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

(defcustom lbdb-mouse-select-action 'lbdb-insert-full
  "*Pointer to the function that is called when mouse-2 is pressed."
  :type  '(choice
           (const :tag "Insert the name/address combination" lbdb-insert-full)
           (const :tag "Insert only the email address"       lbdb-insert-address)
           (const :tag "Insert only the name"                lbdb-insert-name))
  :group 'lbdb)

;; Constants.

(defconst lbdb-buffer-name "*lbdb*"
  "Name of the Little Brother's Database buffer.")

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
  (loop for line in results
        for email-len = (length (lbdb-email line)) then (max email-len (length (lbdb-email line)))
        for name-len  = (length (lbdb-name  line)) then (max name-len  (length (lbdb-name  line)))
        finally return (format "%%-%ds %%-%ds %%s" name-len email-len)))

(defun lbdb-line-as-list ()
  "Split the current line into its component parts.

The return value is a list, the component parts of that list are:

  (ADDRESS NAME METHOD)

Where ADDRESS is the email address, NAME is the name associated with that
email address and METHOD is the method lbdbq used to find that address."
  (split-string (buffer-substring-no-properties (point) (line-end-position)) "\t"))

(defun lbdb-buffer-to-list ()
  "Convert the current buffer into a lbdb result list.

It is assumed that the current buffer contains the output of a call to
lbdbq."
  (save-excursion
    (setf (point) (point-min))
    (forward-line)                      ; Skip the message line.
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

(defun lbdb-mark-active-p ()
  "Is there a mark active?

Because there's more than one true emacs."
  (if (boundp 'mark-active)
      ;; GNU Emacs.
      (symbol-value 'mark-active)
    ;; X Emacs.
    (funcall (symbol-function 'region-exists-p))))

(defun lbdb-deactivate-mark ()
  "Deactivate any active mark.

Because there's more than one true emacs."
  (when (fboundp 'deactivate-mark)
    ;; GNU emacs.
    (funcall (symbol-function 'deactivate-mark))))

;; Main code.

;;;###autoload
(defun lbdb (query)
  "Interactively query the Little Brother's Database."
  (interactive "sQuery: ")
  (lbdb-present-results (lbdbq query (interactive-p))))

;;;###autoload
(defun lbdb-region (start end)
  "Look for the contents of regioning bounded by START and END."
  (interactive "r")
  (lbdb-deactivate-mark)
  (lbdb (buffer-substring-no-properties start end)))

;;;###autoload
(defun lbdb-maybe-region ()
  "If region is active search for content of region otherwise prompt."
  (interactive)
  (call-interactively (if (lbdb-mark-active-p) #'lbdb-region #'lbdb)))

;;;###autoload
(defun lbdb-last ()
  "Recall and use the results of the last successful query."
  (interactive)
  (lbdb-present-results lbdb-results))

(defun lbdb-present-results (results)
  "Present the results in a buffer and allow the user to interact with them."
  (if results
      (let ((format (lbdb-generate-format-string results)))
        (setq lbdb-results results)
        (unless (string= (buffer-name) lbdb-buffer-name)
          (setq lbdb-last-buffer (current-buffer)))
        (pop-to-buffer lbdb-buffer-name)
        (let ((buffer-read-only nil))
          (setf (buffer-string) "")
          (loop for line in results
                do (let ((start (point)))
                     (insert
                      (format format (lbdb-name line) (lbdb-email line) (lbdb-method line))
                      "\n")
                     (put-text-property start (1- (point)) 'mouse-face 'highlight))))
        (setf (point) (point-min))
        (lbdb-mode))
    (error "No matches found in the Little Brother's Database")))

(defun lbdbq (query &optional interactive)
  "Query the Little Brother's Database and return a list of results.

QUERY is the text to search for.

If INTERACTIVE is non-nil the message area will be updated with the progress
of the function. This parameter is optional and the deafult is nil."
  (with-temp-buffer
    (when interactive
      (message "Querying the Little Brother's Database..."))
    (call-process lbdb-query-command nil (current-buffer) nil query)
    (prog1
        (lbdb-sort (lbdb-buffer-to-list))
      (when interactive
        (message "Querying the Little Brother's Database...done")))))

;; lbdb mode.

(unless lbdb-mode-map
  (let ((map (make-sparse-keymap)))
    (suppress-keymap map t)
    (define-key map "a"           #'lbdb-insert-address)
    (define-key map "n"           #'lbdb-insert-name)
    (define-key map (kbd "RET")   #'lbdb-insert-full)
    (define-key map "q"           #'lbdb-mode-quit)
    (define-key map [(control g)] #'lbdb-mode-quit)
    (define-key map [mouse-2]     #'lbdb-mouse-select)
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
        truncate-lines   t)
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
  (let ((line (nth (count-lines (point-min) (line-beginning-position)) lbdb-results)))
    (if line
        (with-current-buffer lbdb-last-buffer
          (insert
           (case type
             ('name    (funcall lbdb-name-format-function line))
             ('address (funcall lbdb-address-format-function line))
             ('full    (funcall lbdb-full-format-function line)))))
      (error "No details on that line"))
    line))

(defun lbdb-mouse-select (event)
  "Select the entry under the mouse click."
  (interactive "e")
  (setf (point) (posn-point (event-end event)))
  (funcall lbdb-mouse-select-action))

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
