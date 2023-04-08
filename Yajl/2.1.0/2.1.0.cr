class Target < ISM::Software

    def configure
        super

        configureSource([   "-p",
                            "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr"],
                            buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["install"],buildDirectoryPath)
    end

end
