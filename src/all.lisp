(in-package #:cl-user)

(uiop:define-package trivial-conf/all
  (:use #:cl)
  (:shadow #:load)
  (:nicknames #:trivial-conf
              #:conf)
  (:export #:*conf-path*
           #:*config*
           #:reload
           #:load
           #:key
           #:save))

(in-package #:trivial-conf/all)

(defvar *conf-path* (merge-pathnames
                     "config.lisp"
                     (asdf:system-source-directory :trivial-conf))
  "The default configuration source path.

This should be changed to the project-local config path.")

(defvar *config* nil
  "The currently loaded configuration.

This is a plist and is plainly stored as such.")

(defun reload (&optional (path *conf-path*))
  "Synonym of `load'."
  (load path))

(defun load (&optional (path *conf-path*))
  "Load PATH into `*config*'.

Returns no values."
  (when path (setf *conf-path* path))
  (setf *config* (uiop:read-file-forms *conf-path*))
  (values))

(defun key (&rest keys)
  "Retrieve value by keys

For example:
(key :toplevel :secondlevel) => nil

Return NIL when the key is not found, otherwise return the value.
"
  (labels ((key-rec (conf ks)
             (if ks
                 (key-rec (getf conf (first ks)) (rest ks))
                 conf)))
    (key-rec (or *config* (load)) keys)))

(defun (setf key) (value &rest keys)
  "Set VALUE by KEYS.

For example:
  (setf (key :toplevel :secondlevel) 'value)

Now this key can be retrieved with:
  (key :toplevel :secondlevel) => 'value

Returns no values
"
  (unless (listp *config*) (setf *config* '()))
  (labels ((update-plist (plist keys val)
             (if (null keys)
                 val
                 (let ((k (first keys)))
                   (if (null (rest keys))
                       (let ((new-plist (copy-list plist)))
                         (setf (getf new-plist k) val)
                         new-plist)
                       (let* ((sub (getf plist k))
                              (sub (if (listp sub) sub '()))
                              (new-sub (update-plist sub (rest keys) val))
                              (new-plist (copy-list plist)))
                         (setf (getf new-plist k) new-sub)
                         new-plist))))))
    (if keys
        (progn (setf *config* (update-plist *config* keys value)) value)
        (progn (setf *config* value) value)))
  (values))

(defun save (&key (if-exists :overwrite) (if-does-not-exist :create))
  "Save `*config*' to `*conf-path*'.

IF-EXISTS and IF-DOES-NOT-EXIST are reapplied to `with-open-file', where the file is
now created by default when nonexistent.

Returns the path of the saved file."
  (with-open-file (s *conf-path*
                     :if-exists if-exists
                     :if-does-not-exist if-does-not-exist
                     :external-format :utf-8
                     :direction :output)
    (format s "~{~S~%~2t~S~%~}" *config*)
    *conf-path*))
