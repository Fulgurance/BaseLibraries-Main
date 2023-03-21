class Target < ISM::Software

    def prepare
        super

        fileDeleteLine("#{buildDirectoryPath(false)}src/Makefile",62)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
