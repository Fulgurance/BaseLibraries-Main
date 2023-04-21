class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super

        runMesonCommand([   "reconfigure",
                            "..",
                            softwareIsInstalled("Shared-Mime-Info") ? "-Dupdate-mimedb=true" : "-Dupdate-mimedb=false"],
                            buildDirectoryPath)
    end

    def configure
        super

        runMesonCommand([   "--prefix=/usr",
                            "--buildtype=release",
                            softwareIsInstalled("Shared-Mime-Info") ? "-Dupdate-mimedb=true" : "-Dupdate-mimedb=false",
                            ".."],buildDirectoryPath)
    end

    def build
        super

        runNinjaCommand(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        runNinjaCommand(["install"],buildDirectoryPath,
                                    {"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})
    end

end
