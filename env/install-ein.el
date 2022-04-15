(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-refresh-contents)
(custom-set-variables
 '(package-selected-packages '(ein)))
(package-install-selected-packages t)
