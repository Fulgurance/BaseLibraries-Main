class Target < ISM::Software

    def prepare
        super

        runAutoconfCommand
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
            makeDirectory("#{builtSoftwareDirectoryPath(false)}/#{Ism.settings.rootPath}/var/lib/openldap")
            makeDirectory("#{builtSoftwareDirectoryPath(false)}/#{Ism.settings.rootPath}/etc/openldap/slapd.d")

            fileReplaceText("#{builtSoftwareDirectoryPath(false)}/#{Ism.settings.rootPath}/etc/openldap/slapd.conf",".la",".so")
            fileReplaceText("#{builtSoftwareDirectoryPath(false)}/#{Ism.settings.rootPath}/etc/openldap/slapd.ldif",".la",".so")
            fileReplaceText("#{builtSoftwareDirectoryPath(false)}/#{Ism.settings.rootPath}/etc/openldap/slapd.conf.default}",".la",".so")
            fileReplaceText("#{builtSoftwareDirectoryPath(false)}/#{Ism.settings.rootPath}/etc/openldap/slapd.ldif.default}",".la",".so")
        end
    end

    def install
        super

        if option("Server")
            runGroupAddCommand(["-g","83","ldap"])
            runUserAddCommand(["-c","\"OpenLDAP Daemon Owner\"","-d","/var/lib/openldap","-u","83","-g","ldap","-s","/bin/false","ldap"])

            setPermissions("#{Ism.settings.rootPath}/var/lib/openldap",0o700)
            setPermissions("#{Ism.settings.rootPath}/etc/openldap/slapd.d",0o700)
            setPermissions("#{Ism.settings.rootPath}/etc/openldap/slapd.conf",0o640)
            setPermissions("#{Ism.settings.rootPath}/etc/openldap/slapd.ldif",0o640)

            setOwner("#{Ism.settings.rootPath}/var/lib/openldap","ldap:ldap")
            setOwner("#{Ism.settings.rootPath}/etc/openldap/slapd.d","ldap:ldap")
            setOwner("#{Ism.settings.rootPath}/etc/openldap/slapd.conf","root:ldap")
            setOwner("#{Ism.settings.rootPath}/etc/openldap/slapd.ldif","root:ldap")
        end
    end

end
