# vim:ft=make

include aux/pip.mk

.PHONY: install
install: all
	$(ANSIBLE_PLAYBOOK) site.yml -u deploy

all: $(PREREQ) $(ROLE_FILES) $(ROLE_META) $(ROLE_VARS) $(BUILD)

.DEFAULT_GOAL:= all
.NOTPARALLEL:
