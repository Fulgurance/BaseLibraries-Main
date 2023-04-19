class Target < ISM::Software

    def extract
        super

        moveFile("#{workDirectoryPath(false)}/lmdb-LMDB_0.9.29","#{workDirectoryPath(false)}/LMDB_0.9.29")
    end

    def prepare
        @buildDirectory = true
        @buildDirectoryName = "libraries/liblmdb/"
        super
    end

    def build
        super

        makeSource(path: buildDirectoryPath)

        fileReplaceText("#{buildDirectoryPath(false)}Makefile","liblmdb.a","")
    end
    
    def prepareInstallation
        super

        makeSource(["prefix=/usr","DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
