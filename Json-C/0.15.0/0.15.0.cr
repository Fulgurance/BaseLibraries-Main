class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super
        runCmakeCommand([   "-DCMAKE_INSTALL_PREFIX=/usr",
                            "-DCMAKE_BUILD_TYPE=Release",
                            "-DBUILD_STATIC_LIBS=OFF"],
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
