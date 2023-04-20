class Target < ISM::Software

    def prepare
        super

       runAutoreconfCommand(["-fi"],buildDirectoryPath)
    end
    
    def configure
        super

        configureSource([   "--prefix=/usr"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
