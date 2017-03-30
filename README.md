LuneOS Camera
==================

Camera application for LuneOS

Summary
-------
The LuneOS camera app, which will be the default camera app for the WebOS Ports LuneOS project.

Note: this app reuses some bits of Ubuntu's camera app: https://launchpad.net/camera-app (rev 683)

Usage with QtCreator
--------------------

In the Project properties, in the Run section:
 - set the executable to "qmlscene"
 - set the arguments to: qml/main.qml -I %{buildDir} -I %{sourceDir}/../luneos-components/modules -I %{sourceDir}/../luneos-components/test/imports
 - set the execution directory to %{sourceDir}

