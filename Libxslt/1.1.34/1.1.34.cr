class Target < ISM::Software

    def prepare
        super

        fileReplaceText("#{mainWorkDirectoryPath(false)}libxslt/transform.c","int xsltMaxDepth = 3000;","int xsltMaxDepth = 5000;")
        fileDeleteLine("#{mainWorkDirectoryPath(false)}/tests/fuzz/fuzz.c",171)
        fileDeleteLine("#{mainWorkDirectoryPath(false)}/tests/fuzz/fuzz.c",171)
        fileDeleteLine("#{mainWorkDirectoryPath(false)}/tests/fuzz/fuzz.c",303)
        fileDeleteLine("#{mainWorkDirectoryPath(false)}/tests/fuzz/fuzz.c",303)
    end
    
    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--disable-static",
                            "--without-python"],
                            buildDirectoryPath)
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
