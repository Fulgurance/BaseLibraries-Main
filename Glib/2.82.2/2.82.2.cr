class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runMesonCommand(arguments:  "setup --reconfigure                                                        \
                                    --prefix=/usr                                                               \
                                    --buildtype=release                                                         \
                                    -Dintrospection=#{option("Gobject-Introspection") ? "enabled" : "disabled"} \
                                    -Dglib_debug=disabled                                                       \
                                    -Dman-pages=disabled                                                        \
                                    -Dsysprof=disabled                                                          \
                                    ..",
                        path:       buildDirectoryPath)
    end

    def build
        super

        runNinjaCommand(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        runNinjaCommand(arguments:      "install",
                        path:           buildDirectoryPath,
                        environment:    {"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})
    end

end
