class Target < ISM::Software
    
    def configure
        super
        configureSource([   "--prefix=/usr",
                            "--enable-shared",
                            "--disable-static",
                            "--docdir=/usr/share/doc/libatomic_ops-7.6.14"],
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
