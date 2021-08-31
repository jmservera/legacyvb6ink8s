# Legacy VB6 in Kubernetes - a PoC

This is a small PoC of a container that runs a VB6 code TCP server, to test how to move a legacy application to
K8s and how to manage the raw TCP traffic into it.

The main Dockerfile that runs the application is in the root of the project, and the VB6 code is in the `source` folder. The app is a very simple TCP server, that can be stopped sending a SHUTDOWN command through telnet.

In the `source` folder there is a `link.bat` file that will compile the VB6 code and create a `myapp.exe` file inside the ../app folder. You need the VB6 compiler installed on your machine.

Inside the [app](./app) folder you can find the compiled version of the code found in the `source` folder, along with some files needed to run a VB6 application, like the VBA6.dll, VB6.OLB, msvbvm60.dll and the MSWINSCK.OCX component, needed to run a simple TCP server in VB6.

You will also find some example Dockerfiles for running a simple telnet server in Windows, and installing the sql tools on a container, to test different things that you may need in a VB6 app. Take a look at the [extras](./extras) folder.

Inside the [aks](./aks) folder there are some yaml examples to run this container and to create a tcp ingress with kong to provide access to the service from outside.

> Remember that all this code is provided as is, without any warranty, and it is not intended to be used in production.