class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super

        fileDeleteLine("#{mainWorkDirectoryPath}/CMakeLists.txt",312)

        fileReplaceTextAtLineNumber(path:       "#{mainWorkDirectoryPath}/CMakeLists.txt",
                                    text:       "/etc/pki/tls/cert.pem",
                                    newText:    "\"/usr/share/ssl/certs/ca-bundle.crt\"/n/etc/pki/tls/certs/ca-bundle.crt",
                                    lineNumber: 313)
    end
    
    def configure
        super

        runCmakeCommand(arguments:  "-DCMAKE_INSTALL_PREFIX=/usr                \
                                    -DCMAKE_BUILD_TYPE=Release                  \
                                    -DQCA_MAN_INSTALL_DIR:PATH=/usr/share/man   \
                                    ..",
                        path:       buildDirectoryPath)
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
