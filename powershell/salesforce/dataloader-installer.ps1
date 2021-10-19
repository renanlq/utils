# Documentação: https://help.salesforce.com/articleView?id=loader_install_windows.htm&type=0
# Passos:
# 1. Install Zulu OpenJDK version 11 for Windows using the .MSI file.
# 2. From Setup, download the Data Loader installation file.
# 3. Right-click the .zip file and select Extract All.
# 4. In the Data Loader folder, double-click the install.bat file. If you get an unknown publisher error message, 
#    you can ignore it and run the file.
# 5. Specify where to install Data Loader, and select whether to overwrite an existing Data Loader installation.
# 6. Specify whether to create a Data Loader launch icon on your desktop or a start menu shortcut. 
#    Data Loader completes the installation.

$dataloaderfolder = "$($env:USERPROFILE)\dataloader"
$dataloaderinstaller = "C:\instalador\install.bat"
$dataloaderexe = "$($dataloaderfolder)\dataloader-46.0.0-uber.jar"
$dataloaderurldownload = "https://[company].my.salesforce.com/dwnld/DataLoader/dataloader_win.zip"
# ATENÇÃO PARA ATUALIZAÇôES DO ZULU !!!
$zuluurldownload = "https://cdn.azul.com/zulu/bin/zulu8.40.0.25-ca-jdk8.0.222-win_x64.msi"
$zulufile = "zulu8_x64.msi"

Try {

    Write-Host "$(Get-Date) - Acessando pasta de instalacao"
    If(-Not (Test-Path -Path $dataloaderfolder)) {
        New-Item -ItemType Directory -Force -Path $dataloaderfolder
    }
    cd $dataloaderfolder
    
    If(-Not (Test-Path $zulufile -PathType Leaf)) {
        Write-Host "$(Get-Date) - Download do instalador do Zulu OpenJDK (.msi)"
        $output = $zulufile
        $starttime = Get-Date
        Invoke-WebRequest -Uri $zuluurldownload -OutFile $output
        Write-Host "$(Get-Date) - Time taken: $((Get-Date).Subtract($starttime).Seconds) segundo(s)"
    }

    Write-Host "$(Get-Date) - Iniciando instalador Zulu OpenJDK"
    Start-Process $zulufile -Wait

    Write-Host "$(Get-Date) - Iniciando instalador Data Loader"
    Start-Process $dataloaderinstaller -Wait

    Write-Host "$(Get-Date) - Iniciando Data Loader"
    Start-Process $dataloaderexe

}
Catch {
    $formatstring = "{0} : {1}`n{2}`n" +
                    "    + CategoryInfo          : {3}`n" +
                    "    + FullyQualifiedErrorId : {4}`n"
    $fields = $_.InvocationInfo.MyCommand.Name, $_.ErrorDetails.Message,
            $_.InvocationInfo.PositionMessage, $_.CategoryInfo.ToString(),
            $_.FullyQualifiedErrorId

    Write-Host -Foreground Red ($formatstring -f $fields)
    Break
}
Finally {
    Write-Host -Foreground Green -Background Black "$(Get-Date) - End of the script."
}
