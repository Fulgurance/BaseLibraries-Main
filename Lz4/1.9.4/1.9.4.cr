class Target < ISM::Software
    
    def build
        super

        makeSource(["PREFIX=/usr"],path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","PREFIX=/usr","install"],buildDirectoryPath)
    end

end
