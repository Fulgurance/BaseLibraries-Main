class Target < ISM::Software

    def configure
        super
        makeSource([Ism.settings.makeOptions, "mrproper"],mainWorkDirectoryPath)
    end

    def build
        super
        makeSource([Ism.settings.makeOptions, "headers"],mainWorkDirectoryPath)
    end

    def prepareInstallation
        super
        deleteAllHiddenFilesRecursively("#{mainWorkDirectoryPath}usr/include")
        deleteFile("#{mainWorkDirectoryPath}usr/include/Makefile")
        makeDirectory("#{builtSoftwareDirectoryPath}/usr")
        copyDirectory("#{mainWorkDirectoryPath}usr/include", "#{Ism.settings.rootPath}/usr")
    end

end
