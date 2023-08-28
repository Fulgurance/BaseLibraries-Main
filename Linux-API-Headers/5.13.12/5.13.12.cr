class Target < ISM::Software

    def configure
        super

        makeSource(["mrproper"],mainWorkDirectoryPath)
    end

    def build
        super

        makeSource(["headers"],mainWorkDirectoryPath)
    end

    def prepareInstallation
        super

        if option("Pass1")
            deleteAllHiddenFilesRecursively("#{mainWorkDirectoryPath}usr/include")
            deleteFile("#{mainWorkDirectoryPath}usr/include/Makefile")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr")
            copyDirectory("#{mainWorkDirectoryPath}usr/include", "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr")
        else
            deleteAllHiddenFilesRecursively("#{mainWorkDirectoryPath(false)}usr/include")
            deleteFile("#{mainWorkDirectoryPath(false)}usr/include/Makefile")
            makeDirectory("#{builtSoftwareDirectoryPath(false)}/usr")
            copyDirectory("#{mainWorkDirectoryPath(false)}usr/include", "#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr")
        end
    end

end
