class Target < ISM::Software

    def prepare
        super

        fileDeleteLine("#{buildDirectoryPath}pr/src/misc/Makefile.in",54)

        fileReplaceTextAtLineNumber(path:       "#{buildDirectoryPath}config/rules.mk",
                                    text:       "$(SHARED_LIBRARY)",
                                    newText:    "$(LIBRARY) $(SHARED_LIBRARY)",
                                    lineNumber: 116)

        fileReplaceTextAtLineNumber(path:       "#{buildDirectoryPath}config/rules.mk",
                                    text:       "$(SHARED_LIBRARY)",
                                    newText:    "$(LIBRARY) $(SHARED_LIBRARY)",
                                    lineNumber: 125)
    end
    
    def configure
        super

        configureSource(arguments:  "--prefix=/usr  \
                                    --with-mozilla  \
                                    --with-pthreads \
                                    --enable-64bit",
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
