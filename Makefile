SPECFILE := nagios_wrapper.spec

ROOTDIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

.PHONY: help rpm setup clean

RPM_NV := $(shell rpm -q --specfile ${SPECFILE} --qf '%{name}-%{version}\n'|sort|uniq|head -1)
RPM_SOURCE_DIR := $(shell rpm --eval %{_sourcedir})

help:
	@echo
	@echo " Run 'make <target>' with one of the following targets:"
	@echo
	@echo "    rpm       creates the rpm"
	@echo "    setup     creates the rpm folder structure"
	@echo "    clean     removes the sources and build files"
	@echo

rpm:
	$(eval $@_TMPDIR := $(shell mktemp -d))
	mkdir $($@_TMPDIR)/${RPM_NV}
	cp -a * $($@_TMPDIR)/${RPM_NV}
	tar cvfz ${RPM_SOURCE_DIR}/${RPM_NV}.tar.gz -C $($@_TMPDIR) ${RPM_NV}
	#rpmbuild -ba --define "_sourcedir $($@_TMPDIR)/${RPM_NV}" ${SPECFILE}
	rpmbuild -ba --define "_topdir ${ROOTDIR}/rpmbuild" $(rpm_defines) ${SPECFILE}
	# rpmbuild -ba $(rpm_defines) ${SPECFILE}

setup:
	mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}

clean:
	rpmbuild --clean --rmsource ${SPECFILE}
