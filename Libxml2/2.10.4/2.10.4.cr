class Target < ISM::Software
    
    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--sysconfdir=/etc",
                            "--disable-static",
                            "--with-history",
                            "--with-python=/usr/bin/python3",
                            "#{option("Icu") ? "--with-icu" : "--without-icu"}",
                            "--docdir=/usr/share/doc/libxml2-2.10.4"],
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
