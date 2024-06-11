class Target < ISM::Software

    def prepare
        if option("32Bits") || option("x32Bits")
            @buildDirectory = true
        end

        if option("32Bits")
            @buildDirectoryNames["32Bits"] = "mainBuild-32"
        end

        if option("x32Bits")
            @buildDirectoryNames["x32Bits"] = "mainBuild-x32"
        end
        super
    end

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--disable-debuginfod",
                            "--enable-libdebuginfod=dummy"],
                            path: buildDirectoryPath(entry: "MainBuild"))

        if option("32Bits")
            configureSource([   "--host=i686-#{Ism.settings.systemTargetName}-linux-gnu",
                                "--prefix=/usr",
                                "--libdir=/usr/lib32",
                                "--disable-debuginfod",
                                "--enable-libdebuginfod=dummy"],
                                path: buildDirectoryPath(entry: "32Bits"),
                                environment: {  "CC" =>"gcc -m32",
                                                "CXX" => "g++ -m32"})
        end

        if option("x32Bits")
            configureSource([   "--host=#{Ism.settings.systemTarget}x32",
                                "--prefix=/usr",
                                "--libdir=/usr/libx32",
                                "--disable-static",
                                "--with-gcc-arch=x86_64"],
                                path: buildDirectoryPath(entry: "x32Bits"),
                                environment: {  "CC" =>"gcc -mx32",
                                                "CXX" => "g++ -mx32"})
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
    end

    def prepareInstallation
        super

        makeSource( ["-C",
                    "libelf",
                    "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}",
                    "install"],
                    path: buildDirectoryPath(entry: "MainBuild"))

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/pkgconfig")

        copyFile(   "#{buildDirectoryPath}config/libelf.pc",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/pkgconfig/libelf.pc")

        if option("32Bits")
            makeSource( ["-C",
                    "libelf",
                    "DESTDIR=#{buildDirectoryPath(entry: "32Bits")}/32Bits",
                    "install"],
                    path: buildDirectoryPath(entry: "32Bits"))

            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib32/pkgconfig")

            copyFile(   "#{buildDirectoryPath(entry: "32Bits")}/config/libelf.pc",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib32/pkgconfig/libelf.pc")

            copyDirectory(  "#{buildDirectoryPath(entry: "32Bits")}/32Bits/usr/lib32",
                            "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib32")
        end

        if option("x32Bits")
            makeSource( ["-C",
                    "libelf",
                    "DESTDIR=#{buildDirectoryPath(entry: "x32Bits")}/x32Bits",
                    "install"],
                    path: buildDirectoryPath(entry: "x32Bits"))

            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/libx32/pkgconfig")

            copyFile(   "#{buildDirectoryPath(entry: "x32Bits")}/config/libelf.pc",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/libx32/pkgconfig/libelf.pc")

            copyDirectory(  "#{buildDirectoryPath(entry: "x32Bits")}/x32Bits/usr/libx32",
                            "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/libx32")
        end

        deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libelf.a")
    end

    def install
        super

        runChmodCommand(["0644","/usr/lib/pkgconfig/libelf.pc"])

        if option("32Bits")
            runChmodCommand(["0644","/usr/lib32/pkgconfig/libelf.pc"])
        end

        if option("x32Bits")
            runChmodCommand(["0644","/usr/libx32/pkgconfig/libelf.pc"])
        end
    end

end
