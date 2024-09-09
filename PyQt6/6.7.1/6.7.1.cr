class Target < ISM::Software
    
    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/python3.11/sites-packages")

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d")

        copyDirectory(  "#{buildDirectoryPath}/*",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/python3.11/sites-packages/")
    end

end
