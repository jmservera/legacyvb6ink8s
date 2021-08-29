# escape=`
# Indicates that the windowsservercore image will be used as the base image.
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Metadata indicating an image maintainer.
LABEL maintainer="https://github.com/jmservera"                                         `
    org.opencontainers.image.authors="https://github.com/jmservera"                     `
    org.opencontainers.image.url="[pending]"                                            `
    org.opencontainers.image.title=sqltools                                             `
    org.opencontainers.image.description="Windows container with the MsSQLCmdLn Utils"  `
    org.opencontainers.image.source="https://github.com/jmservera/vb6docker"         

ADD https://aka.ms/vs/16/release/vc_redist.x64.exe c:\temp\vc_redist.x64.exe
ADD https://go.microsoft.com/fwlink/?linkid=2156851 c:\temp\msodbcsql.msi
ADD https://go.microsoft.com/fwlink/?linkid=2142258 c:\temp\MsSqlCmdLnUtils.msi
RUN c:\temp\vc_redist.x64.exe /install /quiet /log c:\temp\log.txt
RUN msiexec /i c:\temp\msodbcsql.msi /passive /qn /log c:\temp\sqlodbc.txt IACCEPTMSODBCSQLLICENSETERMS=YES
RUN msiexec /i c:\temp\MsSqlCmdLnUtils.msi /passive /qn /log c:\temp\sqlcmd4.txt IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES
RUN SETX /M PATH "%PATH%;C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn"

CMD ["cmd"]
