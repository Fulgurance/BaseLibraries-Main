class Target < ISM::Software

    def prepare
        super

        fileReplaceTextAtLineNumber("#{buildDirectoryPath(false)}/boost/phoenix/stl.hpp","#include <boost/phoenix/stl/tuple.hpp>","",14)
    end

    def configure
        super

        runFile(  "bootstrap.sh",
                    [   "--prefix=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr",
                        "--with-python=python3"],
                            buildDirectoryPath)
    end

    def build
        super

        runFile(  "b2",
                    [   "stage",
                        "#{Ism.settings.makeOptions}",
                        "threading=multi",
                        "link=shared"],
                            buildDirectoryPath)
    end

    def prepareInstallation
        super

        runFile(  "b2",
                    [   "install",
                        "threading=multi",
                        "link=shared"],
                            buildDirectoryPath)
    end

end
