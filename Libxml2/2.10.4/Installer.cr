class Target < ISM::Software
    
    def configure
        super

        configureSource(arguments:  "--prefix=/usr                                      \
                                    --sysconfdir=/etc                                   \
                                    --disable-static                                    \
                                    --with-history                                      \
                                    --with-python=/usr/bin/python3                      \
                                    #{option("Icu") ? "--with-icu" : "--without-icu"}   \
                                    --docdir=/usr/share/doc/#{versionName}",
                        path:       buildDirectoryPath)
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
