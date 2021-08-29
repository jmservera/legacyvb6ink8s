# escape=`
# Indicates that the windowsservercore image will be used as the base image.
FROM mcr.microsoft.com/windows/servercore:ltsc2019

LABEL maintainer="https://github.com/jmservera"                                         `
    org.opencontainers.image.authors="https://github.com/jmservera"                     `
    org.opencontainers.image.url="[pending]"                                            `
    org.opencontainers.image.title=SimpleTCP                                            `
    org.opencontainers.image.description="Windows container with the SimpleTCP services to test connectivity" `
    org.opencontainers.image.source="https://github.com/jmservera/vb6docker"     

RUN Dism /online /Enable-Feature /FeatureName:SimpleTCP /All
EXPOSE 7
EXPOSE 9
EXPOSE 13
EXPOSE 17
EXPOSE 19

# generates an infinite loop
CMD ["cmd","/c","ping","-t","localhost",">","NUL"]
