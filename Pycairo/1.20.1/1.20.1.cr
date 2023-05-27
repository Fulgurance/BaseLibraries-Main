class Target < ISM::Software
    
    def prepareInstallation
        super

        runPythonCommand(["setup.py","install","bdist"],buildDirectoryPath)

        extractArchive("#{buildDirectoryPath}/dist/pycairo-1.20.1.linux-x86_64.tar.gz")

        copyDirectory("#{workDirectoryPath(false)}/usr","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr")

        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/profile.d")

        if File.exists?("#{Ism.settings.rootPath}etc/profile.d/python.sh")
            copyFile("#{Ism.settings.rootPath}etc/profile.d/python.sh","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/profile.d/python.sh")
        else
            generateEmptyFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/profile.d/python.sh")
        end

        pythonData = <<-CODE
        pathappend /usr/lib/python3.9/site-packages/pycairo-1.20.1-py3.9-linux-x86_64.egg PYTHONPATH
        CODE
        fileUpdateContent("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/python.sh",pythonData)
    end

end
