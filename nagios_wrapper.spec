Summary:       Custom Nagios configuration files
Name:          nagios_wrapper
Version:       0.1
Release:       1%{?dist}
License:       GPLv2+
Group:         System/Monitoring
BuildArch:     noarch
Requires:      nagios 
Requires:      nrpe
Requires:      nagios-www
Requires:      nagios-theme-switcher
Requires:      monitoring-plugins-nagios
Requires:      monitoring-plugins-nrpe
Requires:      speedtest-cli

%description
Custom configuration files for Nagios on Raspberry Pi
runnning OpenSUSE

%prep

%build
tar xvzf %{_sourcedir}/%{name}-%{version}.tar.gz -C %{_builddir}

%install
install -m 755 -d %{buildroot}/%{_sysconfdir}/nagios/objects
install -m 755 -d %{buildroot}/%{_prefix}/lib/nagios/plugins

install -m 644 %{name}-%{version}/etc/nagios.cfg %{buildroot}/%{_sysconfdir}
install -m 644 %{name}-%{version}/etc/nrpe.cfg %{buildroot}/%{_sysconfdir}
install -m 600 %{name}-%{version}/etc/htpasswd.users %{buildroot}/%{_sysconfdir}/nagios
install -m 644 %{name}-%{version}/etc/objects/check_nrpe.cfg %{buildroot}/%{_sysconfdir}/nagios/objects
install -m 644 %{name}-%{version}/etc/objects/RaspberryPi.cfg %{buildroot}/%{_sysconfdir}/nagios/objects
install -m 644 %{name}-%{version}/etc/objects/RaspberryPi2.cfg %{buildroot}/%{_sysconfdir}/nagios/objects
install -m 644 %{name}-%{version}/etc/objects/switch.cfg %{buildroot}/%{_sysconfdir}/nagios/objects
install -m 644 %{name}-%{version}/etc/objects/templates.cfg %{buildroot}/%{_sysconfdir}/nagios/objects
install -m 644 %{name}-%{version}/etc/objects/commands.cfg %{buildroot}/%{_sysconfdir}/nagios/objects
install -m 644 %{name}-%{version}/etc/objects/printer.cfg %{buildroot}/%{_sysconfdir}/nagios/objects
install -m 644 %{name}-%{version}/etc/objects/openevse.cfg %{buildroot}/%{_sysconfdir}/nagios/objects
install -m 644 %{name}-%{version}/etc/objects/nas.cfg %{buildroot}/%{_sysconfdir}/nagios/objects
install -m 755 %{name}-%{version}/libexec/check_snmp_printer %{buildroot}/%{_prefix}/lib/nagios/plugins
install -m 755 %{name}-%{version}/libexec/check_weather.sh %{buildroot}/%{_prefix}/lib/nagios/plugins
install -m 755 %{name}-%{version}/libexec/check_smtp %{buildroot}/%{_prefix}/lib/nagios/plugins
install -m 755 %{name}-%{version}/libexec/check_internet.sh %{buildroot}/%{_prefix}/lib/nagios/plugins
install -m 755 %{name}-%{version}/libexec/check_calibre_server.sh %{buildroot}/%{_prefix}/lib/nagios/plugins
install -m 755 %{name}-%{version}/libexec/check_snmp_synology %{buildroot}/%{_prefix}/lib/nagios/plugins
install -m 755 %{name}-%{version}/libexec/check_internet_ping.sh %{buildroot}/%{_prefix}/lib/nagios/plugins
install -m 755 %{name}-%{version}/libexec/check_zypper %{buildroot}/%{_prefix}/lib/nagios/plugins

%post
/%{_prefix}/bin/systemctl enable nrpe
/%{_prefix}/bin/systemctl start nrpe
/%{_prefix}/bin/systemctl enable nagios
/%{_prefix}/bin/systemctl start nagios
/%{_prefix}/bin/systemctl enable apache2
/%{_prefix}/bin/systemctl start apache2

%clean
rm -rf %{buildroot}

%files
%{_sysconfdir}/nagios.cfg
%{_sysconfdir}/nrpe.cfg
%{_sysconfdir}/nagios/htpasswd.users
%{_sysconfdir}/nagios/objects/check_nrpe.cfg
%{_sysconfdir}/nagios/objects/RaspberryPi.cfg
%{_sysconfdir}/nagios/objects/RaspberryPi2.cfg
%{_sysconfdir}/nagios/objects/switch.cfg
%{_sysconfdir}/nagios/objects/commands.cfg
%{_sysconfdir}/nagios/objects/printer.cfg
%{_sysconfdir}/nagios/objects/openevse.cfg
%{_sysconfdir}/nagios/objects/nas.cfg
%{_sysconfdir}/nagios/objects/templates.cfg
/%{_prefix}/lib/nagios/plugins/check_snmp_printer
/%{_prefix}/lib/nagios/plugins/check_weather.sh
/%{_prefix}/lib/nagios/plugins/check_smtp
/%{_prefix}/lib/nagios/plugins/check_internet.sh
/%{_prefix}/lib/nagios/plugins/check_calibre_server.sh
/%{_prefix}/lib/nagios/plugins/check_snmp_synology
/%{_prefix}/lib/nagios/plugins/check_internet_ping.sh
/%{_prefix}/lib/nagios/plugins/check_zypper

%changelog
* Sun Nov 13 2022 James DelNigro
- first release
