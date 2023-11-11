class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--enable-cxx",
                            "--disable-static",
                            "--docdir=/usr/share/doc/gmp-6.3.0"],
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
