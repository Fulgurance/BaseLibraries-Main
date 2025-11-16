class Target < ISM::Software

    def prepare
        if option("Minizip")
            @buildDirectory = true
            @buildDirectoryNames["Minizip"] = "contrib/minizip/"
        end

        super
    end

    def configure
        super

        configureSource(arguments:  "--prefix=/usr",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)


        if option("Minizip")
            runAutoreconfCommand(   arguments:  "-fiv",
                                    path:       buildDirectoryPath(entry: "Minizip"))

            configureSource(arguments:          "--prefix=/usr  \
                                                --enable-shared \
                                                --disable-static",
                            path:               buildDirectoryPath(entry: "Minizip"),
                            relatedToMainBuild: false)

            makeSource(path: buildDirectoryPath(entry: "Minizip"))
        end
    end

    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        deleteFile("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/lib/libz.a")

        if option("Minizip")
            makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                        path:       buildDirectoryPath(entry: "Minizip"))
        end
    end

end
