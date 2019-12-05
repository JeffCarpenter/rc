
(define %local-use-guix-official-mirror #t)

(define %backup-default-channels
  ;; Default list of channels.
  (list (channel
         ;; (name 'guix-github)
         (name 'guix)
         (branch "master")
         (url "https://github.com/guix-mirror/guix.git"))))

(define %guix-official-channels %default-channels)

(define %guix-lotus-channels (list (channel
                                    (name 'lotus)
                                    (url "https://github.com/sharad/guix"))))

(define %nonguix-channels (list (channel
                                 (name 'nonguix)
                                 (url "https://gitlab.com/nonguix/nonguix"))))

(define %local-default-channels
  (if %local-use-guix-official-mirror
      %guix-official-channels
      %backup-default-channels))

(define %local-channels (append %nonguix-channels
                                %guix-lotus-channels
                                %local-default-channels))

%local-channels
