#
# Created by Philippe Logel on 8/2/2014.
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
                if ($struct_classe.TYPE_STRUCTURE -eq "D") {# nouvelle structure ann�e 2019
                    $result = [string]$struct_classe.CODE_STRUCTURE
                    write-host $result
            
                    return $result
                    break
                }
            }
        }
    }
    
    return $result
}


#
# permet d'extraire la date de cr�ation du fichier xml
#
function get_date_current_xml_file([xml]$userfile)
{
    return $userfile.BEE_ELEVES.PARAMETRES.DATE_EXPORT
}

#
# ajoute une classe � la liste complete
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
    
    # la r�f�rence de l'�tablissement
    $outS = "Il faudra saisir : "+$userfile.BEE_ELEVES.PARAMETRES.UAJ
    write-output  $outS  > $fileConfig
	
    $outS = "Pour l'ann�e : "+$userfile.BEE_ELEVES.PARAMETRES.ANNEE_SCOLAIRE
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
	    [string]$nom          = $user.NOM 	  # NOM le nom de l'�l�ve
        [string]$nomV2        = $user.NOM_DE_FAMILLE # le nom de l'�l�ve avec la base de donn�es V2
        [string]$prenom       = $user.PRENOM      # le pr�nom
        [int]$ELEVE_ID        = $user.ELEVE_ID    # identifiant unique de l'�l�ve dans l'�tablissement scolaire qui permet de retrouver sa classe
        [string]$ID_NATIONAL  = $user.ID_NATIONAL # identifiant national unique

        
        [string]$date            = $user.DATE_NAISS  # la date de naissance        
        [string]$ID_ELEVE_ETAB   = $user.ID_ELEVE_ETAB    # identifiant unique de l'�l�ve
        [string]$CODE_PAYS       = $user.CODE_PAYS    # identifiant unique de l'�l�ve
        [string]$ACCEPTE_SMS     = $user.ACCEPTE_SMS    # identifiant unique de l'�l�ve
        [string]$CODE_REGIME     = $user.CODE_REGIME    # identifiant unique de l'�l�ve
        [string]$DATE_ENTREE     = $user.DATE_ENTREE    # identifiant unique de l'�l�ve
        [string]$CODE_SEXE       = $user.CODE_SEXE    # identifiant unique de l'�l�ve
        [string]$TEL_PORTABLE    = $user.TEL_PORTABLE    # identifiant unique de l'�l�ve
        [string]$CODE_PAYS_NAT   = $user.CODE_PAYS_NAT    # identifiant unique de l'�l�ve
        [string]$CODE_DEPARTEMENT_NAISS = $user.CODE_DEPARTEMENT_NAISS    # identifiant unique de l'�l�ve
        [string]$CODE_COMMUNE_INSEE_NAISS = $user.CODE_COMMUNE_INSEE_NAISS    # identifiant unique de l'�l�ve
        [int]$ADHESION_TRANSPORT = $user.ADHESION_TRANSPORT    # identifiant unique de l'�l�ve
        [int]$CODE_PROVENANCE    = $user.CODE_PROVENANCE    # identifiant unique de l'�l�ve
        [string]$ancienne_classe = $user.SCOLARITE_AN_DERNIER.CODE_STRUCTURE
        
        
        $ELENOET = $ELENOET.substring(0,($ELENOET.length-1)/2)
        
        #write-host $ELENOET
        
        # on r�cup�re la bonne classe
        $theclasse = get_classe $userfile $ELEVE_ID $ELENOET

	if ($nom.length -eq 0)# on teste ici si on est en xml V2 du rectorat
	{
		$nom = $nomV2
        }

	#if ($ID_NATIONAL.length -eq 0)# au d�part je travaillais sur l'ID NATIONALE, mais le user n'a pas forc�ment d'identifiant nationale, je pr�f�re utiliser l'ID_ELEVE_ETAB
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
    Write-host "  $compteur utilisateurs ont �t� cr��s dans : $fileEleves"
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

    Write-host "  $i classes ont �t� cr��es dans       : $toutes_les_classes"
    
    $toutes_les_classes = $toutes_les_classes | select -uniq
    $toutes_les_classes = $toutes_les_classes | sort

    
    Write-host ""
    Write-host "  $i classes ont �t� cr��es dans       : $toutes_les_classes"
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
        Write-Host  "    #   probl�me de fichier xml : la date d'extraction est inf�rieure ($date_xml_new_file)          #"
        Write-Host  "    #                             � celle dans la BDD ($date_xml_BDD)                          #"
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
        Write-Host "En cours d'extraction des �l�ves et des classes de la base sconnet ....."
       

        [xml]$userfile = Get-Content $fileXML

        create_fichier_eleve $userfile
        
        Write-Host "Termin�."
    }
    else
    {
        write-host "Le fichier doit porter le nom        : $fileXML et doit �tre mis � la racine du dossier"
    }

    return $true
}

function extraire_de_sconet
{
    Clear-Host

    Write-Host ""
    Write-Host ""
    Write-Host "         Param�trisation de Velociraptor version ($VLRversion)"
    Write-Host "        ---------------------------------------------"
    Write-Host "        � 2014 Philippe Logel `"iMathGeo`" & `"Softwares`""
    Write-Host "                     all rights reserved"

    Write-Host ""
    Write-Host ""
    Write-Host "           Veuillez saisir le fichier sconet � extraire il est de la forme toto.xml "
    write-Host ""

    $fileXML = Read-Host �Prompt �     Veuillez entrer le nom du fichier �

    extraire_de_sconet_file $scriptPath\$fileXML
}

