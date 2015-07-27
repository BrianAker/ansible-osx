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

ROLE_FILES=
ROLE_FILES+= $(ROLE_DEFAULTS)
ROLE_FILES+= $(ROLE_TASKS)
ROLE_FILES+= $(ROLE_HANDLERS)

ROLES_PATH+= roles/

HOSTNAME:= `hostname`
HOST_TYPE:= `hostname | cut -d'-' -f1`
HOST_UUID:= `hostname | cut -d'-' -f2`
ALL_SCRIPTS:= $(wildcard *.sh) 

include aux/common.mk
include aux/pip.mk
include aux/ansible.mk
include aux/git.mk

TASK_DIRS:= tasks defaults handlers meta
SUB_ROLES:= base validate_input_parameters

RAW_ROLES=
RAW_ROLES+= $(foreach dir,$(TASK_DIRS),$(subst /$(dir),,$(shell find roles -type d -name '$(dir)')))
RAW_ROLES+= $(foreach dir,$(SUB_ROLES),$(shell find roles -type d -name '$(dir)'))
ROLES:= $(sort $(RAW_ROLES))

ROLE_VARS:= $(addsuffix /vars/main.yml, $(ROLES))
ROLE_DEFAULTS:= $(addsuffix /defaults/main.yml, $(ROLES))
ROLE_TASKS:= $(addsuffix /tasks/main.yml, $(ROLES))
ROLE_HANDLERS:= $(addsuffix /handlers/main.yml, $(ROLES))
ROLE_META:= $(addsuffix /meta/main.yml, $(ROLES))

ANSIBLE_GALAXY_ROLES:= 
ANSIBLE_GALAXY_ROLES_INSTALL := $(addprefix $(ROLES_PATH), $(addsuffix /$(dirstamp),$(ANSIBLE_GALAXY_ROLES)))

MAINTAINERCLEAN+= $(ANSIBLE_GALAXY_ROLES)

ROLEBOOKS+= $(addsuffix /role.yml, $(ROLES))
PLAYBOOKS+= $(wildcard *.yml) 

JENKINS_SLAVES=

USER_EXISTS:= $(shell id $(CREATE_USER) > /dev/null 2>&1 ; echo $$?)

$(ROLE_VARS): support/vars.yml
	@if test -f $@; then \
	  $(TOUCH) $< $@; \
	  $(GIT_ADD) $@; \
	else \
	  $(MKDIR_P) $(@D); \
	  $(INSTALL) $< $@; \
	  $(GIT_ADD) $@; \
	fi

$(ROLE_META): support/meta.yml
	@if test -f $@; then \
	  $(TOUCH) $< $@; \
	  $(GIT_ADD) $@; \
	else \
	  $(MKDIR_P) $(@D); \
	  $(INSTALL) $< $@; \
	  $(GIT_ADD) $@; \
	fi

$(ROLE_FILES): support/main.yml
	@if test -f $@; then \
	  $(TOUCH) $< $@; \
	  $(GIT_ADD) $@; \
	else \
	  $(MKDIR_P) $(@D); \
	  $(INSTALL) $< $@; \
	  $(GIT_ADD) $@; \
	fi

$(ROLEBOOKS): support/role.yml $(ROLE_FILES) $(ROLE_META) $(ROLE_VARS)
	@cp $< $@
	@echo "  roles: [ '$(subst roles/,,$(@D))' ]" >> $@

BUILD+= $(ROLEBOOKS)

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
	@rm -rf $(dir $(ANSIBLE_GALAXY_ROLES_INSTALL))
	@rm -rf $(MAINTAINERCLEAN)
	@rm -rf $(PIP_DIR)

.PHONY: print_check
print_check:
	@echo "$(CHECK)"
	@echo "$(ROLEBOOKS)"

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

PREREQ+= files/pkg-pubkey.cert
files/pkg-pubkey.cert:
	@$(CURL) -o $@ http://trac.pcbsd.org/export/780f3da562b72643c04b47a59d277102a09abbca/src-sh/pc-extractoverlay/desktop-overlay/usr/local/etc/pkg-pubkey.cert

PREREQ+= $(ANSIBLE_GALAXY_ROLES_INSTALL)

$(ANSIBLE_GALAXY_ROLES_INSTALL): $(ANSIBLE_GALAXY)
	@$(RM) -rf $(subst /$(dirstamp),, $@)
	@$(ANSIBLE_GALAXY) install -p $(ROLES_PATH)  $(subst $(ROLES_PATH),, $(subst /$(dirstamp),, $@))
	@$(TOUCH) $@

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

all: $(ANSIBLE_PLAYBOOK) $(PREREQ) $(ROLE_FILES) $(ROLE_META) $(ROLE_VARS) $(BUILD)

.DEFAULT_GOAL:= all

.NOTPARALLEL:
