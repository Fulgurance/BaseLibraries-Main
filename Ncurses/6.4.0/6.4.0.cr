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

        if option("Pass1")
            @buildDirectory = true
            super

            configureSource(path: buildDirectoryPath)
            makeSource(["-C","include"],buildDirectoryPath)
            makeSource(["-C","progs","tic"],buildDirectoryPath)
        else
            super
        end
    end

    def configure32Bits
        if option("Pass1")
            configureSource([   "--host=i686-#{Ism.settings.systemTargetName}-linux-gnu",
                                "--prefix=/usr",
                                "--build=$(./config.guess)",
                                "--libdir=/usr/lib32",
                                "--mandir=/usr/share/man",
                                "--with-shared",
                                "--without-normal",
                                "--with-cxx-shared",
                                "--without-debug",
                                "--without-ada",
                                "--disable-stripping",
                                "--enable-widec"],
                                path: buildDirectoryPath(entry: "32Bits"),
                                environment: {  "CC" =>"gcc -m32",
                                                "CXX" => "g++ -m32"})
        else
            configureSource([   "--host=i686-#{Ism.settings.systemTargetName}-linux-gnu",
                                "--prefix=/usr",
                                "--libdir=/usr/lib32",
                                "--mandir=/usr/share/man",
                                "--with-shared",
                                "--without-normal",
                                "--with-cxx-shared",
                                "--without-debug",
                                "--enable-pc-files",
                                "--enable-widec",
                                "--with-pkg-config-libdir=/usr/lib32/pkgconfig"],
                                path: buildDirectoryPath(entry: "32Bits"),
                                environment: {  "CC" =>"gcc -m32",
                                                "CXX" => "g++ -m32"})
        end
    end

    def configurex32Bits
        if option("Pass1")
            configureSource([   "--host=#{Ism.settings.systemTarget}X32",
                                "--prefix=/usr",
                                "--build=$(./config.guess)",
                                "--libdir=/usr/lib32",
                                "--mandir=/usr/share/man",
                                "--with-shared",
                                "--without-normal",
                                "--with-cxx-shared",
                                "--without-debug",
                                "--without-ada",
                                "--disable-stripping",
                                "--enable-widec"],
                                path: buildDirectoryPath(entry: "x32Bits"),
                                environment: {  "CC" =>"gcc -mx32",
                                                "CXX" => "g++ -mx32"})
        else
            configureSource([   "--host=#{Ism.settings.systemTarget}x32",
                                "--prefix=/usr",
                                "--libdir=/usr/lib32",
                                "--mandir=/usr/share/man",
                                "--with-shared",
                                "--without-normal",
                                "--without-debug",
                                "--enable-pc-files",
                                "--enable-widec",
                                "--with-pkg-config-libdir=/usr/libx32/pkgconfig"],
                                path: buildDirectoryPath(entry: "x32Bits"),
                                environment: {  "CC" =>"gcc -mx32",
                                                "CXX" => "g++ -mx32"})
        end
    end

    def configure
        super

        if option("Pass1")
            configureSource([   "--prefix=/usr",
                                "--host=#{Ism.settings.chrootTarget}",
                                "--build=$(./config.guess)",
                                "--mandir=/usr/share/man",
                                "--with-manpage-format=normal",
                                "--with-shared",
                                "--without-normal",
                                "--with-cxx-shared",
                                "--without-debug",
                                "--without-ada",
                                "--disable-stripping",
                                "--enable-widec"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr",
                                "--mandir=/usr/share/man",
                                "--with-shared",
                                "--without-debug",
                                "--without-normal",
                                "--with-cxx-shared",
                                "--enable-pc-files",
                                "--enable-widec",
                                "--with-pkg-config-libdir=/usr/lib/pkgconfig"],
                                buildDirectoryPath)
        end

        if option("32Bits")
            configure32Bits
        end

        if option("x32Bits")
            configurex32Bits
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

    def prepareInstallation32Bits
        if option("Pass1")

            makeSource( ["DESTDIR=#{buildDirectoryPath(entry: "32Bits")}/32Bits",
                        "TIC_PATH=$(pwd)/build/progs/tic",
                        "install"],
                        path: buildDirectoryPath(entry: "32Bits"))
        else

            makeSource( ["DESTDIR=#{buildDirectoryPath(entry: "32Bits")}/32Bits",
                        "install"],
                        path: buildDirectoryPath(entry: "32Bits"))

            makeDirectory("#{buildDirectoryPath(entry: "32Bits")}/32Bits/usr/lib32/pkgconfig")

            fileAppendData("#{buildDirectoryPath(entry: "32Bits")}/32Bits/usr/lib32/libncurses.so","INPUT(-lncursesw)")
            fileAppendData("#{buildDirectoryPath(entry: "32Bits")}/32Bits/usr/lib32/libform.so","INPUT(-lformw)")
            fileAppendData("#{buildDirectoryPath(entry: "32Bits")}/32Bits/usr/lib32/libpanel.so","INPUT(-lpanelw)")
            fileAppendData("#{buildDirectoryPath(entry: "32Bits")}/32Bits/usr/lib32/libmenu.so","INPUT(-lmenuw)")
            fileAppendData("#{buildDirectoryPath(entry: "32Bits")}/32Bits/usr/lib32/libcursesw.so","INPUT(-lncursesw)")
        end

        makeDirectory("#{buildDirectoryPath(entry: "32Bits")}/32Bits")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr")

        copyDirectory(  "#{buildDirectoryPath(entry: "32Bits")}/32Bits/usr/lib32",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib32")
    end

    def prepareInstallationx32Bits
        if option("Pass1")

            makeSource( ["DESTDIR=#{buildDirectoryPath(entry: "x32Bits")}/x32Bits",
                        "TIC_PATH=$(pwd)/build/progs/tic",
                        "install"],
                        path: buildDirectoryPath(entry: "x32Bits"))
        else

            makeSource( ["DESTDIR=#{buildDirectoryPath(entry: "x32Bits")}/x32Bits",
                        "install"],
                        path: buildDirectoryPath(entry: "x32Bits"))

            makeDirectory("#{buildDirectoryPath(entry: "x32Bits")}/x32Bits/usr/libx32/pkgconfig")

            fileAppendData("#{buildDirectoryPath(entry: "x32Bits")}/x32Bits/usr/libx32/libncurses.so","INPUT(-lncursesw)")
            fileAppendData("#{buildDirectoryPath(entry: "x32Bits")}/32Bits/usr/libx32/libform.so","INPUT(-lformw)")
            fileAppendData("#{buildDirectoryPath(entry: "x32Bits")}/32Bits/usr/libx32/libpanel.so","INPUT(-lpanelw)")
            fileAppendData("#{buildDirectoryPath(entry: "x32Bits")}/32Bits/usr/libx32/libmenu.so","INPUT(-lmenuw)")
            fileAppendData("#{buildDirectoryPath(entry: "x32Bits")}/32Bits/usr/libx32/libcursesw.so","INPUT(-lncursesw)")
        end

        makeDirectory("#{buildDirectoryPath(entry: "x32Bits")}/x32Bits")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr")

        copyDirectory(  "#{buildDirectoryPath(entry: "x32Bits")}/x32Bits/usr/libx32",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/libx32")
    end
    
    def prepareInstallation
        super

        if option("Pass1")
            makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","TIC_PATH=$(pwd)/build/progs/tic","install"],buildDirectoryPath)
            fileAppendData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libncurses.so","INPUT(-lncursesw)")
        else
            makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
            fileAppendData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libncurses.so","INPUT(-lncursesw)")
            fileAppendData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libform.so","INPUT(-lformw)")
            fileAppendData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libpanel.so","INPUT(-lpanelw)")
            fileAppendData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libmenu.so","INPUT(-lmenuw)")
            fileAppendData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libcursesw.so","INPUT(-lncursesw)")
        end

        if option("32Bits")
            prepareInstallation32Bits

            if option("Pass1")
                makeLink("libncursesw.so","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib32/libcursesw.so",:symbolicLinkByOverwrite)
            else
                makeLink("ncursesw.pc","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib32/pkgconfig/ncurses.pc",:symbolicLinkByOverwrite)
                makeLink("formw.pc","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib32/pkgconfig/form.pc",:symbolicLinkByOverwrite)
                makeLink("panelw.pc","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib32/pkgconfig/panel.pc",:symbolicLinkByOverwrite)
                makeLink("menuw.pc","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib32/pkgconfig/menu.pc",:symbolicLinkByOverwrite)
                makeLink("libncurses.so","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib32/libcurses.so",:symbolicLinkByOverwrite)
            end
        end

        if option("x32Bits")
            prepareInstallationx32Bits

            if option("Pass1")
                makeLink("libncursesw.so","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/libx32/libcursesw.so",:symbolicLinkByOverwrite)
            else
                makeLink("ncursesw.pc","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/libx32/pkgconfig/ncurses.pc",:symbolicLinkByOverwrite)
                makeLink("formw.pc","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/libx32/pkgconfig/form.pc",:symbolicLinkByOverwrite)
                makeLink("panelw.pc","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/libx32/pkgconfig/panel.pc",:symbolicLinkByOverwrite)
                makeLink("menuw.pc","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/libx32/pkgconfig/menu.pc",:symbolicLinkByOverwrite)
                makeLink("libncurses.so","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/libx32/libcurses.so",:symbolicLinkByOverwrite)
            end
        end

        if !option("Pass1")
            makeLink("ncursesw.pc","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/pkgconfig/ncurses.pc",:symbolicLinkByOverwrite)
            makeLink("formw.pc","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/pkgconfig/form.pc",:symbolicLinkByOverwrite)
            makeLink("panelw.pc","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/pkgconfig/panel.pc",:symbolicLinkByOverwrite)
            makeLink("menuw.pc","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/pkgconfig/menu.pc",:symbolicLinkByOverwrite)
            makeLink("libncurses.so","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libcurses.so",:symbolicLinkByOverwrite)
        end
    end

end
