class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr          \
                                    --disable-debuginfod    \
                                    --enable-libdebuginfod=dummy",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "-C libelf DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/pkgconfig")

        copyFile(   "#{buildDirectoryPath}config/libelf.pc",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/pkgconfig/libelf.pc")

        deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libelf.a")
    end

    def deploy
        super

        runChownCommand("root:root /usr/lib/pkgconfig/libelf.pc")
        runChmodCommand("0644 /usr/lib/pkgconfig/libelf.pc")
    end

end
