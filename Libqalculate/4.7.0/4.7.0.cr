class Target < ISM::Software
    
    def configure
        super

        configureSource(arguments:  "--prefix=/usr      \
                                    --disable-static    \
                                    --docdir=/usr/share/doc/libqalculate-4.7.0",
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
