class Target < ISM::Software
    
    def configure
        super

        configureSource(arguments:  "--prefix=/usr                  \
                                    --disable-static                \
                                    --with-python=/usr/bin/python3  \
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
