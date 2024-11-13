class Target < ISM::Software

    @@qtName = "qt#{majorVersion}"
    
    def configure
        super

        configureSource(arguments:  "--prefix=/usr                                          \
                                    --archdatadir=/usr/lib/#{@@qtName}                      \
                                    --bindir=/usr/bin/#{@@qtName}                           \
                                    --plugindir=/usr/lib/#{@@qtName}/plugins                \
                                    --importdir=/usr/lib/#{@@qtName}/imports                \
                                    --headerdir=/usr/include/#{@@qtName}                    \
                                    --datadir=/usr/share/#{@@qtName}                        \
                                    --docdir=/usr/share/doc/#{@@qtName}                     \
                                    --translationdir=/usr/share/#{@@qtName}/translations    \
                                    --sysconfdir=/etc/xdg                           \
                                    --confirm-license                               \
                                    --opensource                                    \
                                    #{option("Dbus") ? "--dbus-linked" : ""}        \
                                    #{option("Openssl") ? "--openssl-linked" : ""}  \
                                    #{option("Harfbuzz") ? "-system-harfbuzz" : ""} \
                                    #{option("Sqlite") ? "-system-sqlite" : ""}     \
                                    #{option("Xcb") ? "-xcb" : ""}                  \
                                    #{option("Cups") ? "-cups" : ""}                \
                                    --nomake=examples                               \
                                    --no-rpath                                      \
                                    --syslog                                        \
                                    --skip=qtwebengine",
                        path:       buildDirectoryPath)
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "INSTALL_ROOT=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/")

        if option("Assistant")
            copyFile(   "#{buildDirectoryPath}qttools/src/assistant/assistant/images/assistant-128.png",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps/assistant-#{@@qtName}.png")

            assistantData = <<-CODE
            [Desktop Entry]
            Name=Qt5 Assistant
            Comment=Shows Qt5 documentation and examples
            Exec=/usr/#{@@qtName}/bin/assistant
            Icon=assistant-#{@@qtName}.png
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;Documentation;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/assistant-#{@@qtName}.desktop",assistantData)
        else
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/assistant")
        end

        if option("Designer")
            copyFile("#{buildDirectoryPath}qttools/src/designer/src/designer/images/designer.png","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps/designer-#{@@qtName}.png")

            designerData = <<-CODE
            [Desktop Entry]
            Name=Qt5 Designer
            GenericName=Interface Designer
            Comment=Design GUIs for Qt5 applications
            Exec=/usr/#{@@qtName}/bin/designer
            Icon=designer-#{@@qtName}.png
            MimeType=application/x-designer;
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/designer-#{@@qtName}.desktop",designerData)
        else
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/designer")
        end

        if option("Linguist")
            copyFile("#{buildDirectoryPath}qttools/src/linguist/linguist/images/icons/linguist-128-32.png","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps/linguist-#{@@qtName}.png")

            linguistData = <<-CODE
            [Desktop Entry]
            Name=Qt5 Linguist
            Comment=Add translations to Qt5 applications
            Exec=/usr/#{@@qtName}/bin/linguist
            Icon=linguist-#{@@qtName}.png
            MimeType=text/vnd.trolltech.linguist;application/x-linguist;
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/linguist-#{@@qtName}.desktop",linguistData)
        else
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/linguist")
        end

        if option("Qdbusviewer")
            copyFile("#{buildDirectoryPath}qttools/src/qdbus/qdbusviewer/images/qdbusviewer-128.png","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps/qdbusviewer-#{@@qtName}.png")

            qdbusviewerData = <<-CODE
            [Desktop Entry]
            Name=Qt5 QDbusViewer
            GenericName=D-Bus Debugger
            Comment=Debug D-Bus applications
            Exec=/usr/#{@@qtName}/bin/qdbusviewer
            Icon=qdbusviewer-#{@@qtName}.png
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;Debugger;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/qdbusviewer-#{@@qtName}.desktop",qdbusviewerData)
        else
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/qdbusviewer")
        end

        if File.exists?("#{Ism.settings.rootPath}etc/profile.d/qt.sh")
            copyFile(   "/etc/profile.d/qt.sh",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/qt.sh")
        else
            generateEmptyFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/qt.sh")
        end

        qtData = <<-CODE
        QT5DIR=/usr
        export QT5DIR
        pathappend $QT5DIR/bin
        pathappend /usr/lib/#{@@qtName}/plugins QT_PLUGIN_PATH
        pathappend $QT5DIR/lib/plugins QT_PLUGIN_PATH
        pathappend /usr/lib/#{@@qtName}/qml QML2_IMPORT_PATH
        pathappend $QT5DIR/lib/qml QML2_IMPORT_PATH
        CODE
        fileUpdateContent("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/qt.sh",qtData)

        makeLink(   target: "moc",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/moc-#{@@qtName}",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target: "uic",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/uic-#{@@qtName}",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target: "rcc",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/rcc-#{@@qtName}",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target: "qmake",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/qmake-#{@@qtName}",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target:     "lconvert",
                    path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/lconvert-#{@@qtName}",
                    type:    :symbolicLinkByOverwrite)

        makeLink(   target:     "lrelease",
                    path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/lrelease-#{@@qtName}",
                    type:    :symbolicLinkByOverwrite)

        makeLink(   target:     "lupdate",
                    path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/lupdate-#{@@qtName}",
                    type:    :symbolicLinkByOverwrite)

        if isGreatestVersion
            Dir.glob(["#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/#{@@qtName}/**/*"], match: :dot_files).each do |filePath|

                fileName = filePath.lchop(directoryPath[0..filePath.rindex("/")])

                makeLink(   target: "/usr/bin/#{@@qtName}/#{fileName}",
                            path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/#{fileName}",
                            type:   :symbolicLinkByOverwrite)

            end
        end
    end

    def install
        super

        runChmodCommand("0755 /usr/share/pixmaps")
        runChmodCommand("0755 /usr/share/applications")

        if option("Assistant")
            runChmodCommand("0755 /usr/share/pixmaps/assistant-#{@@qtName}.png")
        end

        if option("Designer")
            runChmodCommand("0755 /usr/share/pixmaps/designer-#{@@qtName}.png")
        end

        if option("Linguist")
            runChmodCommand("0755 /usr/share/pixmaps/linguist-#{@@qtName}.png")
        end

        if option("Qdbusviewer")
            runChmodCommand("0755 /usr/share/pixmaps/qdbusviewer-#{@@qtName}.png")
        end

        runLdconfigCommand
    end

end
