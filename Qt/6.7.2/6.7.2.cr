class Target < ISM::Software
    
    def configure
        super

        configureSource(arguments:  "--prefix=/usr                                  \
                                    --archdatadir=/usr/lib/qt6                      \
                                    --bindir=/usr/bin                               \
                                    --plugindir=/usr/lib/qt6/plugins                \
                                    --importdir=/usr/lib/qt6/imports                \
                                    --headerdir=/usr/include/qt6                    \
                                    --datadir=/usr/share/qt6                        \
                                    --docdir=/usr/share/doc/qt6                     \
                                    --translationdir=/usr/share/qt6/translations    \
                                    --sysconfdir=/etc/xdg                           \
                                    #{option("Dbus") ? "--dbus-linked" : ""}        \
                                    #{option("Openssl") ? "--openssl-linked" : ""}  \
                                    #{option("Harfbuzz") ? "-system-harfbuzz" : ""} \
                                    #{option("Sqlite") ? "-system-sqlite" : ""}     \
                                    #{option("Xcb") ? "-xcb" : ""}                  \
                                    #{option("Cups") ? "-cups" : ""}                \
                                    --nomake=examples                               \
                                    --no-rpath                                      \
                                    --syslog                                        \
                                    --skip=qt3d                                     \
                                    --skip=qtquick3dphysics                         \
                                    --skip=qtwebengine                              \
                                    -W no-dev"),
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
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps/assistant-qt6.png")

            assistantData = <<-CODE
            [Desktop Entry]
            Name=Qt6 Assistant
            Comment=Shows Qt6 documentation and examples
            Exec=/usr/qt6/bin/assistant
            Icon=assistant-qt6.png
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;Documentation;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/assistant-qt6.desktop",assistantData)
        else
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/assistant")
        end

        if option("Designer")
            copyFile("#{buildDirectoryPath}qttools/src/designer/src/designer/images/designer.png","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps/designer-qt6.png")

            designerData = <<-CODE
            [Desktop Entry]
            Name=Qt6 Designer
            GenericName=Interface Designer
            Comment=Design GUIs for Qt6 applications
            Exec=/usr/qt6/bin/designer
            Icon=designer-qt6.png
            MimeType=application/x-designer;
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/designer-qt6.desktop",designerData)
        else
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/designer")
        end

        if option("Linguist")
            copyFile("#{buildDirectoryPath}qttools/src/linguist/linguist/images/icons/linguist-128-32.png","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps/linguist-qt6.png")

            linguistData = <<-CODE
            [Desktop Entry]
            Name=Qt6 Linguist
            Comment=Add translations to Qt6 applications
            Exec=/usr/qt6/bin/linguist
            Icon=linguist-qt6.png
            MimeType=text/vnd.trolltech.linguist;application/x-linguist;
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/linguist-qt6.desktop",linguistData)
        else
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/linguist")
        end

        if option("Qdbusviewer")
            copyFile("#{buildDirectoryPath}qttools/src/qdbus/qdbusviewer/images/qdbusviewer-128.png","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps/qdbusviewer-qt6.png")

            qdbusviewerData = <<-CODE
            [Desktop Entry]
            Name=Qt6 QDbusViewer
            GenericName=D-Bus Debugger
            Comment=Debug D-Bus applications
            Exec=/usr/qt6/bin/qdbusviewer
            Icon=qdbusviewer-qt6.png
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;Debugger;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/qdbusviewer-qt6.desktop",qdbusviewerData)
        else
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/qdbusviewer")
        end

        qt6ShData = <<-CODE
        QT6DIR=/usr
        export QT6DIR
        pathappend $QT6DIR/bin
        pathappend /usr/lib/qt6/plugins QT_PLUGIN_PATH
        pathappend $QT6DIR/lib/plugins QT_PLUGIN_PATH
        pathappend /usr/lib/qt6/qml QML2_IMPORT_PATH
        pathappend $QT6DIR/lib/qml QML2_IMPORT_PATH
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/qt6.sh",qt6ShData)

        makeLink(   target: "moc",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/moc-qt6",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target: "uic",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/uic-qt6",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target: "rcc",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/rcc-qt6",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target: "qmake",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/qmake-qt6",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target:     "lconvert",
                    path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/lconvert-qt6",
                    type:    :symbolicLinkByOverwrite)

        makeLink(   target:     "lrelease",
                    path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/lrelease-qt6",
                    type:    :symbolicLinkByOverwrite)

        makeLink(   target:     "lupdate",
                    path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/lupdate-qt6",
                    type:    :symbolicLinkByOverwrite)

        exit
    end

    def install
        super

        runChmodCommand("0755 /usr/share/pixmaps")
        runChmodCommand("0755 /usr/share/applications")

        if option("Assistant")
            runChmodCommand("0755 /usr/share/pixmaps/assistant-qt6.png")
        end

        if option("Designer")
            runChmodCommand("0755 /usr/share/pixmaps/designer-qt6.png")
        end

        if option("Linguist")
            runChmodCommand("0755 /usr/share/pixmaps/linguist-qt6.png")
        end

        if option("Qdbusviewer")
            runChmodCommand("0755 /usr/share/pixmaps/qdbusviewer-qt6.png")
        end

        runLdconfigCommand
    end

end
