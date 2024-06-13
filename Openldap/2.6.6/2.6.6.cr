class Target < ISM::Software

    def prepare
        super

        runAutoconfCommand(path: buildDirectoryPath)
    end

    def configure
        super

        if option("Server")
            configureSource(arguments:  "--prefix=/usr              \
                                        --sysconfdir=/etc           \
                                        --localstatedir=/var        \
                                        --libexecdir=/usr/lib       \
                                        --disable-static            \
                                        --enable-versioning=yes     \
                                        --disable-debug             \
                                        --with-tls=openssl          \
                                        --with-cyrus-sasl           \
                                        --without-systemd           \
                                        --enable-dynamic            \
                                        --enable-crypt              \
                                        --enable-spasswd            \
                                        --enable-slapd              \
                                        --enable-modules            \
                                        --enable-rlookups           \
                                        --enable-backends=mod       \
                                        --disable-sql               \
                                        --disable-wt                \
                                        --enable-overlays=mod",
                            path:       buildDirectoryPath)
        else
            configureSource(arguments:  "--prefix=/usr              \
                                        --sysconfdir=/etc           \
                                        --disable-static            \
                                        --enable-dynamic            \
                                        --enable-versioning=yes     \
                                        --disable-debug             \
                                        --disable-slapd",
                            path:       buildDirectoryPath)
        end
    end
    
    def build
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} depend",
                    path:       buildDirectoryPath)

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}",
                    path:       buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        if option("Server")
            makeDirectory("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/var/lib/openldap")
            makeDirectory("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/etc/openldap/slapd.d")

            fileReplaceText(path:       "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/etc/openldap/slapd.conf",
                            text:       ".la",
                            newText:    ".so")

            fileReplaceText(path:       "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/etc/openldap/slapd.ldif",
                            text:       ".la",
                            newText:    ".so")

            fileReplaceText(path:       "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/etc/openldap/slapd.conf.default}",
                            text:       ".la",
                            newText:    ".so")

            fileReplaceText(path:       "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/etc/openldap/slapd.ldif.default}",
                            text:       ".la",
                            newText:    ".so")
        end
    end

    def install
        super

        if option("Server")
            runChmodCommand("0700 /var/lib/openldap")
            runChmodCommand("0700 /etc/openldap/slapd.d")
            runChmodCommand("0640 /etc/openldap/slapd.conf")
            runChmodCommand("0640 /etc/openldap/slapd.ldif")

            runChownCommand("ldap:ldap /var/lib/openldap")
            runChownCommand("ldap:ldap /etc/openldap/slapd.d")
            runChownCommand("root:ldap /etc/openldap/slapd.conf")
            runChownCommand("root:ldap /etc/openldap/slapd.ldif")
        end
    end

end
