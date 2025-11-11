class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runCmakeCommand(arguments:  "-DCMAKE_INSTALL_PREFIX=/usr                                                        \
                                    -DCMAKE_BUILD_TYPE=Release                                                          \
                                    -DLLVM_SPIRV=/usr                                                                   \
                                    -DLIBCLC_TARGETS_TO_BUILD=\"nvptx--,nvptx64--,nvptx--nvidiacl,nvptx64--nvidiacl,spirv-mesa3d-,spirv64-mesa3d-\"   \
                                    -G Ninja ..",
                        path:       buildDirectoryPath,
                        environment:    { "LLVM_DIR" => "/usr/lib/llvm/#{softwareMajorVersion("@ProgrammingLanguages-Main:Llvm")}" })
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
