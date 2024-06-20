class Target < ISM::Software

    def prepareInstallation
        super

        runPythonCommand(   arguments:  "setup.py install bdist",
                            path:       buildDirectoryPath)

        runTarCommand(  arguments:  "-xf MarkupSafe-2.1.3.linux-x86_64.tar.gz",
                        path:       "#{buildDirectoryPath}/dist/")

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr")

        copyDirectory(  "#{buildDirectoryPath}/dist/",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr")

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d")

        if File.exists?("#{Ism.settings.rootPath}etc/profile.d/python.sh")
            copyFile(   "/etc/profile.d/python.sh",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/python.sh")
        else
            generateEmptyFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/python.sh")
        end

        pythonData = <<-CODE
        pathappend /usr/lib/python3.11/site-packages/MarkupSafe-2.1.3-py3.11-linux-x86_64.egg PYTHONPATH
        CODE
        fileUpdateContent("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/python.sh",pythonData)
    end

end
