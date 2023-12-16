class Target < ISM::Software

    def prepare
        super

        fileReplaceTextAtLineNumber("#{buildDirectoryPath(false)}/boost/phoenix/stl.hpp","#include <boost/phoenix/stl/tuple.hpp>","",14)
    end

    def configure
        super

        runScript(  "bootstrap.sh",
                    [   "--prefix=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr",
                        "--with-python=python3"],
                            buildDirectoryPath)
    end

    def build
        super

        runScript(  "b2",
                    [   "stage",
                        "#{Ism.settings.makeOptions}",
                        "threading=multi",
                        "link=shared"],
                            buildDirectoryPath)
    end

    def prepareInstallation
        super

        runScript(  "b2",
                    [   "install",
                        "threading=multi",
                        "link=shared"],
                            buildDirectoryPath)
    end

end
