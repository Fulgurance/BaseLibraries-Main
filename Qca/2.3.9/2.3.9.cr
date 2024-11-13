class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end
    
    def configure
        super

        runCmakeCommand(arguments:  "-DCMAKE_INSTALL_PREFIX=/usr               \
                                    -DCMAKE_BUILD_TYPE=Release                 \
                                    -DQT6=ON                                   \
                                    -DQCA_INSTALL_IN_QT_PREFIX=ON              \
                                    -DQCA_MAN_INSTALL_DIR=/usr/share/man       \
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
