class Target < ISM::Software
    
    def configure
        super

        configureSource(arguments:  "--prefix=/usr  \
                                    --with-mozilla  \
                                    --with-pthreads \
                                    --enable-64bit",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
