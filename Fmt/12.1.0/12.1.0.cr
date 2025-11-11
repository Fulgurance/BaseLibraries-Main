class Target < ISM::Software
    
    def prepare
        @buildDirectory = true
        super
    end
    
    def configure
        super

        runCmakeCommand(arguments:      "-DCMAKE_INSTALL_PREFIX=/usr    \
                                        -DCMAKE_INSTALL_LIBDIR=/usr/lib \
                                        -DBUILD_SHARED_LIBS=ON          \
                                        -DFMT_TEST=OFF                  \
                                        -B #{buildDirectoryPath}        \
                                        -G Ninja",
                        path:           mainWorkDirectoryPath)
    end

    def build
        super

        runCmakeCommand(arguments:      "--build #{buildDirectoryPath}",
                        path:           mainWorkDirectoryPath)
    end

    def prepareInstallation
        super

        runCmakeCommand(arguments:      "--install #{buildDirectoryPath}",
                        path:           mainWorkDirectoryPath,
                        environment:    {"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})
    end

end
