class Target < ISM::Software
    
    def prepare
        super

        fileReplaceText("#{buildDirectoryPath(false)}/Makefile.sharedlibrary","-Os","-O2")
    end

    def build
        super

        makeSource(["-f",
                    "Makefile.sharedlibrary",
                    "INSTALL_PREFIX=/usr"]
                    path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["-f",
                    "Makefile.sharedlibrary",
                    "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}",
                    "INSTALL_PREFIX=/usr",
                    "install"]
                    path: buildDirectoryPath)
    end

end
