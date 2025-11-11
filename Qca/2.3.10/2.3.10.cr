class Target < ISM::Software

    def prepare
        @buildDirectory = true
        @buildDirectoryNames["MainBuild5"] = "mainBuild5"
        super
    end
    
    def configure
        super

        if option("Qt5")
            runCmakeCommand(arguments:  "-DCMAKE_INSTALL_PREFIX=/usr               \
                                        -DCMAKE_BUILD_TYPE=Release                 \
                                        -DQT6=OFF                                  \
                                        -DQCA_MAN_INSTALL_DIR=/usr/share/man       \
                                        ..",
                            path:       buildDirectoryPath("MainBuild5"))
        end

        runCmakeCommand(arguments:  "-DCMAKE_INSTALL_PREFIX=/usr               \
                                    -DCMAKE_BUILD_TYPE=Release                 \
                                    -DQT6=ON                                   \
                                    -DQCA_MAN_INSTALL_DIR=/usr/share/man       \
                                    ..",
                        path:       buildDirectoryPath)
    end
    
    def build
        super

        if option("Qt5")
            makeSource(path: buildDirectoryPath("MainBuild5"))
        end

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        if option("Qt5")
            makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath("MainBuild5"))
        end

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
