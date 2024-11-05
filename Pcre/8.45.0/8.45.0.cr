class Target < ISM::Software
    
    def configure
        super

        configureSource(arguments:  "--prefix=/usr                          \
                                    --docdir=/usr/share/doc/#{versionName}  \
                                    --enable-unicode-properties             \
                                    --enable-pcre16                         \
                                    --enable-pcre32                         \
                                    --enable-pcregrep-libz                  \
                                    --enable-pcregrep-libbz2                \
                                    --enable-pcretest-libreadline           \
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
