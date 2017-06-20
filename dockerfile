FROM microsoft/aspnet

MAINTAINER me@ryanmcdonough.co.uk

ADD *.ps1 ./

RUN powershell.exe c:\Setup-IIS.ps1

RUN powershell.exe c:\Get-UmbracoCMS.ps1

# configure the new site in
RUN powershell -NoProfile -Command \
    Import-module IISAdministration; \
    New-IISSite -Name "cms.umbraco.local" -PhysicalPath "C:\app" -BindingInformation "*:8080:" 

# This instruction tells the container to listen on port 8080. 
EXPOSE 8080
