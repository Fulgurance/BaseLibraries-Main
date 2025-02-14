class Target < ISM::Software
    
    def prepareInstallation
        super

        majorPythonVersion = softwareMajorVersion("@ProgrammingLanguages-Main:Python")
        minorPythonVersion = softwareMinorVersion("@ProgrammingLanguages-Main:Python")
        pythonVersion = "#{majorPythonVersion}.#{minorPythonVersion}"

        packagesPath = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/python#{pythonVersion}/site-packages"

        makeDirectory(packagesPath)

        runPipCommand(  arguments:  "install --root-user-action=ignore --no-dependencies --target \"#{packagesPath}\" #{mainWorkDirectoryPath}",
                        version:    pythonVersion)

        directoryContent(packagesPath, matchHidden: true).each do |filePath|

            if filePath.squeeze("/") == "#{packagesPath}/share".squeeze("/")
                destinationPath = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr"

                makeDirectory(destinationPath)

                moveFile(   path:       filePath,
                            newPath:    destinationPath)
            end

            if filePath.squeeze("/") == "#{packagesPath}/bin".squeeze("/")
                destinationPath = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr"

                makeDirectory(destinationPath)

                moveFile(   path:       filePath,
                            newPath:    destinationPath)
            end

        end
    end

end
