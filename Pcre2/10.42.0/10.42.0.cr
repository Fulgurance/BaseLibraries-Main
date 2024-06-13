class Target < ISM::Software
    
    def configure
        super

        configureSource(arguments:  "--prefix=/usr                          \
                                    --docdir=/usr/share/doc/pcre2-10.42     \
                                    --enable-unicode                        \
                                    --enable-jit                            \
                                    --enable-pcre2-16                       \
                                    --enable-pcre2-32                       \
                                    --enable-pcre2grep-libz                 \
                                    --enable-pcre2grep-libbz2               \
                                    --enable-pcre2test-libreadline          \
                                    --disable-static",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
