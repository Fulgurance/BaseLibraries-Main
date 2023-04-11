class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super

        if option("Pass2")
            makeLink(   "gthr-posix.h",
                        "#{mainWorkDirectoryPath(false)}libgcc/gthr-default.h",
                        :symbolicLink)
        end
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
                                "--with-gxx-include-dir=#{Ism.settings.toolsPath}#{Ism.settings.chrootTarget}/include/c++/11.2.0"],
                                buildDirectoryPath,
                                "libstdc++-v3")
        end
        if option("Pass2")
            configureSource([   "CXXFLAGS=\"-g -O2 -D_GNU_SOURCE\"",
                                "--prefix=/usr",
                                "--disable-multilib",
                                "--disable-nls",
                                "--host=#{Ism.settings.target}",
                                "--disable-libstdcxx-pch"],
                                buildDirectoryPath,
                                "libstdc++-v3")
        end
    end

    def build
        super

        if option("Pass2")
            makeSource(path: buildDirectoryPath)
        end
    end

    def prepareInstallation
        if option("Pass1") || option("Pass2")
            super
        else
            Ism.addInstalledSoftware(@information)
        end

        if option("Pass1")
            makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}","install"],buildDirectoryPath)
        end

        if option("Pass2")
            makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
        end
    end

end
