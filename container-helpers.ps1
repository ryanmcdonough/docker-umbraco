. $PSScriptRoot\common.ps1
. $PSScriptRoot\hosts.ps1

function Get-ContainerIPAddress([string]$ContainerName = $ContainerName, [int]$HttpPort = ${HttpPort})
{
    $WebIPAddress = docker inspect -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" $ContainerName

    if ($WebIPAddress -ne $null) {

        $WebsiteUrl = "http://${WebIPAddress}:${HttpPort}/"

        if ((Invoke-WebRequest -Uri $WebsiteUrl).StatusCode -eq 200) {

            Write-Information -MessageData "Success: Umbraco CMS available - $WebsiteUrl"
            return $WebIPAddress
        }
        else {
            
            Write-Error -Message "Failed: Umbraco CMS not available"
        }
    }
    else {

        Write-Error -Message "Failed: to locate {{ .NetworkSettings.Networks.nat.IPAddress }} for container $ContainerName"    
    }
}

function New-DockerImage([string]$ImageName = $ImageName, [string]$ContainerName = $ContainerName)
{
    Write-Verbose -Message "Building Docker image with tag $ImageName as container $ContainerName"
    docker build -t $ImageName $ContainerName
}

function Start-DockerImage([string]$ImageName = $ImageName, [string]$ContainerName = $ContainerName)
{
    Write-Verbose -Message "Running Docker image $ImageName as container $ContainerName"
    docker run -d -P --name $ContainerName $ImageName
}

function Set-HostEntry([string]$WebIPAddress, [string]$ContainerName = $ContainerName)
{
    Write-Verbose -Message "Adding a Host Entry for $ContainerName - IP Addresss $WebIPAddress"
    add-host $WebIPAddress $ContainerName
}

function Test-HostEntry([string]$ContainerName = $ContainerName)
{
    Write-Verbose -Message "Sending Ping request to $ContainerName"
    ping $ContainerName
}