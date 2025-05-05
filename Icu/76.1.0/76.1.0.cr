class Target < ISM::Software

    def prepare
        @buildDirectory = true
        @buildDirectoryNames["MainBuild"] = "source"
        super
    end
    
    def configure
        super

        configureSource(arguments:          "--prefix=/usr      \
                                            --disable-tools     \
                                            --disable-fuzzer    \
                                            --disable-tests     \
                                            --disable-samples",
                        path:               buildDirectoryPath,
                        configureDirectory: @buildDirectoryNames["MainBuild"])
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
