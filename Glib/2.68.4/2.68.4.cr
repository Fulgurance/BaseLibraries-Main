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

        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/glib-2.68.4")

        copyFile("#{buildDirectoryPath(false)}/docs/reference/NEWS","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/glib-2.68.4/NEWS")
        copyDirectory("#{buildDirectoryPath(false)}/docs/reference/gio","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/glib-2.68.4/gio")
        copyDirectory("#{buildDirectoryPath(false)}/docs/reference/glib","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/glib-2.68.4/glib")
        copyDirectory("#{buildDirectoryPath(false)}/docs/reference/gobject","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/glib-2.68.4/gobject")
    end

end
