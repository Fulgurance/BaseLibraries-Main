class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runMesonCommand([   "--prefix=/usr",
                            "--buildtype=release",
                            "-Dman=true",
                            ".."],
                            buildDirectoryPath)
    end

    def build
        super

        runNinjaCommand(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        runNinjaCommand(["install"],buildDirectoryPath,{"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/glib-2.68.4")

        copyFile("#{buildDirectoryPath}docs/reference/NEWS","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/glib-2.68.4/NEWS")
        copyDirectory("#{buildDirectoryPath}docs/reference/gio","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/glib-2.68.4/gio")
        copyDirectory("#{buildDirectoryPath}docs/reference/glib","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/glib-2.68.4/glib")
        copyDirectory("#{buildDirectoryPath}docs/reference/gobject","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/glib-2.68.4/gobject")
    end

end
