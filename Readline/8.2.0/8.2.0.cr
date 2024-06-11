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

        fileReplaceText("#{buildDirectoryPath}/Makefile.in","-$(MV)","")
        fileReplaceLineContaining("#{buildDirectoryPath}/support/shlib-install","{OLDSUFF}",":")
    end

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--disable-static",
                            "--with-curses",
                            "--docdir=/usr/share/doc/readline-8.2"],
                            path: buildDirectoryPath(entry: "MainBuild"))

        if option("32Bits")
            configureSource([   "--host=i686-#{Ism.settings.systemTargetName}-linux-gnu",
                                "--prefix=/usr",
                                "--libdir=/usr/lib32",
                                "--disable-static",
                                "--with-curses"],
                                path: buildDirectoryPath(entry: "32Bits"),
                                environment: {"CC" =>"gcc -m32"})
        end

        if option("x32Bits")
            configureSource([   "--host=#{Ism.settings.systemTarget}x32",
                                "--prefix=/usr",
                                "--libdir=/usr/libx32",
                                "--disable-static",
                                "--with-curses"],
                                path: buildDirectoryPath(entry: "x32Bits"),
                                environment: {"CC" =>"gcc -mx32"})
        end
    end

    def build
        super

        makeSource( ["SHLIB_LIBS=\"-lncursesw\""],
                    path: buildDirectoryPath(entry: "MainBuild"))

        if option("32Bits")
            makeSource( ["SHLIB_LIBS=\"-lncursesw\""],
                        path: buildDirectoryPath(entry: "32Bits"))
        end

        if option("x32Bits")
            makeSource( ["SHLIB_LIBS=\"-lncursesw\""],
                        path: buildDirectoryPath(entry: "x32Bits"))
        end
    end

    def prepareInstallation
        super

        makeSource( ["SHLIB_LIBS=\"-lncursesw\"",
                    "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}",
                    "install"],
                    path: buildDirectoryPath(entry: "MainBuild"))

        if option("32Bits")
            makeDirectory("#{buildDirectoryPath(false, entry: "32Bits")}/32Bits")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr")

            makeSource( ["SHLIB_LIBS=\"-lncursesw\"",
                        "DESTDIR=#{buildDirectoryPath(entry: "32Bits")}/32Bits",
                        "install"],
                        path: buildDirectoryPath(entry: "32Bits"))

            copyDirectory(  "#{buildDirectoryPath(false, entry: "32Bits")}/32Bits/usr/lib32",
                            "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib32")
        end

        if option("x32Bits")
            makeDirectory("#{buildDirectoryPath(false, entry: "x32Bits")}/x32Bits")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr")

            makeSource( ["SHLIB_LIBS=\"-lncursesw\"",
                        "DESTDIR=#{buildDirectoryPath(entry: "x32Bits")}/x32Bits",
                        "install"],
                        path: buildDirectoryPath(entry: "x32Bits"))

            copyDirectory(  "#{buildDirectoryPath(false, entry: "x32Bits")}/x32Bits/usr/libx32",
                            "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/libx32")
        end
    end

end
