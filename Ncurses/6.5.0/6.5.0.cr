class Target < ISM::Software
    
    def prepare
        if option("Pass1")
            @buildDirectory = true
            super

            configureSource(path: buildDirectoryPath)

            makeSource( arguments:  "-C include",
                        path:       buildDirectoryPath)

            makeSource( arguments:  "-C progs tic",
                        path:       buildDirectoryPath)
        else
            super
        end
    end

    def configure
        super

        if option("Pass1")
            configureSource(arguments:  "--prefix=/usr                                                  \
                                        --host=#{Ism.settings.chrootTarget}                             \
                                        --build=#{Ism.settings.systemTarget(relatedToChroot: false)}    \
                                        --mandir=/usr/share/man                                         \
                                        --with-manpage-format=normal                                    \
                                        --with-shared                                                   \
                                        --without-normal                                                \
                                        --with-cxx-shared                                               \
                                        --without-debug                                                 \
                                        --without-ada                                                   \
                                        --disable-stripping                                             \
                                        --enable-widec",
                            path:       buildDirectoryPath)
        else
            configureSource(arguments:  "--prefix=/usr          \
                                        --mandir=/usr/share/man \
                                        --with-shared           \
                                        --without-debug         \
                                        --without-normal        \
                                        --with-cxx-shared       \
                                        --enable-pc-files       \
                                        --enable-widec          \
                                        --with-pkg-config-libdir=/usr/lib/pkgconfig",
                            path:       buildDirectoryPath)
        end
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        if option("Pass1")
            makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} TIC_PATH=$(pwd)/build/progs/tic install",
                        path:       buildDirectoryPath)

            fileAppendData( "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libncurses.so",
                            "INPUT(-lncursesw)")
        else
            makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                        path:       buildDirectoryPath)

            fileAppendData( "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libncurses.so",
                            "INPUT(-lncursesw)")

            fileAppendData( "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libform.so",
                            "INPUT(-lformw)")

            fileAppendData( "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libpanel.so",
                            "INPUT(-lpanelw)")

            fileAppendData( "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libmenu.so",
                            "INPUT(-lmenuw)")

            fileAppendData( "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libcursesw.so",
                            "INPUT(-lncursesw)")
        end

        if !option("Pass1")
            makeLink(   target: "ncursesw.pc",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/pkgconfig/ncurses.pc",
                        type:   :symbolicLinkByOverwrite)

            makeLink(   target: "formw.pc",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/pkgconfig/form.pc",
                        type:   :symbolicLinkByOverwrite)

            makeLink(   target: "panelw.pc",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/pkgconfig/panel.pc",
                        type:   :symbolicLinkByOverwrite)

            makeLink(   target: "menuw.pc",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/pkgconfig/menu.pc",
                        type:   :symbolicLinkByOverwrite)

            makeLink(   target: "libncurses.so",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libcurses.so",
                        type:   :symbolicLinkByOverwrite)
        end
    end

end
