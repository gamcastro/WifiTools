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
        Start-Sleep -Seconds 3
        $wifiinfo = netsh WLAN show interface Wi-Fi 
        
        
       try{
            $canal = ($wifiinfo | Select-String -Pattern 'Canal').Line
            $canal = $canal.Substring($canal.Length - 2,2).Trim()
    
            $estado = ($wifiinfo | Select-String -Patter 'Estado').Line        
            $estado = $estado.Substring(($estado.IndexOf(':') + 1),($estado.Length - $estado.IndexOf(':'))-1).Trim()
    
            $sinal = ($wifiinfo | Select-String -Pattern 'Sinal').Line
            $sinal = $sinal.Substring(($sinal.IndexOf(':') + 1),($sinal.Length - $sinal.IndexOf(':'))-1).Trim()
    
            $descricao = ($wifiinfo | Select-String -Pattern 'Descr').Line
                       $descricao = $descricao.Substring(($descricao.IndexOf(':') + 1),($descricao.Length - $descricao.IndexOf(':'))-1).Trim()
    
            $props = @{'Adaptador' = $descricao
                      'Canal'=$canal
                       'Estado'=$estado
                        'Sinal'=$sinal}
    
            $obj = New-Object -TypeName psobject -Property $props
            Write-Output $obj
        }
       catch {
           Write-Warning "Erro ao obter informacoes sobre o adaptador wifi"
        }

       

    }
    END{}
}