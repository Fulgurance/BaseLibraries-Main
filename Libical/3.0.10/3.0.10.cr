class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure

        runCmakeCommand([   "-DCMAKE_INSTALL_PREFIX=/usr",
                            "-DCMAKE_BUILD_TYPE=Release",
                            "-DSHARED_ONLY=yes",
                            "-DICAL_BUILD_DOCS=false",
                            "-DGOBJECT_INTROSPECTION=true",
                            "-DICAL_GLIB_VAPI=true",
                            "-DENABLE_GTK_DOC=false",
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
