# vim:ft=make

ROLEBOOKS=
PLAYBOOKS=

ANSIBLE_PKJ_URL:= https://gist.githubusercontent.com/BrianAker/e58417dac282131d2e2a/raw/cc8ccb13d50cdcc6e1c4c12ae2eb0203bb494b3d/ansible-requirements
ANSIBLE_PKJ:= $(notdir $(ANSIBLE_PKJ_URL))

ANSIBLE:= $(PIP_BIN_DIR)/ansible
ANSIBLE_PLAYBOOK:= $(PIP_BIN_DIR)/ansible-playbook
ANSIBLE_CHECK:= $(ANSIBLE_PLAYBOOK) --syntax-check
ANSIBLE_GALAXY:= $(PIP_BIN_DIR)/ansible-galaxy

ANSIBLE_PIP_REQUIREMENTS:= $(TMP_FILES)/$(ANSIBLE_PKJ)

$(ANSIBLE_PIP_REQUIREMENTS): $(TMP_DIR)
	$(info $(ANSIBLE_PKJ))
	$(WGET_KEYS) $(ANSIBLE_PKJ_URL)

$(ANSIBLE_PLAYBOOK): $(ANSIBLE)

$(ANSIBLE_GALAXY): $(ANSIBLE)

$(ANSIBLE_CHECK): $(ANSIBLE)

PREREQ+= $(ANSIBLE)

$(ANSIBLE): $(PIP) $(ANSIBLE_PIP_REQUIREMENTS)
	$(if $(wildcard $(ANSIBLE)), $(call pip_install_r,$(ANSIBLE_PIP_REQUIREMENTS)), $(call pip_upgrade_r,$(ANSIBLE_PIP_REQUIREMENTS)))

MAINTAINERCLEAN+= .ansible

CHECK+= check-playbook
CHECK+= check-rolebooks

.PHONY: check-playbook
check-playbook: $(PLAYBOOKS)
	$(foreach playbook,$(PLAYBOOKS),$(ANSIBLE_CHECK) $(playbook);)

.PHONY: check-rolebooks
check-rolebooks: $(ROLEBOOKS)
	$(foreach rolebook,$(ROLEBOOKS),$(ANSIBLE_CHECK) $(rolebook);)
