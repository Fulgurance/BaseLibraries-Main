class Target < ISM::Software
    
    def prepareInstallation
        super

        runPythonCommand(["setup.py","install","--optimize=1","--prefix=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr"],buildDirectoryPath)
    end

end
