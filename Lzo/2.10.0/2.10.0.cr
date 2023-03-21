class Target < ISM::Software
    
    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--enable-shared",
                            "--disable-static",
                            "--docdir=/usr/share/doc/lzo-2.10"],
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
