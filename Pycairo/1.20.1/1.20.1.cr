class Target < ISM::Software

    def build
        super

        runPythonCommand(["setup.py","build"],buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        runPythonCommand(["setup.py","install","--optimize=1","--prefix=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr"],buildDirectoryPath)

        runPythonCommand(["setup.py","install_pycairo_header","--prefix=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr"],buildDirectoryPath)

        runPythonCommand(["setup.py","install_pkgconfig","--prefix=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr"],buildDirectoryPath)

        if File.exists?("#{Ism.settings.rootPath}etc/profile.d/python.sh")
            copyFile("#{Ism.settings.rootPath}etc/profile.d/python.sh","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/profile.d/python.sh")
        else
            generateEmptyFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/profile.d/python.sh")
        end

        pythonData = <<-CODE
        pathappend /usr/lib/python3.9/site-packages/pycairo-1.20.1-py3.9.egg PYTHONPATH
        CODE
        fileUpdateContent("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/python.sh",pythonData)
    end

end
