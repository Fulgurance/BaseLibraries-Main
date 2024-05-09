class Target < ISM::Software

    def prepare
        super

        fileReplaceTextAtLineNumber("#{buildDirectoryPath(false)}qtlocation/src/3rdparty/mapbox-gl-native/include/mbgl/util/geometry.hpp","","#include <cstdint>\n",2)
        fileReplaceTextAtLineNumber("#{buildDirectoryPath(false)}qtlocation/src/3rdparty/mapbox-gl-native/include/mbgl/util/string.hpp","","#include <cstdint>\n",2)
        fileReplaceTextAtLineNumber("#{buildDirectoryPath(false)}qtlocation/src/3rdparty/mapbox-gl-native/src/mbgl/gl/stencil_mode.hpp","","#include <cstdint>\n",2)
    end
    
    def configure
        super

        configureSource([   "--prefix=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr",
                            "--archdatadir=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/qt5",
                            "--bindir=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin",
                            "--plugindir=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/qt5/plugins",
                            "--importdir=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/qt5/imports",
                            "--headerdir=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/include/qt5",
                            "--datadir=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/qt5",
                            "--docdir=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/qt5",
                            "--translationdir=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/qt5/translations",
                            "--sysconfdir=/etc/xdg",
                            "--confirm-license",
                            "--opensource",
                            option("Dbus") ? "--dbus-linked" : "",
                            option("Openssl") ? "--openssl-linked" : "",
                            option("Harfbuzz") ? "-system-harfbuzz" : "",
                            option("Sqlite") ? "-system-sqlite" : "",
                            option("Xcb") ? "-xcb" : "",
                            option("Cups") ? "-cups" : "",
                            "--nomake=examples",
                            "--no-rpath",
                            "--syslog",
                            "--skip=qtwebengine"],
                            buildDirectoryPath)
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["install"],buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/pixmaps")
        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/applications")
        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc")
        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/profile.d/")

        if option("Assistant")
            copyFile("#{buildDirectoryPath(false)}qttools/src/assistant/assistant/images/assistant-128.png","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/pixmaps/assistant-qt5.png")

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
            fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/applications/assistant-qt5.desktop",assistantData)
        else
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/assistant")
        end

        if option("Designer")
            copyFile("#{buildDirectoryPath(false)}qttools/src/designer/src/designer/images/designer.png","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/pixmaps/designer-qt5.png")

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
            fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/applications/designer-qt5.desktop",designerData)
        else
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/designer")
        end

        if option("Linguist")
            copyFile("#{buildDirectoryPath(false)}qttools/src/linguist/linguist/images/icons/linguist-128-32.png","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/pixmaps/linguist-qt5.png")

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
            fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/applications/linguist-qt5.desktop",linguistData)
        else
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/linguist")
        end

        if option("Qdbusviewer")
            copyFile("#{buildDirectoryPath(false)}qttools/src/qdbus/qdbusviewer/images/qdbusviewer-128.png","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/pixmaps/qdbusviewer-qt5.png")

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
            fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/applications/qdbusviewer-qt5.desktop",qdbusviewerData)
        else
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/qdbusviewer")
        end

        qt5ShData = <<-CODE
        QT5DIR=/usr
        export QT5DIR
        pathappend $QT5DIR/bin
        pathappend /usr/lib/qt5/plugins QT_PLUGIN_PATH
        pathappend $QT5DIR/lib/plugins QT_PLUGIN_PATH
        pathappend /usr/lib/qt5/qml QML2_IMPORT_PATH
        pathappend $QT5DIR/lib/qml QML2_IMPORT_PATH
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/profile.d/qt5.sh",qt5ShData)

        makeLink("moc","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/moc-qt5",:symbolicLinkByOverwrite)
        makeLink("uic","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/uic-qt5",:symbolicLinkByOverwrite)
        makeLink("rcc","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/rcc-qt5",:symbolicLinkByOverwrite)
        makeLink("qmake","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/qmake-qt5",:symbolicLinkByOverwrite)
        makeLink("lconvert","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/lconvert-qt5",:symbolicLinkByOverwrite)
        makeLink("lrelease","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/lrelease-qt5",:symbolicLinkByOverwrite)
        makeLink("lupdate","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/lupdate-qt5",:symbolicLinkByOverwrite)
    end

    def install
        super

        setPermissions("#{Ism.settings.rootPath}usr/share/pixmaps",0o755)
        setPermissions("#{Ism.settings.rootPath}usr/share/applications",0o755)

        if option("Assistant")
            setPermissions("#{Ism.settings.rootPath}usr/share/pixmaps/assistant-qt5.png",0o755)
        end

        if option("Designer")
            setPermissions("#{Ism.settings.rootPath}usr/share/pixmaps/designer-qt5.png",0o755)
        end

        if option("Linguist")
            setPermissions("#{Ism.settings.rootPath}usr/share/pixmaps/linguist-qt5.png",0o755)
        end

        if option("Qdbusviewer")
            setPermissions("#{Ism.settings.rootPath}usr/share/pixmaps/qdbusviewer-qt5.png",0o755)
        end

        runLdconfigCommand
    end

end
