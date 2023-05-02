class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super

        fileDeleteLine("#{mainWorkDirectoryPath(false)}/CMakeLists.txt",304)
        fileReplaceTextAtLineNumber("#{mainWorkDirectoryPath(false)}/CMakeLists.txt","/etc/pki/tls/cert.pem","\"/usr/share/ssl/certs/ca-bundle.crt\"/n/etc/pki/tls/certs/ca-bundle.crt",305)
    end
    
    def configure
        super

        runCmakeCommand([   "-DCMAKE_INSTALL_PREFIX=/usr",
                            "-DCMAKE_BUILD_TYPE=Release",
                            "-DQCA_MAN_INSTALL_DIR:PATH=/usr/share/man",
                            ".."],
                            buildDirectoryPath)
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
