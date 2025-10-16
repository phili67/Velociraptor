#
# Script : permettant � partir d'un ficher siecle ou sconet de faire une extraction direct vers la cr�ation des �l�ves
# utilisation : ./globalInstall.ps1 ElevesSansAdresses.xml
# Note :         vous pourrez bien entendu sp�cifi� le fichier XML que vous voulez
#


[string]$scriptPath # permet de conna�tre la place du script
# nous r�cup�rons le path du logiciel
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$the_file = $args[0]

$file=Get-Item "$scriptPath\$the_file"

$exec = "./Velociraptor.ps1"

$fileUsersTemp = "$scriptPath\temp\db.txt"
$fileUsersDataBase = "$scriptPath\data_base\db_old.txt"
    
Write-Host "$exec"

#Write-Host $file

write-host $file.Name
$ext = $file.Extension

# nous testons l'import en priort�
if (($args.count �eq 1) -and ($ext -eq ".xml"))
{
    # demande s'il y a des modifications � faire sur la configuration de VLCR
    Invoke-Expression "./Velociraptor.ps1 -r"
    
    #extraction de sconet
    Invoke-Expression "./Velociraptor.ps1 -x '$scriptPath\$the_file'"
    
    # on cr�� l'environnement
    Invoke-Expression "./Velociraptor.ps1 -c"
    # on installe l'environnement
        ."$scriptPath\Creation environnement\create_OU.ps1"
        ."$scriptPath\Creation environnement\create_Group.ps1"
        ."$scriptPath\Creation environnement\create_arborescence.ps1"

    # on extrait les eleves : dans eleves.txt
    Invoke-Expression "./Velociraptor.ps1 -e 'eleves.txt'"
        # on installe les eleves
        ."$scriptPath\Creation eleves\create_eleves.ps1"        

        if (Test-path $fileUsersTemp)
        {
            move-item -force $fileUsersTemp  $fileUsersDataBase
        }

        ."$scriptPath\Creation eleves\purgeEleves.ps1"
    
    # on cherche � voir si il y a une incoh�rence BDD et fichier sconet
    Invoke-Expression "./Velociraptor.ps1 -i"
}
else
{
    Write-Host "utilisation : ./globalInstall.ps1 ElevesSansAdresses.xml"
}