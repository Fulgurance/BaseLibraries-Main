class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        deleteFile("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/lib/libz.a")
    end

end
