;;; query the bbdb for all records matching a given string; return them
;;; in lbdb-suitable format 
;;; 
;;; This code is (c) Utz-Uwe Haus <haus@uuhaus.de> 2001
;;; Use, reuse and deletion are permitted in any way you can up with.

(require 'bbdb)
(require 'bbdb-com)

(defun lbdb-bbdb-query (string)
  "Display all entries in the BBDB matching STRING in the Name, Company or
email fields in lbdb-usable format, i.e. 
<email-address>[TAB]<Full Name>[TAB]<comment>
where <comment> is BBDB:timestamp."
  (let ((matches
	 (bbdb-search (bbdb-records) string string string nil nil))
	(result ""))
    (mapcar 
     (lambda (record) 
       (let ((name (bbdb-record-name record))
	     (timestamp (bbdb-record-getprop record 'timestamp)))
	 (mapcar
	  (lambda (this-email)
	    (setq result
		  (concat result 
			  (format "%s\t%s\tBBDB:%s\n" this-email name timestamp))))
	  (bbdb-record-net record))))
     matches)
    (princ result)))
;; the princ is for for emacs and xemacs, return value is for gnuclient

(provide 'lbdb-bbdb-query)


; use like:
;(lbdb-bbdb-query "grae")
