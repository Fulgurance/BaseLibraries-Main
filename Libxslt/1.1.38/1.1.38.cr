class Target < ISM::Software
    
    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--disable-static",
                            "--with-python=/usr/bin/python3",
                            "--docdir=/usr/share/doc/libxslt-1.1.38"],
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
