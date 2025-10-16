#
# Created by Philippe Logel on 8/2/2014.
# Copyright 2014 "iMathGeo" & "Softwares". All rights reserved.
#


function create_param ([string]$thedomaine,[string]$theHomePath,[string]$theShareFolderPath,[string]$les_classes,$roaming,$quota1,$quota2,$quota3)
{

	$fileParam = ".\Velociraptor_Parametres\parametres.ps1"
	$param = ".\Velociraptor_Parametres\"
       
        if (-Not (Test-path $param))
        {
           md ".\Velociraptor_Parametres"
        }

	Write-output "#" > $fileParam
	Write-output "# Created by Philippe Logel on 8/2/2014." >> $fileParam
	Write-output "# Copyright 2014 `"iMathGeo`" & `"Softwares`". All rights reserved." >> $fileParam
	Write-output "#" >> $fileParam
	Write-output "" >> $fileParam
	Write-output "#" >> $fileParam
	Write-output "# voici toutes les classes" >> $fileParam
	Write-output "#" >> $fileParam
	Write-output "# Vous devez bien renseigner l'ensemble pour que cela marche !!!!" >> $fileParam
	Write-output "# ATTENTION : si les classes sont sous la forme : 2ND 1 vous écrirez 2ND1, pour 3eme A ou écrire 3EMEA" >> $fileParam
	Write-output "#             Cette partie est la plus délicate, aucune classe ne doit manquer !!!!" >> $fileParam
	Write-output "#" >> $fileParam
	Write-output "" >> $fileParam
	Write-output "`$classes           = @($les_classes)" >> $fileParam
	Write-output "" >> $fileParam  
	Write-output "" >> $fileParam
	Write-output "" >> $fileParam
	Write-output "# Profiles itinérants" >> $fileParam
	Write-output "`$roamingProfile    = $roaming" >> $fileParam
	Write-output "" >> $fileParam
	Write-output "# les variables de gestion du serveur" >> $fileParam
	Write-output "`$domaine           = `"$thedomaine`"" >> $fileParam
	Write-output "`$profilePath       = `"$theHomePath`""  >> $fileParam           # ATTENTION : un dossier de partage doit être créé"
	Write-output "`$shareFolders      = `"$theShareFolderPath`""  >> $fileParam           # ATTENTION : un dossier de partage doit être créé"
	Write-output "" >> $fileParam
	Write-output "# parametres comptes eleves quotas" >> $fileParam
	Write-output "`$quotaEleves       = $quota1" >> $fileParam
	Write-output "" >> $fileParam
	Write-output "# parametres comptes profs quotas" >> $fileParam
	Write-output "`$quotaProfesseurs  = $quota2" >> $fileParam
    Write-output "" >> $fileParam
	Write-output "# parametres comptes profs quotas" >> $fileParam
	Write-output "`$quotaViesco       = $quota3" >> $fileParam
    Write-output "" >> $fileParam
    Write-output "# Gestion des comptes" >> $fileParam
    Write-output "`$nbrEleves	   = $nbrEleves" >> $fileParam
    Write-output "`$nbrProfs	   = $nbrProfs" >> $fileParam
    Write-output "`$nbrViescos	   = $nbrViescos" >> $fileParam
    Write-output "" >> $fileParam
    Write-output "# Gestion des comptes à purger" >> $fileParam
    Write-output "`$nbrElevesPurge	   = $nbrElevesPurge" >> $fileParam
    Write-output "`$nbrProfsPurge	   = $nbrProfsPurge" >> $fileParam
    Write-output "`$nbrViescosPurge   = $nbrViescosPurge" >> $fileParam


    write-host ""  
	write-host ""
	write-host "  Le paramétrage de Velociraptor c'est bien passé"
    Write-Host "           Appuyer sur une touche pour continuer ..."
	write-host ""
	write-host ""

}

function parametrisation_VCL
{   
    [System.Console]::Clear()
         
 

    Write-Host ""
    Write-Host ""
    Write-Host "         Paramétrisation de Velociraptor version ($VLRversion)"
    Write-Host "        ---------------------------------------------"
    Write-Host "        © 2014 Philippe Logel `"iMathGeo`" & `"Softwares`""
    Write-Host "                     all rights reserved"

    Write-Host ""
    Write-Host ""
    Write-Host "  * Vous devrez dans un premier temps entrer le nom de domaine "
    write-Host "      de la forme : 0670081z.ac-strasbourg.fr"
    write-Host ""
    Write-Host "  Pour cela aller dans Utilisateurs et Groupes, puis regarder en sommet" 
    Write-Host "  d'arborescence de manière soigneuse cette information."
    Write-Host ""

    $thedomaine = Read-Host –Prompt ‘     Veuillez entrer le nom de domaine ’

    Write-Host ""
    Write-Host "  * Vous devrez saisir vos classes sous la forme : `"2ND1`", `"2ND2`", `"2ND3`""
    Write-Host "  ATTENTION : cette étapes est importantes, il ne faut pas en oublier de classes, à la fin ne pas mettre de virgules"
    Write-host "              Si une classe est de la forme : `"2nd 1`" l'écrire sous" 
    Write-host "              la forme `"2ND1`", vous devez donc l'écrire est en majuscule"
    write-Host ""
    Write-host "  Astuce : Faîtes l'ensemble dans le bloque note et coller le tout dans Powershell avec un clic droit"
    Write-Host ""

    $les_classes = Read-Host –Prompt ‘    Veuillez entrer les classes soigneusement ’

    Write-Host ""
    Write-Host "  * Vous devez créer votre dossier pour les profiles : \\nas1\home"
    write-Host ""
    
    $theHomePath = Read-Host –Prompt ‘Veuillez entrer le chemin du dossier de partage ’

    Write-Host ""
    Write-Host "  * Vous devez créer votre dossier de partage        : \\nas1\partages"
    write-Host ""
    
    $theShareFolderPath = Read-Host –Prompt ‘Veuillez entrer le chemin du dossier de partage ’

    Write-Host ""
    
    $r = Read-Host –Prompt ‘     Voulez-vous de profiles itinérants (o|n)?  ’

    switch ($r)
    {
	{ "o", "O" -contains $_ }{
		$roaming = 1
		break
	}
	default
	{
		$roaming = 0
	}
    }

    Write-Host ""
    Write-Host "  * Veuillez la valeur pour le quota par élève: "
    Write-Host ""
    
    $quota1 = Read-Host –Prompt ‘     Valeur du quota pour les élèves     ’

    Write-Host ""
    Write-Host "  * Veuillez la valeur pour le quota par professeur : "
    Write-Host ""
    
    $quota2 = Read-Host –Prompt ‘    Valeur du quota pour les professeurs ’
    
    Write-Host ""
    Write-Host "  * Veuillez la valeur pour le quota pour les utilisateurs de la viesco : "
    Write-Host ""
    
    $quota3 = Read-Host –Prompt ‘    Valeur du quota pour de la viesco    ’

    [System.Console]::Clear()
    Write-Host ""
    Write-Host "Voici un récapitulatif de vos parametres"
    Write-Host "----------------------------------------"
    Write-Host ""
    write-host "LISEZ ATTENTIVEMENT VOS INFORMATIONS SAISIES"
    Write-Host ""
    Write-Host " Le nom de domaine est     		: $theDomaine"
    Write-Host " Le dossier de partage est 		: $theHomePath"
    Write-Host " Vous utilisez des dossiers de partage 	: $theShareFolderPath"
    Write-Host " Les classes sont          		: $les_classes"
    Write-Host " Vous utilisez des profiles itinérants 	: $roaming"
    Write-host " Les quotas pour les élèves sont 	: $quota1"
    Write-host " Les quotas pour les professeurs sont 	: $quota2"
    Write-host " Les quotas pour les viescos sont 	: $quota3"
    Write-host ""
    Write-host ""

	
    $r = Read-Host –Prompt "êtes d'accord avec ces informations (o|n)? "

    switch ($r)
    {
	{ "o", "O" -contains $_ }{
		# puis on call la function
        create_param  $thedomaine $theHomePath $theShareFolderPath $les_classes $roaming $quota1 $quota2 $quota3
		break
	}
	default
	{
	    # sinon on redémarre la routine
		param_first_run
	}
    }
	
}

function param_recapitulation
{
    [System.Console]::Clear()

    Write-Host ""
    Write-Host ""
    Write-Host "         Paramétrisation de Velociraptor version ($VLRversion)"
    Write-Host "        ---------------------------------------------"
    Write-Host "        © 2014 Philippe Logel `"iMathGeo`" & `"Softwares`""
    Write-Host "                     all rights reserved"
    
    write-host ""
    write-host ""
    write-host "  Vos parapètres actuelles sont : "
    write-host "  -----------------------------"
    write-host "  "
    write-host "  Nom de domaine                        : $domaine "
    write-host "  Le dossier des profiles               : $profilePath"
    Write-host "  Vous utilisez des dossiers de partage : $shareFolders"
    write-host "  les classes sont                      : $classes"
    Write-host "  Vous utilisez des profiles itinérants : $roamingProfile"
    write-host "  Quotas élèves                         : $quotaEleves"
    write-host "  Quotas professeurs                    : $quotaProfesseurs"
    write-host "  Quotas viesco                         : $quotaViesco"
    write-host ""
    write-host ""
    write-host "   Vous pouvez reparamétrer ces informations ...."
    write-host ""
    write-host ""
    
    
    $r = Read-Host –Prompt "         Voulez-vous reparamétrer Velociraptor (o|n)? "

    switch ($r)
    {
	{ "o", "O" -contains $_ }{
        param_first_run
		break
	}
	default
	{
	    # sinon on redémarre la routine
		
	}
   }
}

function param_first_run
{
    [System.Console]::Clear()
    Write-Host ""
    Write-Host ""
    Write-Host "          Bienvenue dans Velociraptor version ($VLRversion)"
    Write-Host "        ---------------------------------------------"
    Write-Host "        © 2014 Philippe Logel `"iMathGeo`" & `"Softwares`""
    Write-Host "                     all rights reserved"
    Write-Host ""
    Write-Host ""
    Write-Host "                 Paramétrage de Velociraptor"
    Write-Host ""
    Write-Host "                    Laissez vous guider ......"
    Write-Host ""
    Write-Host ""
    Write-Host ""

    Write-Host "           Appuyer sur une touche pour continuer ..."

    # on met une pose en place        
    $x = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


    parametrisation_VCL
}



#param_first_run