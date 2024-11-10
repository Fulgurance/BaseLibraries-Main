class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end
    
    def configure
        super

        runCmakeCommand(arguments:  "-DCMAKE_INSTALL_PREFIX=/usr                \
                                    -D CMAKE_BUILD_TYPE=Release                 \
                                    -D QT6=ON                                   \
                                    -D QCA_INSTALL_IN_QT_PREFIX=ON              \
                                    -D QCA_MAN_INSTALL_DIR:PATH=/usr/share/man  \
                                    ..",
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
