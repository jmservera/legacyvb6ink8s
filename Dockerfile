# escape=`

# Sample Dockerfile

# Indicates that the windowsservercore image will be used as the base image.
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Metadata indicating an image maintainer.
LABEL maintainer="juanma"

# RUN md c:\temp
# COPY .\vc_redist.x64.exe c:\temp\
# RUN c:\temp\vc_redist.x64.exe /install /quiet /log c:\temp\log.txt
# RUN reg add HKLM\Software\MyCo /v Data /t REG_BINARY /d FE340EAD

#RUN md C:\LIBS
#COPY .\vb6\scrrun.dll C:\LIBS\
#RUN regsvr32 /s C:\LIBS\scrrun.dll

RUN md c:\app

COPY .\app\* c:\app\


# Sets a command or process that will run each time a container is run from the new image.
WORKDIR C:\APP
CMD [ "myapp.exe","parameter1","parameter2" ]
