class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
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

    def install
        super

        if softwareIsInstalled("Shared-Mime-Info")
            runUpdateMimeDatabaseCommand
        end
    end

end
