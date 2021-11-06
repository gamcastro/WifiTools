function Restart-WifiAdapter {
    <#
    .SYNOPSIS
    Ferramenta para resetar o estado do adaptador wifi

    .DESCRIPTION
    Ferramenta para resetar o adaptador wifi e conecta-lo a uma rede SSID

    .PARAMETER SSID
    Nome da rede wifi que se quer conectar

    .EXAMPLE
    Restart-WifiAdapter
    Esse comando ira resetar o adaptador wifi e conectar a rede wifi padrao

    #>
    [CmdletBinding()]
    param(
        [string]$SSID = 'Aparecida2.4G_extendida'
    )
    BEGIN{}
    PROCESS{
        Write-Verbose 'Desabilitando a conexão wifi'
        Disable-NetAdapter -Name "Wi-fi" -Confirm:$false

        Start-Sleep -Seconds 3

        Write-Verbose "Habilitando a conexão wifi de volta"
        Enable-NetAdapter -Name "Wi-fi"

        Start-Sleep -Seconds 3

        Write-Verbose "Conectando na rede wi-fi $SSID"
        Connect-WiFiProfile -ProfileName $SSID


    }
    END{}
}