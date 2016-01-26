# vim:ft=make

.SUFFIXES:
.SUFFIXES:

BUILD:=
CHECK:=
DISTCLEAN:=
MAINTAINERCLEAN:=
PREREQ=

PKG_INSTALLER=
PKG_UPDATE=
PKG_UPGRADE=
PKG_SEARCH_INSTALL= $(PKG_INSTALLER) $(1)
BASE_INSTALL_PATH= /usr/

HOSTNAME:= `hostname`
HOST_TYPE:= `hostname | cut -d'-' -f1`
HOST_UUID:= `hostname | cut -d'-' -f2`
ALL_SCRIPTS:= $(wildcard *.sh) 

include aux/common.mk
include aux/pip.mk
include aux/ansible.mk
include aux/git.mk

DIST_MAKEFILES:=

.PHONY: clean
clean:
	@rm -rf $(BUILD)
	@find roles | grep role.yml | xargs rm

.PHONY: distclean
distclean: clean distclean-am

.PHONY: distclean-am
distclean-am:
	@rm -rf $(PREREQ)
	@rm -rf $(DISTCLEAN)

.PHONY: maintainer-clean
maintainer-clean: distclean
	@rm -rf $(MAINTAINERCLEAN)
	@rm -rf $(PIP_DIR)

.PHONY: check
check: all $(CHECK)

PREREQ+= public_keys/$(dirstamp)
public_keys/$(dirstamp):
	@$(MKDIR_P) $(@D)
	@$(TOUCH) $@

PREREQ+= public_keys/deploy
public_keys/deploy: public_keys/$(dirstamp)
	@cp ~/.ssh/id_rsa.pub $@

PREREQ+= public_keys/brian
public_keys/brian: public_keys/$(dirstamp)
	@$(TOUCH) $@ 
	curl https://github.com/brianaker.keys >> $@

PREREQ+= public_keys/jenkins
public_keys/jenkins: public_keys/$(dirstamp)
	@$(TOUCH) $@ 
	@$(CURL) https://github.com/TangentCI.keys >> $@

PREREQ+= roles/$(dirstamp)
roles/$(dirstamp):
	@$(MKDIR_P) $(@D)
	@$(TOUCH) $@

.PHONY: install
install: all
	@$(ANSIBLE_PLAYBOOK) go.yml -u deploy

.PHONY: install-ansible-user
install-ansible-user: inventory/localhost
	@$(ANSIBLE_PLAYBOOK) go.yml --limit=localhost -s

.PHONY: upgrade
upgrade: all
	@$(ANSIBLE_PLAYBOOK) maintenance.yml

.PHONY: localhost
localhost: all inventory/localhost
	@$(ANSIBLE_PLAYBOOK) go.yml -i inventory/localhost

.PHONY: deploy
deploy: install

all: $(ANSIBLE_PLAYBOOK) $(PREREQ) $(BUILD)

.DEFAULT_GOAL:= all

.NOTPARALLEL:
