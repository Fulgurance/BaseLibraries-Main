class Target < ISM::Software
    
    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/include")

        copyFile(   "#{buildDirectoryPath}/include/*",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/include/")
    end

end
