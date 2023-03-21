class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--disable-static",
                            "--enable-thread-safe",
                            "--docdir=/usr/share/doc/mpfr-4.1.0"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
        makeSource(["html"],buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)
        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install-html"],buildDirectoryPath)
    end

end
