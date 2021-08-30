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

# prometheus exporter
RUN powershell -Command `
    Invoke-WebRequest -Method Get -Uri https://github.com/prometheus-community/windows_exporter/releases/download/v0.16.0/windows_exporter-0.16.0-amd64.msi -OutFile c:\windows_exporter.msi ; `
    start-Process c:\windows_exporter.msi -ArgumentList '/qn' -Wait ; `
    Remove-Item c:\windows_exporter.msi -Force ;

EXPOSE 9090
COPY .\app\* c:\app\

CMD ["myapp.exe"]