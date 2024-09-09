class Target < ISM::Software
    
    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/include")

        copyDirectory(  "#{buildDirectoryPath}/include/nlohmann",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/include/nlohmann")
    end

end
