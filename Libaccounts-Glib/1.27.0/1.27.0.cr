class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runMesonCommand(arguments:  "setup --reconfigure    \
                                    --prefix=/usr           \
                                    --buildtype=release     \
                                    ..",
                        path:       buildDirectoryPath,
                        environment:    {   "PATH" => "/usr/bin/python3.12:/usr/lib/llvm/#{softwareMajorVersion("@ProgrammingLanguages-Main:Llvm")}/bin:$PATH",
                                                "PYTHONPATH" => "/usr/lib/python3.12/site-packages"})
    end

    def build
        super

        runNinjaCommand(path: buildDirectoryPath,
                        environment:    {   "PATH" => "/usr/bin/python3.12:/usr/lib/llvm/#{softwareMajorVersion("@ProgrammingLanguages-Main:Llvm")}/bin:$PATH",
                                                "PYTHONPATH" => "/usr/lib/python3.12/site-packages"})
    end

    def prepareInstallation
        super

        runNinjaCommand(arguments:      "install",
                        path:           buildDirectoryPath,
                        environment:    {   "DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}",
                                            "PATH" => "/usr/bin/python3.12:/usr/lib/llvm/#{softwareMajorVersion("@ProgrammingLanguages-Main:Llvm")}/bin:$PATH",
                                                "PYTHONPATH" => "/usr/lib/python3.12/site-packages"})
    end

end
