#
# Created by Philippe Logel on 22/11/2019.
# Copyright 2014 "iMathGeo" & "Softwares". All rights reserved.
#

# le fichier xml de base

#
# extraction des classes de la base sconnet
#

function get_classe([xml]$userfile,[int]$ELEVE_ID,[int]$ELENOET)
{
    [string]$result = "rien"
    
    foreach( $struct in $userfile.BEE_ELEVES.DONNEES.STRUCTURES.STRUCTURES_ELEVE)
    {
        #write-host $struct.ELEVE_ID
        
        if ($struct.ELEVE_ID -eq $ELEVE_ID -and $struct.ELENOET -eq $ELENOET)
        {
            foreach( $struct_classe in $struct.STRUCTURE) {
                if ($struct_classe.TYPE_STRUCTURE -eq "D") {# nouvelle structure année 2019
                    $result = [string]$struct_classe.CODE_STRUCTURE
                    #write-host $result
            
                    return $result
                    break
                }
            }
        }
    }
    
    return $result
}


#
# permet d'extraire la date de création du fichier xml
#
function get_date_current_xml_file([xml]$userfile)
{
    return $userfile.BEE_ELEVES.PARAMETRES.DATE_EXPORT
}

#
# ajoute une classe à la liste complete
#

function add_val_to_array ([array] $a,[string]$val)
{
    for ($i=0;$i -lt $a.Count;$i++)
    {
        if ($a[$i] -eq $val)
        {
            return $a
        }
    }
    
    #write-host $val
    
    $a += $val
    
    return $a
}

#
# creation du fichier eleve.txt et classes.txt
#

function create_fichier_eleve ([xml]$userfile)
{
    $fileEleves  = "$scriptPath\eleves.txt"
    $fileClasses = "$scriptPath\classes.txt"
    $fileConfig  = "$scriptPath\configSeveur.txt"
    
    $les_classes=@()

    write-host ""
    Write-host "  La configuration du serveur est dans : $fileConfig"
    Write-host ""
    
    # la référence de l'établissement
    $outS = "Il faudra saisir : "+$userfile.BEE_ELEVES.PARAMETRES.UAJ
    write-output  $outS  > $fileConfig
	
    $outS = "Pour l'année : "+$userfile.BEE_ELEVES.PARAMETRES.ANNEE_SCOLAIRE
    write-output $outS  >> $fileConfig
               
    if (Test-path $fileEleves)
    {
       del $fileEleves
    }

    $compteur = 0
    
    Write-output "classe,Nom,Prenom,id" > $fileEleves 
     
    
    foreach( $user in $userfile.BEE_ELEVES.DONNEES.ELEVES.ELEVE) 
    {
        [string]$ELENOET      = $user.ELENOET     # id de la classe
	[string]$nom          = $user.NOM 	  # NOM le nom de l'élève
        [string]$nomV2        = $user.NOM_DE_FAMILLE # le nom de l'élève avec la base de données V2
        [string]$prenom       = $user.PRENOM      # le prénom
        [int]$ELEVE_ID        = $user.ELEVE_ID    # identifiant unique de l'élève dans l'établissement scolaire qui permet de retrouver sa classe
        [string]$ID_NATIONAL  = $user.ID_NATIONAL # identifiant national unique

        
        [string]$date            = $user.DATE_NAISS  # la date de naissance        
        [string]$ID_ELEVE_ETAB   = $user.ID_ELEVE_ETAB    # identifiant unique de l'élève
        [string]$CODE_PAYS       = $user.CODE_PAYS    # identifiant unique de l'élève
        [string]$ACCEPTE_SMS     = $user.ACCEPTE_SMS    # identifiant unique de l'élève
        [string]$CODE_REGIME     = $user.CODE_REGIME    # identifiant unique de l'élève
        [string]$DATE_ENTREE     = $user.DATE_ENTREE    # identifiant unique de l'élève
        [string]$CODE_SEXE       = $user.CODE_SEXE    # identifiant unique de l'élève
        [string]$TEL_PORTABLE    = $user.TEL_PORTABLE    # identifiant unique de l'élève
        [string]$CODE_PAYS_NAT   = $user.CODE_PAYS_NAT    # identifiant unique de l'élève
        [string]$CODE_DEPARTEMENT_NAISS = $user.CODE_DEPARTEMENT_NAISS    # identifiant unique de l'élève
        [string]$CODE_COMMUNE_INSEE_NAISS = $user.CODE_COMMUNE_INSEE_NAISS    # identifiant unique de l'élève
        [int]$ADHESION_TRANSPORT = $user.ADHESION_TRANSPORT    # identifiant unique de l'élève
        [int]$CODE_PROVENANCE    = $user.CODE_PROVENANCE    # identifiant unique de l'élève
        [string]$ancienne_classe = $user.SCOLARITE_AN_DERNIER.CODE_STRUCTURE
        
        
        $ELENOET = $ELENOET.substring(0,($ELENOET.length-1)/2)
        
        #write-host $ELENOET
        
        # on récupère la bonne classe
        $theclasse = get_classe $userfile $ELEVE_ID $ELENOET

	if ($nom.length -eq 0)# on teste ici si on est en xml V2 du rectorat
	{
		$nom = $nomV2
        }

	#if ($ID_NATIONAL.length -eq 0)# au départ je travaillais sur l'ID NATIONALE, mais le user n'a pas forcément d'identifiant nationale, je préfère utiliser l'ID_ELEVE_ETAB
	#{
		$ID_NATIONAL = $ID_ELEVE_ETAB
        #}
        
        if ($theclasse -ne "rien")
        {
            $theclasse = $theclasse -Replace (" ","")
            $ancienne_classe = $ancienne_classe  -Replace (" ","")
            
            $les_classes = add_val_to_array $les_classes $theclasse
            
            $res = $theclasse+","+$nom+","+$prenom+","+$ID_NATIONAL#+","#+$ELEVE_ID+":"+$ancienne_classe +":"+":"+$date+":"+$ID_ELEVE_ETAB+":"+$CODE_PAYS+":"+$ACCEPTE_SMS+":"+$CODE_REGIME+":"+$DATE_ENTREE+":"+$CODE_SEXE+":"+$TEL_PORTABLE+":"+$CODE_PAYS_NAT+":"+$CODE_DEPARTEMENT_NAISS+":"+$CODE_COMMUNE_INSEE_NAISS+":"+$CODE_COMMUNE_INSEE_NAISS+":"+$ADHESION_TRANSPORT+":"+$CODE_PROVENANCE
            
            Write-output $res >> $fileEleves # on met tout dans un fichier
	    $compteur++
        }
    }

    Write-host ""
    Write-host "  $compteur utilisateurs ont été créés dans : $fileEleves"
    Write-host ""
    
    [string]$toutes_les_classes = ""
    
    $les_classes = $les_classes | sort
    
    write-host $les_classes
    
    for ($i=0;$i -lt $les_classes.Count;$i++)
    {
        $toutes_les_classes = $toutes_les_classes + "`"" + $les_classes[$i] + "`""

	    if ($i -lt $les_classes.Count-1)
	    {
		   $toutes_les_classes = $toutes_les_classes + ", "
	    }  
         
         #write-host $les_classes[$i]
    }

    Write-host "  $i classes ont été créées dans       : $toutes_les_classes"
    
    $toutes_les_classes = $toutes_les_classes | select -uniq
    $toutes_les_classes = $toutes_les_classes | sort

    
    Write-host ""
    Write-host "  $i classes ont été créées dans       : $toutes_les_classes"
    Write-host ""

    

    # fonction dans manage_param.ps1
    # on sauvegarde les classes dans parametres.xml
    save_class $toutes_les_classes
}

function extraire_de_sconet_file([string]$fileXML)
{
    [xml]$userfile = Get-Content $fileXML

    $date_xml_new_file = get_date_current_xml_file $userfile
    $date_xml_BDD = get_date_xml_file

    #Write-Host "Nouveau fichier : $date_xml_new_file ancien fichier : $date_xml_BDD"

    $d_bdd = get-date $date_xml_BDD
    $d_new_file = get-date $date_xml_new_file

    if (($d_bdd -gt $d_new_file) -eq $true)
    {
        Write-Host  ""
        Write-Host  ""
        Write-Host  "    #########################################################################################"
        Write-Host  "    #                                                                                       #"
        Write-Host  "    #   problème de fichier xml : la date d'extraction est inférieure ($date_xml_new_file)          #"
        Write-Host  "    #                             à celle dans la BDD ($date_xml_BDD)                          #"
        Write-Host  "    #                                                                                       #"
        Write-Host  "    #########################################################################################"
        Write-Host  ""
        Write-Host  ""

        # dans ce cas de figure on ne fait rien
        return $false
    }

    # on sauvegarde la date du file xml
    set_date_xml_file $date_xml_new_file

    # on sauvegarde son path ou son nom
    $global:pathToSconerXML   = $fileXML

    # Write-Host "coucou : $fileXML"
    save_path_xml
    
    #exit 

    if (Test-path $fileXML)
    {

        Clear-Host
        Write-Host "En cours d'extraction des élèves et des classes de la base sconnet ....."
       

        [xml]$userfile = Get-Content $fileXML

        create_fichier_eleve $userfile
        
        Write-Host "Terminé."
    }
    else
    {
        write-host "Le fichier doit porter le nom        : $fileXML et doit être mis à la racine du dossier"
    }

    return $true
}

<# 
Attention de bien constituer vos classes quand on utilise IACA 
#>

function test_if_sudent ([string]$classe, [array]$arr_schemas_classes)
{
  #write-host "schémas de classe est : $arr_schemas_classes"

  if ($arr_schemas_classes -contains $classe) {
    return $True
  } else {
    return $False
  }
}


function extraire_de_iaca_file ([string]$filePath)
{
    # dans un premier temps on charge le schéma de classe iaca
    # en effet élèves et professeurs sont mélangés
    $schemas_classes = Get-Content $scriptPath\schema_classes_iaca.txt

    $arr_schemas_classes = $schemas_classes -split ','

    write-host "Le schéma de 'schema_classes_iaca.txt' de classes iaca est : $arr_schemas_classes"

    # dans un premier on normalise l'entete pour qu'elle ressemble à quelque chose
    (Get-Content $filePath).replace('N°;NOM;Prénom;Classe/codestructure;login;pass', 'id;NOM;Prenom;Classe;login;pass') | Set-Content $filePath

    $current_date = Get-Date -Format "dd/MM/yyyy"

    # on sauvegarde la date du file xml
    set_date_xml_file $current_date

    # on sauvegarde son path ou son nom
    $global:pathToSconerXML   = $filePath

    # Write-Host "coucou : $fileXML"
    save_path_xml
    
     
    # Nous allons importer le fichier CSV
    $csvfileNew = Import-CSV $filePath -Delimiter ";"

    $les_classes=@()

    # la sortie de la nouvelle base de données
    $fileProfPrint    = "$scriptPath\profNew.txt"
    $csvProfFilePrint = @() # Create the empty array that will eventually be the CSV file

    $fileElevePrint    = "$scriptPath\EleveNew.txt"
    $csvEleveFilePrint = @() # Create the empty array that will eventually be the CSV file

    $compteur_prof = $compteur_eleves = 0

    # on peut looper dans le fichier
    ForEach ($item in $csvfileNew)
    {
        #Write-Host $item 

        $classe = $item.classe -replace ("`"","") # la classe
        $nom    = $item.NOM -replace ("`"","")    # nom
        $prenom = $item.Prenom -replace ("`"","") # prenom
        $id     = $item.id -replace ("`"","")     # identifiant : un nombre
        $login  = $item.login -replace ("`"","")  # login : un nombre
        $pass   = $item.pass -replace ("`"","")  # login : un nombre

        #write-host "$classe $nom $prenom $id"

        if ((test_if_sudent $item.classe $arr_schemas_classes) -eq $True) {# cette fonction se trouve dans velociraptor.ps1 à la racine du logiciel
          $les_classes = add_val_to_array $les_classes $classe

          # nous sommes dans le cas d'un eleve
          $row = New-Object System.Object # Create an object to append to the array
          $row | Add-Member -MemberType NoteProperty -Name "classe" -Value "$classe" # create a property called User. This will be the User column
          $row | Add-Member -MemberType NoteProperty -Name "Nom" -Value "$nom" # create a property called User. This will be the User column
          $row | Add-Member -MemberType NoteProperty -Name "Prenom" -Value "$prenom" # create a property called User. This will be the User column
          $row | Add-Member -MemberType NoteProperty -Name "login" -Value "$login" # create a property called User. This will be the User column
          $row | Add-Member -MemberType NoteProperty -Name "password" -Value "$pass" # create a property called User. This will be the User column
          $row | Add-Member -MemberType NoteProperty -Name "id" -Value "$id" # create a property called User. This will be the User column
                  
          #write-host $row

          $csvEleveFilePrint += $row # append the new data to the array

          $compteur_eleves++
        } else {
          # nous sommes dans le cas d'un professeur
          $row = New-Object System.Object # Create an object to append to the array
          $row | Add-Member -MemberType NoteProperty -Name "classe" -Value "PROF" # create a property called User. This will be the User column
          $row | Add-Member -MemberType NoteProperty -Name "Nom" -Value "$nom" # create a property called User. This will be the User column
          $row | Add-Member -MemberType NoteProperty -Name "Prenom" -Value "$prenom" # create a property called User. This will be the User column
          $row | Add-Member -MemberType NoteProperty -Name "login" -Value "$login" # create a property called User. This will be the User column
          $row | Add-Member -MemberType NoteProperty -Name "password" -Value "$pass" # create a property called User. This will be the User column
          $row | Add-Member -MemberType NoteProperty -Name "id" -Value "$id" # create a property called User. This will be the User column
          
          #write-host $row

          $csvProfFilePrint += $row # append the new data to the array

          $compteur_prof++
        }
    }

    $csvEleveFilePrint | sort classe,nom | Export-CSV -Delimiter ',' -Path $fileElevePrint -NoTypeInformation
    $csvProfFilePrint | sort classe,nom | Export-CSV -Delimiter ',' -Path $fileProfPrint -NoTypeInformation
    
    
    # récapitulatif
    Write-host ""
    Write-host "  $compteur_eleves élèves ont été extraits dans : $fileElevePrint"
    Write-host "  $compteur_prof professeurs ont été extraits dans : $fileProfPrint"
    Write-host ""
    
    [string]$toutes_les_classes = ""

    $les_classes = $les_classes | sort
    
    # on classe les classes ont été créés, on les ordonne
    
    for ($i=0;$i -lt $les_classes.Count;$i++)
    {
        $toutes_les_classes = $toutes_les_classes + "`"" + $les_classes[$i] + "`""

	    if ($i -lt $les_classes.Count-1)
	    {
		   $toutes_les_classes = $toutes_les_classes + ", "
	    }  
         
         #write-host $les_classes[$i]
    }

    $toutes_les_classes = $toutes_les_classes | select -uniq
    $toutes_les_classes = $toutes_les_classes | sort

    
    Write-host ""
    Write-host "  $i classes ont été créées dans       : $toutes_les_classes"
    Write-host ""

    

    # fonction dans manage_param.ps1
    # on sauvegarde les classes dans parametres.xml
    save_class $toutes_les_classes
}

function extraire_de_sconet_acl_file ([string]$filePath)
{
  $extension = (Split-Path -Path $filePath -Leaf).Split(".")[1]


  if ($extension -eq "xml") {
    # nous sommes dans le cas de sconet
    extraire_de_sconet_file $filePath
    $global:extraction_type               = [extraction_type]::sconet
  } elseif ($extension -eq "csv") {
    # nous sommes dans le cas de IACA
    $global:extraction_type               = [extraction_type]::iaca
    extraire_de_iaca_file $filePath
  } else {
    Write-Host "Pour un autre système d'extraction"
  }

  write-host ""
  write-host "Le type d'extraction est : $global:extraction_type"
}

function extraire_de_sconet_acl
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
    Write-Host "           Veuillez saisir le fichier sconet ou ACL à extraire il est de la forme : "
    Write-Host "           - toto.xml (format sconet)"
    Write-Host "           - toto.csv (format iaca)"
    write-Host ""
    write-Host " ATTENTION pour ACL avec extraction pour IACA, il faut créer un fichier'schema_classes_iaca.txt' à la racine du logiciel de la forme :
avec les classes sous la forme : ECS1,ECS2,TS1,TS2,TS3,TS4,TS5,...."
    write-Host ""

    $fileXML = Read-Host –Prompt ‘     Veuillez entrer le nom du fichier ’

    extraire_de_sconet_acl_file $scriptPath\$fileXML
}

