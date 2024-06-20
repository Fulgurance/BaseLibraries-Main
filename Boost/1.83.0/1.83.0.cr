class Target < ISM::Software

    def configure
        super

        runFile(file:       "bootstrap.sh",
                arguments:  "--prefix=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr \
                            --with-python=python3",
                path:       buildDirectoryPath)
    end

    def build
        super

        runFile(file:       "b2",
                arguments:  "stage #{Ism.settings.systemMakeOptions} threading=multi link=shared",
                path:       buildDirectoryPath)
    end

    def prepareInstallation
        super

        runFile(file:       "b2",
                arguments:  "install threading=multi link=shared",
                path:       buildDirectoryPath)
    end

end
