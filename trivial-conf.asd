#-asdf3.1 (error "system-name requires ASDF 3.1 or later.")
(asdf:defsystem #:trivial-conf
  :class :package-inferred-system
  :pathname #p"src/"
  :description "Trivial plist configuration file loading and saving."
  :author "Jeffrey Meissen <jeffrey@meissen.email>"
  :license "Public Domain"
  :version "1.0.0"
  :depends-on (:trivial-conf/all))
