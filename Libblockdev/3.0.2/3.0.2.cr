class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--sysconfdir=/etc",
                            "--with-python3",
                            "#{option("Volume-Key") ? "--with-escrow" : "--without-escrow"}",
                            "--without-gtk-doc",
                            "#{option("Parted") ? "--with-lvm" : "--without-lvm"}",
                            "#{option("Parted") ? "--with-lvm_dbus" : "--without-lvm_dbus"}",
                            "--without-nvdimm",
                            "#{option("Parted") ? "--with-tools" : "--without-tools"}"],
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
