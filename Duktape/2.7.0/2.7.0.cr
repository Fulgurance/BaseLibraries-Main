class Target < ISM::Software
    
    def prepare
        super

        fileReplaceText(path:       "#{buildDirectoryPath}/Makefile.sharedlibrary",
                        text:       "-Os",
                        newText:    "-O2")
    end

    def build
        super

        makeSource( arguments:  "-f Makefile.sharedlibrary INSTALL_PREFIX=/usr",
                    path:       buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "-f Makefile.sharedlibrary DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} INSTALL_PREFIX=/usr install"],
                    path:       buildDirectoryPath)
    end

end
