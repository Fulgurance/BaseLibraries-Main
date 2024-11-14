class Target < ISM::Software
    
    def configure
        super

        configureSource(arguments:  "--prefix=/usr                                                  \
                                    --archdatadir=/usr/lib/qt#{majorVersion}                        \
                                    --bindir=/usr/bin/qt#{majorVersion}                             \
                                    --plugindir=/usr/lib/qt#{majorVersion}/plugins                  \
                                    --headerdir=/usr/include/qt#{majorVersion}                      \
                                    --datadir=/usr/share/qt#{majorVersion}                          \
                                    --docdir=/usr/share/doc/qt#{majorVersion}                       \
                                    --translationdir=/usr/share/qt#{majorVersion}/translations      \
                                    --sysconfdir=/etc/xdg                                           \
                                    #{option("Dbus") ? "--dbus-linked" : ""}                        \
                                    #{option("Openssl") ? "--openssl-linked" : ""}                  \
                                    #{option("Harfbuzz") ? "--harfbuzz=system" : "--harfbuzz=no"}   \
                                    #{option("Sqlite") ? "--sqlite=system" : "--sqlite=qt"}         \
                                    #{option("Xcb") ? "-xcb" : ""}                                  \
                                    #{option("Cups") ? "-cups" : ""}                                \
                                    --nomake=examples                                               \
                                    --no-rpath                                                      \
                                    --syslog                                                        \
                                    -skip qt3d                                                      \
                                    -skip qtquick3dphysics                                          \
                                    -skip qtwebengine                                               \
                                    -W no-dev",
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

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/")

        if option("Assistant")
            copyFile(   "#{buildDirectoryPath}qttools/src/assistant/assistant/images/assistant-128.png",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps/assistant-qt#{majorVersion}.png")

            assistantData = <<-CODE
            [Desktop Entry]
            Name=Qt6 Assistant
            Comment=Shows Qt6 documentation and examples
            Exec=/usr/qt#{majorVersion}/bin/assistant
            Icon=assistant-qt#{majorVersion}.png
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;Documentation;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/assistant-qt#{majorVersion}.desktop",assistantData)
        else
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/assistant")
        end

        if option("Designer")
            copyFile("#{buildDirectoryPath}qttools/src/designer/src/designer/images/designer.png","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps/designer-qt#{majorVersion}.png")

            designerData = <<-CODE
            [Desktop Entry]
            Name=Qt6 Designer
            GenericName=Interface Designer
            Comment=Design GUIs for Qt6 applications
            Exec=/usr/qt#{majorVersion}/bin/designer
            Icon=designer-qt#{majorVersion}.png
            MimeType=application/x-designer;
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/designer-qt#{majorVersion}.desktop",designerData)
        else
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/designer")
        end

        if option("Linguist")
            copyFile("#{buildDirectoryPath}qttools/src/linguist/linguist/images/icons/linguist-128-32.png","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps/linguist-qt#{majorVersion}.png")

            linguistData = <<-CODE
            [Desktop Entry]
            Name=Qt6 Linguist
            Comment=Add translations to Qt6 applications
            Exec=/usr/qt#{majorVersion}/bin/linguist
            Icon=linguist-qt#{majorVersion}.png
            MimeType=text/vnd.trolltech.linguist;application/x-linguist;
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/linguist-qt#{majorVersion}.desktop",linguistData)
        else
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/linguist")
        end

        if option("Qdbusviewer")
            copyFile("#{buildDirectoryPath}qttools/src/qdbus/qdbusviewer/images/qdbusviewer-128.png","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps/qdbusviewer-qt#{majorVersion}.png")

            qdbusviewerData = <<-CODE
            [Desktop Entry]
            Name=Qt6 QDbusViewer
            GenericName=D-Bus Debugger
            Comment=Debug D-Bus applications
            Exec=/usr/qt#{majorVersion}/bin/qdbusviewer
            Icon=qdbusviewer-qt#{majorVersion}.png
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;Debugger;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/qdbusviewer-qt#{majorVersion}.desktop",qdbusviewerData)
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
        QT6DIR=/usr
        export QT6DIR
        pathappend $QT6DIR/bin
        pathappend /usr/lib/qt#{majorVersion}/plugins QT_PLUGIN_PATH
        pathappend $QT6DIR/lib/plugins QT_PLUGIN_PATH
        pathappend /usr/lib/qt#{majorVersion}/qml QML2_IMPORT_PATH
        pathappend $QT6DIR/lib/qml QML2_IMPORT_PATH
        CODE
        fileUpdateContent("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/qt.sh",qtData)

        makeLink(   target: "moc",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/moc-qt#{majorVersion}",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target: "uic",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/uic-qt#{majorVersion}",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target: "rcc",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/rcc-qt#{majorVersion}",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target: "qmake",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/qmake-qt#{majorVersion}",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target:     "lconvert",
                    path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/lconvert-qt#{majorVersion}",
                    type:    :symbolicLinkByOverwrite)

        makeLink(   target:     "lrelease",
                    path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/lrelease-qt#{majorVersion}",
                    type:    :symbolicLinkByOverwrite)

        makeLink(   target:     "lupdate",
                    path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/lupdate-qt#{majorVersion}",
                    type:    :symbolicLinkByOverwrite)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin")

        if isGreatestVersion
            directoryContent("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/qt#{majorVersion}", matchHidden: true).each do |filePath|

                fileName = filePath.lchop(filePath[0..filePath.rindex("/")])

                makeLink(   target: "/usr/bin/qt#{majorVersion}/#{fileName}",
                            path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/#{fileName}",
                            type:   :symbolicLinkByOverwrite)

            end
        end
    end

    def install
        super

        runChmodCommand("0755 /usr/share/pixmaps")
        runChmodCommand("0755 /usr/share/applications")

        if option("Assistant")
            runChmodCommand("0755 /usr/share/pixmaps/assistant-qt#{majorVersion}.png")
        end

        if option("Designer")
            runChmodCommand("0755 /usr/share/pixmaps/designer-qt#{majorVersion}.png")
        end

        if option("Linguist")
            runChmodCommand("0755 /usr/share/pixmaps/linguist-qt#{majorVersion}.png")
        end

        if option("Qdbusviewer")
            runChmodCommand("0755 /usr/share/pixmaps/qdbusviewer-qt#{majorVersion}.png")
        end

        runLdconfigCommand
    end

end
