#
# Created by Philippe Logel on 8/2/2014.
# Copyright 2019 "iMathGeo" & "Softwares". All rights reserved.
#


function get_name_xml_file
{
   $fileParam = "$scriptPath\Velociraptor_Parametres\parametres.xml"
   $param = "$scriptPath\Velociraptor_Parametres\"
       
   if (-Not (Test-path $param))
   {
      md "$scriptPath\Velociraptor_Parametres"
   }

    # Loading a XML File
    $oXMLDocument=New-Object System.XML.XMLDocument
    $oXMLDocument.Load($fileParam)

    
    $global:pathToSconerXML = $oXMLDocument.config.paths.pathSconetXML.desc
    
    return $global:pathToSconerXML
}

function get_date_xml_file
{
   $fileParam = "$scriptPath\Velociraptor_Parametres\parametres.xml"
   $param = "$scriptPath\Velociraptor_Parametres\"
       
   if (-Not (Test-path $param))
   {
      md "$scriptPath\Velociraptor_Parametres"
   }

    # Loading a XML File
    $oXMLDocument=New-Object System.XML.XMLDocument
    $oXMLDocument.Load($fileParam)

    
    $global:dateXMLFile = $oXMLDocument.config.dateXMLFile.desc
    
    return $global:dateXMLFile
}

function set_date_xml_file([string]$date)
{
   $fileParam = "$scriptPath\Velociraptor_Parametres\parametres.xml"
   $param = "$scriptPath\Velociraptor_Parametres\"
       
   if (-Not (Test-path $param))
   {
      md "$scriptPath\Velociraptor_Parametres"
   }

    # Loading a XML File
    $oXMLDocument=New-Object System.XML.XMLDocument
    $oXMLDocument.Load($fileParam)

    $oXMLDocument.config.dateXMLFile.desc = $date

    $global:dateXMLFile = $date

    $oXMLDocument.Save($fileParam)
}

#
# permet de sauvegarder les classes dans la BDD
# les classes doivent être de la forme : "2ND1,2ND2"
#
function save_class([string]$les_classes)
{
   $fileParam = "$scriptPath\Velociraptor_Parametres\parametres.xml"
   $param = "$scriptPath\Velociraptor_Parametres\"
       
        if (-Not (Test-path $param))
        {
           md "$scriptPath\Velociraptor_Parametres"
        }

    # Loading a XML File
    $oXMLDocument=New-Object System.XML.XMLDocument
    $oXMLDocument.Load($fileParam)
    # Accessing a node/attribute

    $global:classes = $les_classes.split(",")

    $oXMLDocument.config.classes.desc = ($les_classes.Replace('"',"")).Replace(" ","")

    $oXMLDocument.Save($fileParam)
 
    write-host " Mise à jour du config.xml terminé pour les classes" 

    # fonction dans manage_param.ps1
    # on reload les paramètres
    if ($global:gui)
    {
        update_classe_gui
    }
}

function save_account_nbr_xml
{
    $fileParam = "$scriptPath\Velociraptor_Parametres\parametres.xml"
	$param = "$scriptPath\Velociraptor_Parametres\"
       
        if (-Not (Test-path $param))
        {
           md "$scriptPath\Velociraptor_Parametres"
        }

    # Loading a XML File
    $oXMLDocument=New-Object System.XML.XMLDocument
    $oXMLDocument.Load($fileParam)
    # Accessing a node/attribute

    # Gestion des comptes
    $oXMLDocument.config.eleves.nbrEleves.desc = "$global:nbrEleves"
    $oXMLDocument.config.Profs.nbrProfs.desc = "$global:nbrProfs"
    $oXMLDocument.config.Viescos.nbrViescos.desc = "$global:nbrViescos"

    # Gestion des comptes à purger
    $oXMLDocument.config.eleves.nbrElevesPurge.desc = "$global:nbrElevesPurge"
    $oXMLDocument.config.Profs.nbrProfsPurge.desc = "$global:nbrProfsPurge"
    $oXMLDocument.config.Viescos.nbrViescosPurge.desc = "$global:nbrViescosPurge"
    $global:pathToSconerXML

    $oXMLDocument.Save($fileParam)
 
    write-host " Mise à jour du config.xml terminé"
}

#
# permet de sauvegarder les paths pour les fichiers CSV
#
function save_path_xml
{
    $fileParam = "$scriptPath\Velociraptor_Parametres\parametres.xml"
	$param = "$scriptPath\Velociraptor_Parametres\"
       
        if (-Not (Test-path $param))
        {
           md "$scriptPath\Velociraptor_Parametres"
        }

    # Loading a XML File
    $oXMLDocument=New-Object System.XML.XMLDocument
    $oXMLDocument.Load($fileParam)
    # Accessing a node/attribute

    $oXMLDocument.config.paths.pathSconetXML.desc = "$global:pathToSconerXML"
    $oXMLDocument.config.paths.pathEleves.desc = "$global:pathToElevesCSV"
    $oXMLDocument.config.paths.pathProfesseurs.desc = "$global:pathToProfsCSV"
    $oXMLDocument.config.paths.pathViescos.desc = "$global:pathToViescosCSV"
    

    $oXMLDocument.Save($fileParam)
 
    write-host " Mise à jour du config.xml terminé"
}

function load_param_xml
{
    $fileParam = "$scriptPath\Velociraptor_Parametres\parametres.xml"
	$param = "$scriptPath\Velociraptor_Parametres\"
       
    if (-Not (Test-path $param))
    {
       md "$scriptPath\Velociraptor_Parametres"
       
       create_new_params_xml
    }

    # Loading a XML File
    $oXMLDocument=New-Object System.XML.XMLDocument
    $oXMLDocument.Load($fileParam)
    # Accessing a node/attribute

    $vVLRversion = $oXMLDocument.config.version.desc

    if ($global:VLRversion -ne $vVLRversion)
    {   
        Write-Host "Création du nouveau noeud dans le fichier xml : dateXMLFile"   
        $oXMLDocument.config.version.desc = $global:VLRversion

        $oXMLDocument.Save($fileParam)

        # on recharge le fichier
        $oXMLDocument.Load($fileParam)
    }

    # on récupère la date à laquelle le xml file a été créé
    $global:dateXMLFile = $oXMLDocument.config.dateXMLFile.desc

    if ($global:dateXMLFile -eq $null)
    {   
        Write-Host "Création du nouveau noeud dans le fichier xml : dateXMLFile"   
        $oXMLRoot = $oXMLDocument.SelectNodes("config")

        $global:dateXMLFile = "00/00/0000"

        [System.XML.XMLElement]$oXMLD=$oXMLRoot.appendChild($oXMLDocument.CreateElement("dateXMLFile"))
        $oXMLD.SetAttribute("desc", $global:dateXMLFile)

        $oXMLDocument.Save($fileParam)

        # on recharge le fichier
        $oXMLDocument.Load($fileParam)
    }

    $classesSTR = $oXMLDocument.config.classes.desc

    $global:classes = $classesSTR.split(",")

    # Profiles itinérants
    $global:roamingProfile    = $oXMLDocument.config.roamingProfile.desc

    # les variables de gestion du serveur
    $global:domaine           = $oXMLDocument.config.domaine.desc
    $global:profilePath       = $oXMLDocument.config.profilePath.desc
    $global:shareFolders      = $oXMLDocument.config.shareFolders.desc

    # parametres comptes eleves quotas
    $global:quotaEleves       = $oXMLDocument.config.quotaEleves.desc

    # parametres comptes profs quotas
    $global:quotaProfesseurs  = $oXMLDocument.config.quotaProfesseurs.desc

    # parametres comptes profs quotas
    $global:quotaViesco       = $oXMLDocument.config.quotaViesco.desc

    # Gestion des comptes
    $global:nbrEleves	   = $oXMLDocument.config.eleves.nbrEleves.desc
    $global:nbrProfs	   = $oXMLDocument.config.Profs.nbrProfs.desc
    $global:nbrViescos	   = $oXMLDocument.config.Viescos.nbrViescos.desc

    # Gestion des comptes à purger
    $global:nbrElevesPurge	   = $oXMLDocument.config.eleves.nbrElevesPurge.desc
    $global:nbrProfsPurge	   = $oXMLDocument.config.Profs.nbrProfsPurge.desc
    $global:nbrViescosPurge    = $oXMLDocument.config.Viescos.nbrViescosPurge.desc

    # On récupère les paths
    $global:pathToSconerXML  = $oXMLDocument.config.paths.pathSconetXML.desc
    $global:pathToElevesCSV  = $oXMLDocument.config.paths.pathEleves.desc
    $global:pathToProfsCSV   = $oXMLDocument.config.paths.pathProfesseurs.desc
    $global:pathToViescosCSV = $oXMLDocument.config.paths.pathViescos.desc
    

    <#write-host $classes

    write-host $oXMLDocument.config.description
    write-host $oXMLDocument.config.classes.desc
    write-host $oXMLDocument.config.roamingProfile.desc
    write-host $oXMLDocument.config.domaine.desc#>

    write-host " Terminé"
}

#
# Cette partie permet de créer le fichier de configiguration XML
#
function create_new_params_xml ([string]$thedomaine="votre domaine",[string]$theHomePath="\\UNC\votre dossier de profile",[string]$theShareFolderPath="\\UNC\partages",
    [string]$les_classes='2ND1,TS4',$roaming=0,$quota1=1000,$quota2=1000,$quota3=1000,
    $pathSconetXML="./elevessansadresses.xml",$pathElevesCSV="./eleves.txt",$pathProfsCSV="./professeurs.txt",$pathViescosCSV="./viescos.txt",
    $nbrEleve=0,$nbrProfs=0,$nbrViescos=0,$nbrElevesPurge=0,$nbrProfsPurge=0,$nbrViescosPurge=0)
{
    # Create a new XML File with config root node
    [System.XML.XMLDocument]$oXMLDocument=New-Object System.XML.XMLDocument
    # New Node
    [System.XML.XMLElement]$oXMLRoot=$oXMLDocument.CreateElement("config")
    # Append as child to an existing node
    $oXMLDocument.appendChild($oXMLRoot)
    # Add a Attribute
    $oXMLRoot.SetAttribute("description","Configuration Velociraptor`r`n`r`n# Vous devez bien renseigner l'ensemble pour que cela marche !!!!
    # ATTENTION : si les classes sont sous la forme : 2ND 1 vous écrirez 2ND1, pour 3eme A ou écrire 3EMEA
    #             Cette partie est la plus délicate, aucune classe ne doit manquer !!!!
    #")
  
    [System.XML.XMLElement]$oXMLD=$oXMLRoot.appendChild($oXMLDocument.CreateElement("dateXMLFile"))
    $oXMLD.SetAttribute("desc", $global:dateXMLFile)

    [System.XML.XMLElement]$oXMLV=$oXMLRoot.appendChild($oXMLDocument.CreateElement("version"))
    $oXMLV.SetAttribute("desc", $global:VLRversion)

    [System.XML.XMLElement]$oXML0=$oXMLRoot.appendChild($oXMLDocument.CreateElement("classes"))
    $oXML0.SetAttribute("desc",$les_classes)

    [System.XML.XMLElement]$oXML1=$oXMLRoot.appendChild($oXMLDocument.CreateElement("roamingProfile"))
    $oXML1.SetAttribute("desc",$roaming)

    [System.XML.XMLElement]$oXML2=$oXMLRoot.appendChild($oXMLDocument.CreateElement("domaine"))
    $oXML2.SetAttribute("desc",$thedomaine)

    [System.XML.XMLElement]$oXML3=$oXMLRoot.appendChild($oXMLDocument.CreateElement("profilePath"))
    $oXML3.SetAttribute("desc",$theHomePath)

    [System.XML.XMLElement]$oXML4=$oXMLRoot.appendChild($oXMLDocument.CreateElement("shareFolders"))
    $oXML4.SetAttribute("desc",$theShareFolderPath)

    [System.XML.XMLElement]$oXML5=$oXMLRoot.appendChild($oXMLDocument.CreateElement("quotaEleves"))
    $oXML5.SetAttribute("desc",$quota1)

    [System.XML.XMLElement]$oXML6=$oXMLRoot.appendChild($oXMLDocument.CreateElement("quotaProfesseurs"))
    $oXML6.SetAttribute("desc",$quota2)

    [System.XML.XMLElement]$oXML7=$oXMLRoot.appendChild($oXMLDocument.CreateElement("quotaViesco"))
    $oXML7.SetAttribute("desc",$quota3)

    [System.XML.XMLElement]$oXML8=$oXMLRoot.appendChild($oXMLDocument.CreateElement("eleves"))
    $oXML8.SetAttribute("desc","permet de connaître le nombre de comptes élèves à créer ou à purger")

        [System.XML.XMLElement]$oXML81=$oXML8.appendChild($oXMLDocument.CreateElement("nbrEleves"))
        $oXML81.SetAttribute("desc",$nbrEleve)

        [System.XML.XMLElement]$oXML82=$oXML8.appendChild($oXMLDocument.CreateElement("nbrElevesPurge"))
        $oXML82.SetAttribute("desc",$nbrElevesPurge)

    [System.XML.XMLElement]$oXML9=$oXMLRoot.appendChild($oXMLDocument.CreateElement("Profs"))
    $oXML9.SetAttribute("desc","permet de connaître le nombre de comptes Professeurs à créer ou à purger")

        [System.XML.XMLElement]$oXML91=$oXML9.appendChild($oXMLDocument.CreateElement("nbrProfs"))
        $oXML91.SetAttribute("desc",$nbrProfs)

        [System.XML.XMLElement]$oXML92=$oXML9.appendChild($oXMLDocument.CreateElement("nbrProfsPurge"))
        $oXML92.SetAttribute("desc",$nbrProfsPurge)

    [System.XML.XMLElement]$oXML10=$oXMLRoot.appendChild($oXMLDocument.CreateElement("Viescos"))
    $oXML10.SetAttribute("desc","permet de connaître le nombre de comptes Viescos à créer ou à purger")

        [System.XML.XMLElement]$oXML101=$oXML10.appendChild($oXMLDocument.CreateElement("nbrViescos"))
        $oXML101.SetAttribute("desc",$nbrViescos)

        [System.XML.XMLElement]$oXML102=$oXML10.appendChild($oXMLDocument.CreateElement("nbrViescosPurge"))
        $oXML102.SetAttribute("desc",$nbrViescosPurge)

    [System.XML.XMLElement]$oXML11=$oXMLRoot.appendChild($oXMLDocument.CreateElement("paths"))
    $oXML11.SetAttribute("desc","Les chemins d'accès qui pointent sur les extractions élèves, profs et viescos")
        [System.XML.XMLElement]$oXML111=$oXML11.appendChild($oXMLDocument.CreateElement("pathSconetXML"))
        $oXML111.SetAttribute("desc",$pathSconetXML)

        [System.XML.XMLElement]$oXML112=$oXML11.appendChild($oXMLDocument.CreateElement("pathEleves"))
        $oXML112.SetAttribute("desc",$pathElevesCSV)

        [System.XML.XMLElement]$oXML113=$oXML11.appendChild($oXMLDocument.CreateElement("pathProfesseurs"))
        $oXML113.SetAttribute("desc",$pathProfsCSV)

        [System.XML.XMLElement]$oXML114=$oXML11.appendChild($oXMLDocument.CreateElement("pathViescos"))
        $oXML114.SetAttribute("desc",$pathViescosCSV)

       
        

    $fileParam = "$scriptPath\Velociraptor_Parametres\parametres.xml"
	$param = "$scriptPath\Velociraptor_Parametres\"
       
        if (-Not (Test-path $param))
        {
           md "$scriptPath\Velociraptor_Parametres"
        }

    # Save File
    $oXMLDocument.Save($fileParam)

    $global:domaine=$thedomaine

    $global:theDCs = create_DC_chains $global:domaine

    #write-host  $global:theDCs

    write-host " Terminé"
}


function create_param ([string]$thedomaine,[string]$theHomePath,[string]$theShareFolderPath,[string]$les_classes,$roaming,$quota1,$quota2,$quota3)
{

	$fileParam = "$scriptPath\Velociraptor_Parametres\parametres.ps1"
	$param = "$scriptPath\Velociraptor_Parametres\"
       
        if (-Not (Test-path $param))
        {
           md "$scriptPath\Velociraptor_Parametres"
        }

	Write-output "#" > $fileParam
	Write-output "# Created by Philippe Logel on 8/2/2014." >> $fileParam
	Write-output "# Copyright 2019 `"iMathGeo`" & `"Softwares`". All rights reserved." >> $fileParam
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
    Clear-Host
         
 

    Write-Host ""
    Write-Host ""
    Write-Host "         Paramétrisation de Velociraptor version ($VLRversion)"
    Write-Host "        ---------------------------------------------"
    Write-Host "        © 2019 Philippe Logel `"iMathGeo`" & `"Softwares`""
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

    $les_classes = $les_classes.Replace('"',"")

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

    Clear-Host
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
        create_new_params_xml  $thedomaine $theHomePath $theShareFolderPath $les_classes $roaming $quota1 $quota2 $quota3
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
    Clear-Host

    Write-Host ""
    Write-Host ""
    Write-Host "         Paramétrisation de Velociraptor version ($VLRversion)"
    Write-Host "        ---------------------------------------------"
    Write-Host "        © 2019 Philippe Logel `"iMathGeo`" & `"Softwares`""
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
        Write-Host ""
        Write-Host ""
        Write-Host "Vous avez annulé l'action ...."
        Write-Host ""
	}
   }
}

function param_first_run
{
    Clear-Host

    Write-Host ""
    Write-Host ""
    Write-Host "          Bienvenue dans Velociraptor version ($VLRversion)"
    Write-Host "        ---------------------------------------------"
    Write-Host "        © 2019 Philippe Logel `"iMathGeo`" & `"Softwares`""
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
    Write-Host ""
    Write-Host ""

    # on met une pose en place        
    pause


    parametrisation_VCL
}



#param_first_run