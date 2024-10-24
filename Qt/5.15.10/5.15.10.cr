class Target < ISM::Software
    
    def configure
        super

        configureSource(arguments:  "--prefix=/usr                                  \
                                    --archdatadir=/usr/lib/qt5                      \
                                    --bindir=/usr/bin                               \
                                    --plugindir=/usr/lib/qt5/plugins                \
                                    --importdir=/usr/lib/qt5/imports                \
                                    --headerdir=/usr/include/qt5                    \
                                    --datadir=/usr/share/qt5                        \
                                    --docdir=/usr/share/doc/qt5                     \
                                    --translationdir=/usr/share/qt5/translations    \
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
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps/assistant-qt5.png")

            assistantData = <<-CODE
            [Desktop Entry]
            Name=Qt5 Assistant
            Comment=Shows Qt5 documentation and examples
            Exec=/usr/qt5/bin/assistant
            Icon=assistant-qt5.png
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;Documentation;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/assistant-qt5.desktop",assistantData)
        else
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/assistant")
        end

        if option("Designer")
            copyFile("#{buildDirectoryPath}qttools/src/designer/src/designer/images/designer.png","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps/designer-qt5.png")

            designerData = <<-CODE
            [Desktop Entry]
            Name=Qt5 Designer
            GenericName=Interface Designer
            Comment=Design GUIs for Qt5 applications
            Exec=/usr/qt5/bin/designer
            Icon=designer-qt5.png
            MimeType=application/x-designer;
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/designer-qt5.desktop",designerData)
        else
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/designer")
        end

        if option("Linguist")
            copyFile("#{buildDirectoryPath}qttools/src/linguist/linguist/images/icons/linguist-128-32.png","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps/linguist-qt5.png")

            linguistData = <<-CODE
            [Desktop Entry]
            Name=Qt5 Linguist
            Comment=Add translations to Qt5 applications
            Exec=/usr/qt5/bin/linguist
            Icon=linguist-qt5.png
            MimeType=text/vnd.trolltech.linguist;application/x-linguist;
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/linguist-qt5.desktop",linguistData)
        else
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/linguist")
        end

        if option("Qdbusviewer")
            copyFile("#{buildDirectoryPath}qttools/src/qdbus/qdbusviewer/images/qdbusviewer-128.png","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps/qdbusviewer-qt5.png")

            qdbusviewerData = <<-CODE
            [Desktop Entry]
            Name=Qt5 QDbusViewer
            GenericName=D-Bus Debugger
            Comment=Debug D-Bus applications
            Exec=/usr/qt5/bin/qdbusviewer
            Icon=qdbusviewer-qt5.png
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;Debugger;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/qdbusviewer-qt5.desktop",qdbusviewerData)
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
        pathappend /usr/lib/qt5/plugins QT_PLUGIN_PATH
        pathappend $QT5DIR/lib/plugins QT_PLUGIN_PATH
        pathappend /usr/lib/qt5/qml QML2_IMPORT_PATH
        pathappend $QT5DIR/lib/qml QML2_IMPORT_PATH
        CODE
        fileUpdateContent("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/qt.sh",qtData)

        makeLink(   target: "moc",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/moc-qt5",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target: "uic",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/uic-qt5",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target: "rcc",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/rcc-qt5",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target: "qmake",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/qmake-qt5",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target:     "lconvert",
                    path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/lconvert-qt5",
                    type:    :symbolicLinkByOverwrite)

        makeLink(   target:     "lrelease",
                    path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/lrelease-qt5",
                    type:    :symbolicLinkByOverwrite)

        makeLink(   target:     "lupdate",
                    path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/lupdate-qt5",
                    type:    :symbolicLinkByOverwrite)
    end

    def install
        super

        runChmodCommand("0755 /usr/share/pixmaps")
        runChmodCommand("0755 /usr/share/applications")

        if option("Assistant")
            runChmodCommand("0755 /usr/share/pixmaps/assistant-qt5.png")
        end

        if option("Designer")
            runChmodCommand("0755 /usr/share/pixmaps/designer-qt5.png")
        end

        if option("Linguist")
            runChmodCommand("0755 /usr/share/pixmaps/linguist-qt5.png")
        end

        if option("Qdbusviewer")
            runChmodCommand("0755 /usr/share/pixmaps/qdbusviewer-qt5.png")
        end

        runLdconfigCommand
    end

end
