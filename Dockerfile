# escape=`

# Indicates that the windowsservercore image will be used as the base image.
FROM mcr.microsoft.com/windows/servercore:ltsc2019
LABEL maintainer="https://github.com/jmservera"                                         `
    org.opencontainers.image.authors="https://github.com/jmservera"                     `
    org.opencontainers.image.url="[pending]"                                            `
    org.opencontainers.image.title=sqltools                                             `
    org.opencontainers.image.description="Windows container with a small VB6 PoC"  `
    org.opencontainers.image.source="https://github.com/jmservera/vb6docker" 

RUN md c:\app
WORKDIR c:\app

COPY .\app\MSWINSCK.OCX C:\APP
RUN regsvr32 /s c:\app\MSWINSCK.OCX

RUN md c:\temp
# prometheus exporter
RUN powershell -Command `
    Invoke-WebRequest -Method Get -Uri https://github.com/prometheus-community/windows_exporter/releases/download/v0.16.0/windows_exporter-0.16.0-amd64.msi -OutFile c:\windows_exporter.msi ; `
    start-Process msiexec -ArgumentList '/i c:\\windows_exporter.msi /passive /qn /log c:\\temp\\windows_exporter-install.txt ' -Wait ; `
    Remove-Item c:\windows_exporter.msi -Force ;

RUN md c:\grok

RUN powershell -Command `
    Invoke-WebRequest -Method Get -Uri https://github.com/fstab/grok_exporter/releases/download/v1.0.0.RC5/grok_exporter-1.0.0.RC5.windows-amd64.zip -OutFile c:\grok_exporter.zip ; `
    Expand-Archive 'c:\grok_exporter.zip' -DestinationPath c:\temp ; `
    Copy-Item c:\temp\grok_exporter-1.0.0.RC5.windows-amd64\*  -Destination c:\grok\ -Recurse ; `
    Remove-Item c:\temp\grok_exporter-1.0.0.RC5.windows-amd64 -Recurse -Force ; `
    Remove-Item c:\grok_exporter.zip -Force ;

# app port
EXPOSE 9001
# windows exporter
EXPOSE 9182 
# grok exporter
EXPOSE 9144

COPY .\app\* c:\app\

CMD ["start.bat"]