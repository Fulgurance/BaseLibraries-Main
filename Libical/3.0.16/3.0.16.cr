class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runCmakeCommand(arguments:  "-DCMAKE_INSTALL_PREFIX=/usr    \
                                    -DCMAKE_BUILD_TYPE=Release      \
                                    -DSHARED_ONLY=yes               \
                                    -DICAL_BUILD_DOCS=false         \
                                    -DGOBJECT_INTROSPECTION=false   \
                                    -DICAL_GLIB=false               \
                                    -DICAL_GLIB_VAPI=false          \
                                    -DENABLE_GTK_DOC=false          \
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
