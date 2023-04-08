class Target < ISM::Software

    def extract
        super

        moveFile("#{workDirectoryPath(false)}/yajl-2.1.0","#{workDirectoryPath(false)}/2.1.0")
    end

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
