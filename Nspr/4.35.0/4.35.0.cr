class Target < ISM::Software

    def prepare
        super

        fileDeleteLine("#{buildDirectoryPath(false)}pr/src/misc/Makefile.in",54)
        fileReplaceTextAtLineNumber("#{buildDirectoryPath(false)}config/rules.mk","$(SHARED_LIBRARY)","$(LIBRARY) $(SHARED_LIBRARY)",116)
        fileReplaceTextAtLineNumber("#{buildDirectoryPath(false)}config/rules.mk","$(SHARED_LIBRARY)","$(LIBRARY) $(SHARED_LIBRARY)",125)
    end
    
    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--with-mozilla",
                            "--with-pthreads",
                            "--enable-64bit"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
