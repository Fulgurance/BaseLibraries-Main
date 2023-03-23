class Target < ISM::Software

    def extract
        super

        moveFile("#{workDirectoryPath(false)}/icu","#{workDirectoryPath(false)}/icu4c-69_1-src")
    end

    def prepare
        @buildDirectory = true
        @buildDirectoryName = "source"
        super
    end
    
    def configure
        super

        configureSource([   "--prefix=/usr"],
                            buildDirectoryPath,
                            @buildDirectoryName)
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
