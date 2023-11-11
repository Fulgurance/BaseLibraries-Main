class Target < ISM::Software
    
    def configure
        super

        runScript("autogen.sh", path: buildDirectoryPath)
        configureSource([   "--prefix=/usr",
                            "--disable-static"],
                            buildDirectoryPath)
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
