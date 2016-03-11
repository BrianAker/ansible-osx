# vim:ft=make
 
srcdir:= $(shell pwd)

WGET_KEYS:= wget --timestamping --quiet --timestamping --directory-prefix=$(TMP_FILES) --no-host-directories --no-directories
CURL:=curl --silent --show-error
INSTALL:= install -b
MKDIR_P:= mkdir -p
TOUCH_R:= touch -r
TOUCH:= touch
dirstamp:= .dirstamp
