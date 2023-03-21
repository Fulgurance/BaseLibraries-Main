class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--disable-static",
                            "--docdir=/usr/share/doc/mpc-1.2.1"],
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
