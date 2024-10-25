class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runCmakeCommand(arguments:      "-DCMAKE_INSTALL_PREFIX=/usr                    \
                                        -DCMAKE_BUILD_TYPE=Release                      \
                                        -DBUILD_SHARED_LIBS=ON                          \
                                        -DCMAKE_SKIP_INSTALL_RPATH=ON                   \
                                        -DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=/usr   \
                                        -G Ninja ..",
                        path:           buildDirectoryPath,
                        environment:    { "LLVM_DIR" => "/usr/lib/llvm/#{dependencyMajorVersion("@ProgrammingLanguages-Main:Llvm")}" })
    end

    def build
        super

        runNinjaCommand(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        runNinjaCommand(arguments:      "install",
                        path:           buildDirectoryPath,
                        environment:    {"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})
    end

end
