class Target < ISM::Software

    def prepare
        if option("32Bits") || option("x32Bits") || option("Minizip")
            @buildDirectory = true
        end

        if option("32Bits")
            @buildDirectoryNames["32Bits"] = "mainBuild-32"
        end

        if option("x32Bits")
            @buildDirectoryNames["x32Bits"] = "mainBuild-x32"
        end

        if option("Minizip")
            @buildDirectoryNames["Minizip"] = "contrib/minizip/"
        end

        super
    end

    def configure
        super

        configureSource(arguments:  "--prefix=/usr",
                        path:       buildDirectoryPath(entry: "MainBuild"))

        if option("32Bits")
            configureSource(arguments:      "--prefix=/usr  \
                                            --libdir=/usr/lib32",
                            path:           buildDirectoryPath(entry: "32Bits"),
                            environment:    {   "CFLAGS" => "$(CFLAGS) -m32",
                                                "CXXFLAGS" => "$(CXXFLAGS) -m32"})
        end

        if option("x32Bits")
            configureSource(arguments:      "--prefix=/usr  \
                                            --libdir=/usr/libx32",
                            path:           buildDirectoryPath(entry: "x32Bits"),
                            environment:    {   "CFLAGS" => "$(CFLAGS) -mx32",
                                                "CXXFLAGS" => "$(CXXFLAGS) -mx32"})
        end
    end

    def build
        super

        makeSource(path: buildDirectoryPath(entry: "MainBuild"))

        if option("32Bits")
            makeSource(path: buildDirectoryPath(entry: "32Bits"))
        end

        if option("x32Bits")
            makeSource(path: buildDirectoryPath(entry: "x32Bits"))
        end

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
                    path:       buildDirectoryPath(entry: "MainBuild"))

        deleteFile("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/lib/libz.a")

        if option("32Bits")
            makeDirectory("#{buildDirectoryPath(entry: "32Bits")}/32Bits")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr")

            makeSource( arguments:  "DESTDIR=#{buildDirectoryPath(entry: "32Bits")}/32Bits install",
                        path:       buildDirectoryPath(entry: "32Bits"))

            copyDirectory(  "#{buildDirectoryPath(entry: "32Bits")}/32Bits/usr/lib32",
                            "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib32")
        end

        if option("x32Bits")
            makeDirectory("#{buildDirectoryPath(entry: "x32Bits")}/x32Bits")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr")

            makeSource(arguments:   "DESTDIR=#{buildDirectoryPath(entry: "x32Bits")}/x32Bits install",
                        path: buildDirectoryPath(entry: "x32Bits"))

            copyDirectory(  "#{buildDirectoryPath(entry: "x32Bits")}/x32Bits/usr/libx32",
                            "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/libx32")
        end

        if option("Minizip")
            makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                        path:       buildDirectoryPath(entry: "Minizip"))
        end
    end

end
