class Target < ISM::Software

    def extract
        super

        moveFile(   "#{workDirectoryPath}/yajl-2.1.0",
                    "#{workDirectoryPath}/2.1.0")
    end

    def configure
        super

        configureSource(arguments:  "-p #{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr",
                        path:       buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "install",
                    path:       buildDirectoryPath)
    end

end
