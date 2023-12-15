class Target < ISM::Software

    def prepare
        @buildDirectory = true
        @buildDirectoryNames["MainBuild"] = "source"
        super
    end
    
    def configure
        super

        configureSource([   "--prefix=/usr"],
                            buildDirectoryPath,
                            @buildDirectoryNames["MainBuild"])
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
