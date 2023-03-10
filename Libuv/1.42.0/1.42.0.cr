class Target < ISM::Software
    
    def configure
        super
        runScript("autogen.sh",[""],buildDirectoryPath)
        configureSource([   "--prefix=/usr",
                            "--disable-static"],
                            buildDirectoryPath)
    end

    def build
        super
        makeSource([Ism.settings.makeOptions],buildDirectoryPath)
    end
    
    def prepareInstallation
        super
        makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
