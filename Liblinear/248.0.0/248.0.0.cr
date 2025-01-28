class Target < ISM::Software
    
    def build
        super

        makeSource( arguments:  "lib",
                    path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/include")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib")

        copyFile(   "#{buildDirectoryPath}/linear.h",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/include/linear.h")
        copyFile(   "#{buildDirectoryPath}/liblinear.so.6",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/liblinear.so.6")

        makeLink(   target: "liblinear.so.6",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/liblinear.so",
                    type:   :symbolicLinkByOverwrite)
    end

    def install
        super

        runChmodCommand("644 /usr/include/linear.h")
        runChmodCommand("755 /usr/lib/linear.so.6")
    end

end
