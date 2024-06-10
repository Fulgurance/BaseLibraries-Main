class Target < ISM::Software

    def prepare
        super

        fileDeleteLine("#{buildDirectoryPath}/libcap/Makefile",190)
        fileDeleteLine("#{buildDirectoryPath}/libcap/Makefile",200)
    end

    def build
        super

        makeSource( ["prefix=/usr",
                    "lib=lib"],
                    path: buildDirectoryPath)
    end

    def build32Bits

        makeSource( ["distclean"],
                    path: buildDirectoryPath)

        makeSource( path: buildDirectoryPath,
                    environment: {"CC" => "gcc -m32 -march=i686"})
    end

    def buildx32Bits

        makeSource( ["distclean"],
                    path: buildDirectoryPath)

        makeSource( path: buildDirectoryPath,
                    environment: {"CC" => "gcc -mx32 -march=x86-64"})
    end

    def prepareInstallation
        super

        makeSource( ["prefix=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}usr",
                    "lib=lib",
                    "install"],
                    path: buildDirectoryPath)

        if option("32Bits")
            build32Bits
            prepareInstallation32Bits
        end

        if option("x32Bits")
            buildx32Bits
            prepareInstallationx32Bits
        end
    end

    def prepareInstallation32Bits

        makeDirectory("#{buildDirectoryPath}/32Bits")

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr")

        makeSource( ["lib=lib32",
                    "prefix=#{buildDirectoryPath}/32Bits/usr",
                    "-C",
                    "libcap",
                    "install"],
                    path: buildDirectoryPath,
                    environment: {"CC" => "gcc -m32 -march=i686"})

        copyDirectory(  "#{buildDirectoryPath}/32Bits/usr/lib32",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib32")

        fileReplaceText("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib32/pkgconfig/libcap.pc",
                        "libdir=/lib64",
                        "libdir=/lib32")

        fileReplaceText("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib32/pkgconfig/libpsx.pc",
                        "libdir=/lib64",
                        "libdir=/lib32")
    end

    def prepareInstallationx32Bits

        makeDirectory("#{buildDirectoryPath}/x32Bits")

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr")

        makeSource( ["lib=libx32",
                    "prefix=#{buildDirectoryPath}/32Bits/usr",
                    "-C",
                    "libcap",
                    "install"],
                    path: buildDirectoryPath,
                    environment: {"CC" => "gcc -mx32 -march=x86-64"})

        copyDirectory(  "#{buildDirectoryPath}/x32Bits/usr/libx32",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/libx32")

        fileReplaceText("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/libx32/pkgconfig/libcap.pc",
                        "libdir=/lib64",
                        "libdir=/libx32")

        fileReplaceText("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/libx32/pkgconfig/libpsx.pc",
                        "libdir=/lib64",
                        "libdir=/libx32")
    end

    def install
        super

        if option("32Bits")
            setPermissions("#{Ism.settings.rootPath}/usr/lib32/libcap.so.2.69",0o755)
        end

        if option("x32Bits")
            setPermissions("#{Ism.settings.rootPath}/usr/libx32/libcap.so.2.69",0o755)
        end
    end

end
