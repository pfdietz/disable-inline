(asdf:defsystem :disable-inline
    :version "0.0.0"
    :description "Simple utility to disable inlining dynamically"
    :long-description "Enables use a macroexpand hook that causes
defpackage to shadow INLINE to another symbol that is an ignorable
declaration."
    :author "Grammatech"
    :components ((:file "disable-inline")))
