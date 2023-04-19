class Target < ISM::Software

    def prepare
        super

        fileReplaceTextAtLineNumber("#{buildDirectoryPath(false)}qtbase/src/corelib/global/qglobal.h","#endif","#include <limits>\n#endif",48)
        fileReplaceTextAtLineNumber("#{buildDirectoryPath(false)}qtbase/src/corelib/global/qfloat16.h","","#include <limits>\n",47)
        fileReplaceTextAtLineNumber("#{buildDirectoryPath(false)}qtbase/src/corelib/text/qbytearraymatcher.h","","#include <limits>\n",44)
        fileReplaceTextAtLineNumber("#{buildDirectoryPath(false)}qtdeclarative/src/qmldebug/qqmlprofilerevent_p.h","","#include <limits>\n",52)
    end
    
    def configure
        super

        configureSource([   "-prefix /opt/qt5",
                            "-sysconfdir /etc/xdg",
                            "-confirm-license",
                            "-opensource",
                            "-dbus-linked",
                            "-openssl-linked",
                            "-system-harfbuzz",
                            "-system-sqlite",
                            "-nomake examples",
                            "-no-rpath",
                            "-syslog",
                            "-skip qtwebengine"],
                            buildDirectoryPath)
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        fileReplaceText(Dir["#{buildDirectoryPath(false)}opt/qt5/*.prl"],"QMAKE_PRL_BUILD_DIR","")

        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/pixmaps")
        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/applications")

        if option("Assistant")
            copyFile("#{buildDirectoryPath(false)}qttools/src/assistant/assistant/images/assistant-128.png","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/pixmaps/assistant-qt5.png")

            assistantData = <<-CODE
            [Desktop Entry]
            Name=Qt5 Assistant
            Comment=Shows Qt5 documentation and examples
            Exec=/opt/qt5/bin/assistant
            Icon=assistant-qt5.png
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;Documentation;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/applications/assistant-qt5.desktop",assistantData)
        else
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}opt/qt5/usr/bin/assistant")
        end

        if option("Designer")
            copyFile("#{buildDirectoryPath(false)}qttools/src/designer/src/designer/images/designer.png","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/pixmaps/designer-qt5.png")

            designerData = <<-CODE
            [Desktop Entry]
            Name=Qt5 Designer
            GenericName=Interface Designer
            Comment=Design GUIs for Qt5 applications
            Exec=/opt/qt5/bin/designer
            Icon=designer-qt5.png
            MimeType=application/x-designer;
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/applications/designer-qt5.desktop",designerData)
        else
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}opt/qt5/usr/bin/designer")
        end

        if option("Linguist")
            copyFile("#{buildDirectoryPath(false)}qttools/src/linguist/linguist/images/icons/linguist-128-32.png","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/pixmaps/linguist-qt5.png")

            linguistData = <<-CODE
            [Desktop Entry]
            Name=Qt5 Linguist
            Comment=Add translations to Qt5 applications
            Exec=/opt/qt5/bin/linguist
            Icon=linguist-qt5.png
            MimeType=text/vnd.trolltech.linguist;application/x-linguist;
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/applications/linguist-qt5.desktop",linguistData)
        else
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}opt/qt5/usr/bin/linguist")
        end

        if option("Qdbusviewer")
            copyFile("#{buildDirectoryPath(false)}qttools/src/qdbus/qdbusviewer/images/qdbusviewer-128.png","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/pixmaps/qdbusviewer-qt5.png")

            qdbusviewerData = <<-CODE
            [Desktop Entry]
            Name=Qt5 QDbusViewer
            GenericName=D-Bus Debugger
            Comment=Debug D-Bus applications
            Exec=/opt/qt5/bin/qdbusviewer
            Icon=qdbusviewer-qt5.png
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;Debugger;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/applications/qdbusviewer-qt5.desktop",qdbusviewerData)
        else
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}opt/qt5/usr/bin/qdbusviewer")
        end

        if softwareIsInstalled("Sudo")
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/sudoers.d")

            sudoData = <<-CODE
            Defaults env_keep += QT5DIR
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/sudoers.d/qt",sudoData)
        end

        if File.exists?("#{Ism.settings.rootPath}etc/ld.so.conf")
            copyFile("#{Ism.settings.rootPath}etc/ld.so.conf","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/ld.so.conf")
        else
            generateEmptyFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/ld.so.conf")
        end

        ldSoConfData = <<-CODE
        /opt/qt5/lib
        CODE
        fileUpdateContent("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/ld.so.conf",ldSoConfData)

        qt5ShData = <<-CODE
        QT5DIR=/opt/qt5
        pathappend $QT5DIR/bin           PATH
        pathappend $QT5DIR/lib/pkgconfig PKG_CONFIG_PATH
        export QT5DIR
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/profile.d/qt5.sh",qt5ShData)
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

        makeLink("#{Ism.settings.rootPath}opt/qt5/bin/moc","/usr/bin/moc-qt5",:symbolicLinkByOverwrite)
        makeLink("#{Ism.settings.rootPath}opt/qt5/bin/uic","/usr/bin/uic-qt5",:symbolicLinkByOverwrite)
        makeLink("#{Ism.settings.rootPath}opt/qt5/bin/rcc","/usr/bin/rcc-qt5",:symbolicLinkByOverwrite)
        makeLink("#{Ism.settings.rootPath}opt/qt5/bin/qmake","/usr/bin/qmake-qt5",:symbolicLinkByOverwrite)
        makeLink("#{Ism.settings.rootPath}opt/qt5/bin/lconvert","/usr/bin/lconvert-qt5",:symbolicLinkByOverwrite)
        makeLink("#{Ism.settings.rootPath}opt/qt5/bin/lrelease","/usr/bin/lrelease-qt5",:symbolicLinkByOverwrite)
        makeLink("#{Ism.settings.rootPath}opt/qt5/bin/lupdate","/usr/bin/lupdate-qt5",:symbolicLinkByOverwrite)

        runLdconfigCommand
    end

end
