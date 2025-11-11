class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runCmakeCommand(arguments:  "-DCMAKE_INSTALL_PREFIX=/usr        \
                                    -DCMAKE_BUILD_TYPE=Release          \
                                    -DBUILD_TESTING=OFF                 \
                                    -DQCORO_BUILD_EXAMPLES=OFF          \
                                    -DBUILD_SHARED_LIBS=ON              \
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
