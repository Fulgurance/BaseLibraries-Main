class Target < ISM::Software

    def prepare
        super

        runAutoconfCommand(path: buildDirectoryPath)
    end

    def configure
        super

        if option("Server")
            configureSource([   "--prefix=/usr",
                                "--sysconfdir=/etc",
                                "--localstatedir=/var",
                                "--libexecdir=/usr/lib",
                                "--disable-static",
                                "--enable-versioning=yes",
                                "--disable-debug",
                                "--with-tls=openssl",
                                "--with-cyrus-sasl",
                                "--without-systemd",
                                "--enable-dynamic",
                                "--enable-crypt",
                                "--enable-spasswd",
                                "--enable-slapd",
                                "--enable-modules",
                                "--enable-rlookups",
                                "--enable-backends=mod",
                                "--disable-sql",
                                "--disable-wt",
                                "--enable-overlays=mod"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr",
                                "--sysconfdir=/etc",
                                "--disable-static",
                                "--enable-dynamic",
                                "--enable-versioning=yes",
                                "--disable-debug",
                                "--disable-slapd"],
                                buildDirectoryPath)
        end
    end
    
    def build
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","depend"], path: buildDirectoryPath)
        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}"],path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        if option("Server")
            makeDirectory("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/var/lib/openldap")
            makeDirectory("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/etc/openldap/slapd.d")

            fileReplaceText("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/etc/openldap/slapd.conf",".la",".so")
            fileReplaceText("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/etc/openldap/slapd.ldif",".la",".so")
            fileReplaceText("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/etc/openldap/slapd.conf.default}",".la",".so")
            fileReplaceText("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/etc/openldap/slapd.ldif.default}",".la",".so")
        end
    end

    def install
        super

        if option("Server")
            runChmodCommand(["0700","/var/lib/openldap"])
            runChmodCommand(["0700","/etc/openldap/slapd.d"])
            runChmodCommand(["0640","/etc/openldap/slapd.conf"])
            runChmodCommand(["0640","/etc/openldap/slapd.ldif"])

            runChownCommand(["ldap:ldap","/var/lib/openldap"])
            runChownCommand(["ldap:ldap","/etc/openldap/slapd.d"])
            runChownCommand(["root:ldap","/etc/openldap/slapd.conf"])
            runChownCommand(["root:ldap","/etc/openldap/slapd.ldif"])
        end
    end

end
