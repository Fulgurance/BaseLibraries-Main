class Target < ISM::Software
    
    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--disable-static",
                            "--with-history",
                            "--with-python=/usr/bin/python3"],
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
