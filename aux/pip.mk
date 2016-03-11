# vim:ft=make

PIP_DIR:= $(HOME)/.python
PIP_BIN_DIR:= $(PIP_DIR)/bin
PIP:= $(PIP_BIN_DIR)/pip
ACTIVATE:= $(PIP_BIN_DIR)/activate

VIRTUALENV= virtualenv

$(PIP):
	$(VIRTUALENV) $(PIP_DIR)
	$(warning . $(ACTIVATE))
	$(error virtualenv installed, run the above command to add ansible to your path and rerun make)

define pip_install_r
$(shell . $(PIP_BIN_DIR)/activate && $(PIP_BIN_DIR)/pip install --quiet -r $1)
endef

define pip_upgrade_r
$(shell . $(PIP_BIN_DIR)/activate && $(PIP_BIN_DIR)/pip install --upgrade --quiet -r $1)
endef

.PHONY: upgrade-pip
upgrade-pip:
	$(PIP) freeze | awk -F'==' '{ print $1 }' | xargs $(PIP) install --upgrade

MAINTAINERCLEAN+= $(PIP_DIR)
