class Target < ISM::Software
    
    def prepare
        @buildDirectory = true
        super
    end
    
    def configure
        super

        runCmakeCommand(arguments:      "-DCMAKE_INSTALL_PREFIX=/usr        \
                                        -DCMAKE_BUILD_TYPE=Release          \
                                        -DCMAKE_SKIP_INSTALL_RPATH=ON       \
                                        -Dprotobuf_BUILD_TESTS=OFF          \
                                        -Dprotobuf_ABSL_PROVIDER=package    \
                                        -Dprotobuf_BUILD_LIBUPB=OFF         \
                                        -Dprotobuf_INSTALL=ON               \
                                        -Dprotobuf_BUILD_SHARED_LIBS=ON     \
                                        -Dutf8_range_ENABLE_INSTALL=ON      \
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
