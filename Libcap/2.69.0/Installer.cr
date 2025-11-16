class Target < ISM::Software

    def prepare
        super

        fileDeleteLine("#{buildDirectoryPath}/libcap/Makefile",190)
        fileDeleteLine("#{buildDirectoryPath}/libcap/Makefile",200)
    end

    def build
        super

        makeSource( arguments:  "prefix=/usr lib=lib",
                    path:       buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "prefix=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}usr lib=lib install",
                    path:       buildDirectoryPath)
    end

end
