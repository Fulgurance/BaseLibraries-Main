class Target < ISM::Software

    def prepare
        super

        fileReplaceTextAtLineNumber(path:       "#{buildDirectoryPath}/boost/phoenix/stl.hpp",
                                    text:       "#include <boost/phoenix/stl/tuple.hpp>",
                                    newText:    "",
                                    lineNumber: 14)
    end

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
                arguments:  "stage #{Ism.settings.makeOptions} threading=multi link=shared",
                path:       buildDirectoryPath)
    end

    def prepareInstallation
        super

        runFile(file:       "b2",
                arguments:  "install threading=multi link=shared",
                path:       buildDirectoryPath)
    end

end
