# VB6 Server example app

This small example creates a VB6 TCP Server using the `MSWinsockLib.Winsock` class. This code is for demonstration purposes only, and is not intended to be used in production.

As it is meant to be run inside a docker container, the [link.bat](./link.bat) file calls the VB6 compiler to create the `.exe` file and then modifies the executable to run as a console application.

You need a VB6 compiler installed on your system to run this example, or you can use a VB6 Ide Docker container, like the one created by [Ro-Fo](https://github.com/Ro-Fo/Vb6IdeDocker), to compile your software.

For your convenience, the app found in this folder is already compiled under the [app](./../app) folder.