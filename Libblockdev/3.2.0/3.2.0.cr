class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr                                                  \
                                    --sysconfdir=/etc                                               \
                                    --with-python3                                                  \
                                    #{option("Volume-Key") ? "--with-escrow" : "--without-escrow"}  \
                                    --without-gtk-doc                                               \
                                    #{option("Parted") ? "--with-lvm" : "--without-lvm"}            \
                                    #{option("Parted") ? "--with-lvm_dbus" : "--without-lvm_dbus"}  \
                                    --without-nvdimm                                                \
                                    #{option("Parted") ? "--with-tools" : "--without-tools"}",
                        path:   buildDirectoryPath)
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
