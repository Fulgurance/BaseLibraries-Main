class Target < ISM::Software

    def prepare
        super

        fileDeleteLine("#{buildDirectoryPath(false)}/libcap/Makefile",190)
        fileDeleteLine("#{buildDirectoryPath(false)}/libcap/Makefile",200)
    end

    def build
        super

        makeSource(["prefix=/usr","lib=lib"],buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["prefix=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}usr","lib=lib","install"],buildDirectoryPath)
    end

end
