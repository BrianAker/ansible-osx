.SUFFIXES:

BUILD:=
CHECK:=
DISTCLEAN:=
MAINTAINERCLEAN:=
PREREQ:=
SANITY:=

PKG_INSTALLER=
PKG_UPDATE=
PKG_UPGRADE=
PKG_SEARCH_INSTALL= $(PKG_INSTALLER) $(1)
BASE_INSTALL_PATH= /usr/

HOSTNAME:= `hostname`
HOST_TYPE:= `hostname | cut -d'-' -f1`
HOST_UUID:= `hostname | cut -d'-' -f2`
ALL_SCRIPTS:= $(wildcard *.sh) 

TMP_FILES:= tmp
TMP_DIR= $(TMP_FILES)/$(dirstamp)
DISTCLEAN+= $(TMP_FILES)

DIST_MAKEFILES:=

include aux/common.mk
include aux/pip.mk
include aux/ansible.mk
include aux/git.mk

.PHONY: clean
clean:
	@rm -rf $(BUILD)
	@rm -rf $(TMP_DIR)
	@find roles | grep role.yml | xargs rm

.PHONY: distclean
distclean: clean distclean-am

.PHONY: distclean-am
distclean-am:
	@rm -rf $(PREREQ)
	@rm -rf $(DISTCLEAN)

PREREQ+= $(TMP_DIR)
$(TMP_DIR):
	@$(MKDIR_P) $(@D)
	@$(TOUCH) $@

SANITY+= /usr/local/bin/pip
/usr/local/bin/pip:
	$(warning sudo easy_install pip)
	$(error rerun make once completing the above action)

SANITY+= /usr/local/bin/virtualenv
/usr/local/bin/virtualenv:
	$(warning sudo pip install virtualenv)
	$(error rerun make once completing the above action)

SANITY+= $(HOME)/.ssh/id_rsa.pub
$(HOME)/.ssh/id_rsa.pub:
	ssh-keygen
	ssh-add -K $@

.PHONY: maintainer-clean
maintainer-clean: distclean
	@rm -rf $(MAINTAINERCLEAN)
	@rm -rf $(PIP_DIR)

.PHONY: check
check: all $(CHECK)

PREREQ+= roles/$(dirstamp)
roles/$(dirstamp):
	@$(MKDIR_P) $(@D)
	@$(TOUCH) $@

PREREQ+= /usr/local/bin/brew
/usr/local/bin/brew:
	@$(srcdir)/playbooks/install_homebrew.yaml

.PHONY: install
install: all
	@$(srcdir)/playbooks/install_homebrew.yaml*
	@$(srcdir)/playbooks/homebrew_basics.yaml*

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

all: | $(SANITY) $(PREREQ) $(ANSIBLE_PLAYBOOK) $(BUILD)

.DEFAULT_GOAL:= all

.NOTPARALLEL:
