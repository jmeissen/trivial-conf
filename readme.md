# Trivial conf

Simple Common Lisp library to load and save a Lisp-structured file as a plist.

I think reading .env files makes no sense in CL, this tiny library makes it easy to
read and write lisp config files as plists.

## Usage

```lisp
(setf conf:*conf-path*
      (merge-pathnames "config.lisp"
                       (asdf:system-source-directory :my-pkg)))

;;
;; Adding keys
;;

(setf (conf:key :toplevel :secondlevel)
      '(some elements here))

;; (conf:key :toplevel :secondlevel)           => (some elements here)
;; (conf:key :toplevel)                        => (:secondlevel (some elements here))
;; (conf:key :some :non-existent :combination) => NIL

(conf:save)

;;
;; And loading it from file:
;;

(setf conf:*conf-path*
      (merge-pathnames "config.lisp"
                       (asdf:system-source-directory :my-pkg)))

(conf:load)

```

# API
## Special variables
- `*CONF-PATH*`
- `*CONFIG*`

## Functions
### Reload
- `RELOAD &optional path => result*`

### Load
- `LOAD &optional path => result*`

### key
- `KEY &rest keys => value`

#### setf key
- `(SETF (KEY &rest keys)) new-value => new-value`

### save
- `SAVE &key if-exists if-does-not-exist => pathname`
