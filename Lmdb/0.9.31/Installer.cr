class Target < ISM::Software

    def prepare
        @buildDirectory = true
        @buildDirectoryNames["MainBuild"] = "libraries/liblmdb/"
        super
    end

    def build
        super

        makeSource(path: buildDirectoryPath)

        fileReplaceText(path:       "#{buildDirectoryPath}Makefile",
                        text:       "liblmdb.a",
                        newText:    "")
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "prefix=/usr DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
