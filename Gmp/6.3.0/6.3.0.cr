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
                            "--enable-cxx",
                            "--disable-static",
                            "--docdir=/usr/share/doc/gmp-6.3.0"],
                            buildDirectoryPath(entry: "mainBuild"))

        if option("32Bits") || option("x32Bits")
            copyFile("#{buildDirectoryPath(entry: "mainBuild")}/configfsf.guess","config.guess")
            copyFile("#{buildDirectoryPath(entry: "mainBuild")}/configfsf.sub","config.sub")
        end

        if option("32Bits")

            configureSource([   "--host=i686-#{Ism.settings.targetName}-linux-gnu",
                                "--prefix=/usr",
                                "--libdir=/usr/lib32",
                                "--disable-static",
                                "--enable-cxx",
                                "--includedir=/usr/include/m32/gmp"],
                                path: buildDirectoryPath(entry: "32Bits"),
                                environment: {  "ABI" => "32",
                                                "CFLAGS" => "-m32 -O2 -pedantic -fomit-frame-pointer -mtune=generic -march=i686",
                                                "CXXFLAGS" => "-m32 -O2 -pedantic -fomit-frame-pointer -mtune=generic -march=i686",
                                                "PKG_CONFIG_PATH" => "/usr/lib32/pkgconfig"})
        end

        if option("x32Bits")

            configureSource([   "--host=#{Ism.settings.target}x32",
                                "--prefix=/usr",
                                "--libdir=/usr/libx32",
                                "--disable-static",
                                "--enable-cxx",
                                "--includedir=/usr/include/mx32/gmp"],
                                path: buildDirectoryPath(entry: "32Bits"),
                                environment: {  "ABI" => "x32",
                                                "CFLAGS" => "-mx32 -O2 -pedantic -fomit-frame-pointer -mtune=generic -march=x86-64",
                                                "CXXFLAGS" => "-mx32 -O2 -pedantic -fomit-frame-pointer -mtune=generic -march=x86-64",
                                                "PKG_CONFIG_PATH" => "/usr/libx32/pkgconfig"})
        end
    end

    def build
        super

        makeSource(path: buildDirectoryPath(entry: "mainBuild"))

        if option("32Bits") || option("x32Bits")
            fileReplaceTextAtLineNumber("#{mainWorkDirectoryPath(false)}/build/make/Makefile","includeexecdir = $(exec_prefix)/include","includeexecdir = $(includedir)",617)
        end

        if option("32Bits")
            makeSource(path: buildDirectoryPath(entry: "32Bits"))
        end

        if option("x32Bits")
            makeSource(path: buildDirectoryPath(entry: "x32Bits"))
        end
    end

    def prepareInstallation
        super

        makeSource( ["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}",
                    "install"],
                    path: buildDirectoryPath(entry: "mainBuild"))

        if option("32Bits")
            makeDirectory("#{buildDirectoryPath(false, entry: "32Bits")}/32Bits")
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr")

            makeSource( ["DESTDIR=#{buildDirectoryPath(entry: "32Bits")}/32Bits",
                        "install"],
                        path: buildDirectoryPath(entry: "32Bits"))

            copyDirectory(  "#{buildDirectoryPath(false, entry: "32Bits")}/32Bits/usr/lib32",
                            "#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib32")
        end

        if option("x32Bits")
            makeDirectory("#{buildDirectoryPath(false, entry: "x32Bits")}/x32Bits")
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr")

            makeSource( ["DESTDIR=#{buildDirectoryPath(entry: "x32Bits")}/x32Bits",
                        "install"],
                        path: buildDirectoryPath(entry: "x32Bits"))

            copyDirectory(  "#{buildDirectoryPath(false, entry: "x32Bits")}/x32Bits/usr/libx32",
                            "#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/libx32")
        end
    end

end
