class Target < ISM::Software
    
    def configure
        super
        configureSource([   "--prefix=/usr",
                            "--docdir=/usr/share/doc/pcre-8.45",
                            "--enable-unicode-properties",
                            "--enable-pcre16",
                            "--enable-pcre32",
                            "--enable-pcregrep-libz",
                            "--enable-pcregrep-libbz2",
                            "--enable-pcretest-libreadline",
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
