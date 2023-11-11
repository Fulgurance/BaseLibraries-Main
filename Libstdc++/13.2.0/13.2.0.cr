class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        if option("Pass1")
            configureSource([   "--host=#{Ism.settings.chrootTarget}",
                                "--build=$(../config.guess)",
                                "--prefix=#{Ism.settings.rootPath}usr",
                                "--disable-multilib",
                                "--disable-nls",
                                "--disable-libstdcxx-pch",
                                "--with-gxx-include-dir=#{Ism.settings.toolsPath}#{Ism.settings.chrootTarget}/include/c++/13.2.0"],
                                buildDirectoryPath,
                                "libstdc++-v3")
        end
    end

    def build
        super

        if option("Pass1")
            makeSource(path: buildDirectoryPath)
        end
    end

    def prepareInstallation
        if option("Pass1")
            super
        else
            Ism.addInstalledSoftware(@information)
        end

        if option("Pass1")
            makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}","install"],buildDirectoryPath)

            deleteFile("#{builtSoftwareDirectoryPath(false)}/usr/lib/libstdc++.la")
            deleteFile("#{builtSoftwareDirectoryPath(false)}/usr/lib/libstdc++fs.la")
            deleteFile("#{builtSoftwareDirectoryPath(false)}/usr/lib/libsupc++.la")
        end

    end

end
