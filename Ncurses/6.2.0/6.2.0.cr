class Target < ISM::Software
    
    def prepare
        if option("Pass1")
            @buildDirectory = true
            super

            configureSource([] of String,buildDirectoryPath)
            makeSource([Ism.settings.makeOptions,"-C","include"],buildDirectoryPath)
            makeSource([Ism.settings.makeOptions,"-C","progs","tic"],buildDirectoryPath)
        else
            super
        end
    end

    def configure
        super

        if option("Pass1")
            configureSource([   "--prefix=/usr",
                                "--host=#{Ism.settings.target}",
                                "--build=$(./config.guess)",
                                "--mandir=/usr/share/man",
                                "--with-manpage-format=normal",
                                "--with-shared",
                                "--without-debug",
                                "--without-ada",
                                "--without-normal",
                                "--enable-widec"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr",
                                "--mandir=/usr/share/man",
                                "--with-shared",
                                "--without-debug",
                                "--without-normal",
                                "--enable-pc-files",
                                "--enable-widec"],
                                buildDirectoryPath)
        end
    end
    
    def build
        super

        makeSource([Ism.settings.makeOptions],buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        if option("Pass1")
            makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","TIC_PATH=$(pwd)/build/progs/tic","install"],buildDirectoryPath)
            fileAppendData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libncurses.so","INPUT(-lncursesw)")
        else
            makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
            fileAppendData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/lib/libncurses.so","INPUT(-lncursesw)")
            fileAppendData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/lib/libform.so","INPUT(-lformw)")
            fileAppendData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/lib/libpanel.so","INPUT(-lpanelw)")
            fileAppendData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/lib/libmenu.so","INPUT(-lmenuw)")
            fileAppendData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/lib/libcursesw.so","INPUT(-lncursesw)")
        end
    end

    def install
        super

        if !option("Pass1")
            makeLink("ncursesw.pc","#{Ism.settings.rootPath}usr/lib/pkgconfig/ncurses.pc",:symbolicLinkByOverwrite)
            makeLink("formw.pc","#{Ism.settings.rootPath}usr/lib/pkgconfig/form.pc",:symbolicLinkByOverwrite)
            makeLink("panelw.pc","#{Ism.settings.rootPath}usr/lib/pkgconfig/panel.pc",:symbolicLinkByOverwrite)
            makeLink("menuw.pc","#{Ism.settings.rootPath}usr/lib/pkgconfig/menu.pc",:symbolicLinkByOverwrite)
            makeLink("libncurses.so","#{Ism.settings.rootPath}usr/lib/libcurses.so",:symbolicLinkByOverwrite)
        end
    end

    def clean
        super

        if !option("Pass1")
            deleteFile("#{Ism.settings.rootPath}/usr/lib/libncurses++w.a")
        end
    end

end
