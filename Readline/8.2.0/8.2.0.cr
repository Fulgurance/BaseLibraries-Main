class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr      \
                                    --disable-static    \
                                    --with-curses       \
                                    --disable-doc",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource( arguments:  "SHLIB_LIBS=\"-lncursesw\"",
                    path:       buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "SHLIB_LIBS=\"-lncursesw\" DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
