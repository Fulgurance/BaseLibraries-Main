class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--disable-debuginfod",
                            "--enable-libdebuginfod=dummy"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["-C","libelf","DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)
        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/lib/pkgconfig")
        copyFile("#{buildDirectoryPath(false)}config/libelf.pc","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/lib/pkgconfig/libelf.pc")
        deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/lib/libelf.a")
    end

    def install
        super

        setPermissions("#{Ism.settings.rootPath}usr/lib/pkgconfig/libelf.pc",0o644)
    end

end
