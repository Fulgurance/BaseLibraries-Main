class Target < ISM::Software
    
    def prepare
        @buildDirectory = true
        super
    end
    
    def configure
        super

        runCmakeCommand(arguments:      "-DCMAKE_INSTALL_PREFIX=/usr        \
                                        -DCMAKE_BUILD_TYPE=Release          \
                                        -D CMAKE_SKIP_INSTALL_RPATH=ON      \
                                        -D protobuf_BUILD_TESTS=OFF         \
                                        -D protobuf_ABSL_PROVIDER=package   \
                                        -D protobuf_BUILD_LIBUPB=OFF        \
                                        -D protobuf_BUILD_SHARED_LIBS=ON    \
                                        -D utf8_range_ENABLE_INSTALL=OFF    \
                                        -B #{buildDirectoryPath}            \
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
