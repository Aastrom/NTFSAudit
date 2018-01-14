# Administration Windows Server 2016
# ESGI 2A - Mélodie BERNARD, Jacques RIMBAULT, Antoine HENRY

# Audit et modification en masse de permissions NTFS sur un répertoire Windows

# Syntaxe : .\NTFS.ps1 -Action 'ACL | Audit | Child-Audit | Help | High | Medium | Low | Recovery' -Path '[Directory]' -Path2 '[Directory]' -Recurse '[yes]' -Graphical '[yes]' -Account '[Account]'

[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True,Position=0)]
    [String]$Action,
	[String]$Path,
	[Parameter(Mandatory=$False)]
	[String]$Path2,
    [String]$Recurse,
	[String]$Account,
    [String]$Graphical
)

# Encodage UTF-8 E/S
$OutputEncoding = New-Object -typename System.Text.UTF8Encoding
[Console]::OutputEncoding = New-Object -typename System.Text.UTF8Encoding

# Définir la langue du système
$infos = Get-WmiObject Win32_OperatingSystem -ComputerName '.'
$Language = $infos.OSLanguage

# Identification des objets de type "Comptes d'utilisateurs"
if($Language -eq 1036) {
    $admins = "Administrateurs"
    $users  = "Utilisateurs"
    $usersA = "Utilisateurs Authentifiés"
    $system = "Système"  
}elseif($Language -eq 1033) {
    $admins = "Administrators"
    $users  = "Users"
    $usersA = "Authenticated Users"
    $system = "System"
}else{
    Write-Host "OS Language compatibility error !" 
}

# Identification des objets de type "Accès"
$accessArray = 'None', 'ReadData', 'ListDirectory', 'CreateFiles', 'CreateDirectories', 'AppendData', 'ReadExtendedAttributes', 'WriteExtendedAttributes', 'Traverse', 'ExecuteFile', 'DeleteSubdirectoriesAndFiles', 'ReadAttributes', 'WriteAttributes', 'Write', 'Delete', 'ReadPermissions', 'Read', 'ReadAndExecute', 'Modify', 'ChangePermissions', 'TakeOwnership', 'Synchronize', 'FullControl', 'GenericAll', 'GenericExecute', 'GenericWrite', 'GenericRead'

$actiondate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Vérification de l'existence du fichier log
$logtest = Test-Path 'log/log.txt'
if(!$logtest){
    Write-Host
    Write-Host "(!)  Création du fichier log nécessaire."
    $logfile = New-Item 'log/log.txt' -type file 
    Add-Content -Path 'log/log.txt' -value "[$actiondate] Création du fichier log (log/log.txt)."
    Write-Host "(OK) Fichier log créé."
} 

# Si $Path n'est pas renseigné, $Path est le répertoire courant
if($Path -eq ''){
    $Path = Get-Location
}

# Affichage de l'aide
if($Action -eq 'Help'){
    Clear
    Add-Content -Path 'log/log.txt' -value "[$actiondate] Affichage de l'aide." 
    Write-Host
    if($Language -eq 1036){
        foreach($line in (Get-Content -Path 'help/aide.txt')){
            Write-Host $line 
        }
        Write-Host
    }elseif($Language -eq 1033){
        foreach($line in (Get-Content -Path 'help/help.txt')){
            Write-Host $line 
        }
        Write-Host
    }
}

# Installation du module NTFSSecurity
if($Action -ne 'Help'){
    # Si le module NTFSSecurity est déjà installé
    if(Get-Module -ListAvailable -Name NTFSSecurity) {
        if($Language -eq 1036){
            Write-Host
	        Write-Host "     Démarrage du module NTFSSecurity..."
	        Write-Host
        }elseif($Language -eq 1033){
	        Write-Host
	        Write-Host "     Launching NTFSSecurity module..."
	        Write-Host
        }
    # Sinon on installe le module NTFSSecurity
    }else{
        Add-Content -Path 'log/log.txt' -value "[$actiondate] Installation du module NTFSSecurity..."
        if($Language -eq 1036){
	        Write-Host
	        Write-Host "(!)    Installation du module NTFSSecurity nécessaire."
	        Write-Host "Démarrage de l'installation du module NTFSSecurity..."
	        Write-Host
            Install-Module NTFSSecurity -Force
	        Write-Host
	        Write-Host "Le module NTFSSecurity est installé."
	        Write-Host "Démarrage du module NTFSSecurity..."
	        Write-Host
        }elseif($Language -eq 1033){
            Write-Host
	        Write-Host "NTFSSecurity module installation needed."
	        Write-Host "Launching NTFSSecurity module installation..."
	        Write-Host
            Install-Module NTFSSecurity -Force
	        Write-Host
	        Write-Host "NTFSSecurity module is installed."
	        Write-Host "Launching NTFSSecurity module..."
	        Write-Host
        }
        Add-Content -Path 'log/log.txt' -value "[$actiondate] Le module NTFSSecurity est installé."	
    }
}

sleep -Milliseconds 20

# Détection des fichiers
if($Action -ne 'Help' -and $Action -ne 'Recovery'){
    if($Language -eq 1036){
        Write-Host "     Détection des fichiers..."
    }elseif($Language -eq 1033){
        Write-Host "     Detecting files..."
    }
    $begincountdate = Get-Date
    if($Recurse -and $Path2){
        # $ChildItemRecurse récupère l'ensemble des descendants du répertoire $Path2, $counter récupère le nombre de lignes de $ChildItemRecurse
        foreach($file in ($ChildItemRecurse = Get-ChildItem -Path $Path2 -recurse)){ $counter++ }
    }elseif($Recurse){
        # $ChildItemRecurse récupère l'ensemble des descendants du répertoire $Path, $counter récupère le nombre de lignes de $ChildItemRecurse
        foreach($file in ($ChildItemRecurse = Get-ChildItem -Path $Path -recurse)){ $counter++ } 
    }elseif($Action -eq 'Child-Audit' -and !$Recurse){
        # $ChildItem récupère les enfants du répertoire $Path, $counter récupère le nombre de lignes de $ChildItem
        $counter = (($ChildItem = Get-ChildItem -Path $Path) | Measure-Object -Line).lines
    }elseif($Action -eq 'Audit'){
        $counter = ($Item = Get-Item -Path $Path | Measure-Object -Line).lines
    }
    $endcountdate = Get-Date
    $counttime = ($endcountdate - $begincountdate)
    if($Language -eq 1036){
        Write-Host "     Nombre de fichiers détectés : $counter."
        Write-Host "     Détection effectuée en : $counttime."
        Write-Host
    }elseif($Language -eq 1033){
        Write-Host "     Number of files detected : $counter."
        Write-Host "     Detection performed in : $counttime."
        Write-Host
    }

    sleep -Milliseconds 20
}
#  Application d'une ACL sous la forme d'un fichier texte créé par l'utilisateur
if($Action -eq "ACL") {
    Add-Content -Path 'log/log.txt' -value "[$actiondate] Application des ACL contenues dans $Path sur le répertoire $Path2."
    Write-Host "(~)  Chargement des ACL contenues dans $Path..."
    Write-Host
    $lineacl = 0
    $begininvoke = Get-Date
    $ACLFile = Get-Content -Path $Path
    foreach($line in $ACLFile){
        # On parcourt chaque ligne du fichier texte.
        $lineacl++
        
        # S'il ne s'agit ni d'un commentaire, ni d'une ligne vide, ni d'une ligne commençant par un espace ou un caractère vide
        if($line[0] -ne '#' -and $line -ne '' -and $line[0] -ne ' '){
            # On découpe la chaîne à chaque caractère espace pour définir $ACLUser, $ACLRight et $ACLAccess
            $ACLUser = $line.split(" ")[0]
            # On remplace éventuellement l'underscore pour un objet utilisateur avec un nom composé
            $ACLUser = $ACLUser.replace("_", " ")

            $ACLRight = $line.split(" ")[1]
            # On vérifie que l'autorisation renseignée est correcte 
            if($ACLRight -ne 'Allow' -and $ACLRight -ne 'Deny'){ 
                $ACLRight = "error" 
            }
                
            $ACLAccess = $line.split(" ")[2]
            # On vérifie que le type d'accès renseigné est correct
            if(!($accessArray -match $ACLAccess)){
                $ACLAccess = "error" 
            } 

            $ACLPath = $line.split(" ")[3]
            if($ACLPath -eq '' -or !$ACLPath){
                $ACLPath = $Path2
                if($ACLPath -eq '' -or !$ACLPath){
                    $ACLPath = Get-Location
                }
            }

            # S'il n'y a pas d'erreur :)
            if($ACLRight -ne "error" -and $ACLAccess -ne "error"){
                $beginprintdate = Get-Date
                $begindate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                if($Recurse){
                    if($ACLRight -eq 'Allow'){ 
                        Add-Content -Path 'log/log.txt' -value "[$begindate] (+) Autorisation récursive de la permission $ACLAccess pour $ACLUser sur le répertoire $ACLPath..."
                        Add-NTFSAccess -Path $ACLPath -Account $ACLUser -AccessRights $ACLAccess
                        if($Graphical){
                            foreach($object in $ChildItemRecurse){
                                $i++
                                $elapsed1 = (Get-Date) - $beginprintdate
                                $prct1 = ($i / $counter * 100.0) 
                                $totaltime1 = ($elapsed1.TotalSeconds) / ($prct1 / 100.0)
                                $remain1 = $totaltime1 - $elapsed1.TotalSeconds
                                $prct1 = [Math]::Round($prct1, 2)
                                Write-Progress -Activity "(+) Autorisation récursive de la permission $ACLAccess pour $ACLUser sur le répertoire $ACLPath..." -CurrentOperation "$prct1% achevé" -SecondsRemaining $remain1 -Status $object.FullName -PercentComplete $prct1
                                Add-NTFSAccess -Path $ACLPath -Account $ACLUser -AccessRights $ACLAccess
                            }
                        }else{
                            Add-Content -Path 'log/log.txt' -value "[$begindate] (+) Autorisation récursive de la permission $ACLAccess pour $ACLUser sur le répertoire $ACLPath..."
                            Write-Host "     (+)     Autorisation récursive de la permission $ACLAccess pour $ACLUser sur le répertoire $ACLPath..."
                            $ChildItemRecurse | Add-NTFSAccess -Account $ACLUser -AccessRights $ACLAccess
                        }
                    }elseif($ACLRight -eq 'Deny'){ 
                        Add-Content -Path 'log/log.txt' -value "[$begindate] (+) Suppression récursive de la permission $ACLAccess pour $ACLUser sur le répertoire $ACLPath..."
                        Remove-NTFSAccess -Path $ACLPath -Account $ACLUser -AccessRights $ACLAccess
                        if($Graphical){
                            foreach($object in $ChildItemRecurse){
                                $i++
                                $elapsed1 = (Get-Date) - $beginprintdate
                                $prct1 = ($i / $counter * 100.0) 
                                $totaltime1 = ($elapsed1.TotalSeconds) / ($prct1 / 100.0)
                                $remain1 = $totaltime1 - $elapsed1.TotalSeconds
                                $prct1 = [Math]::Round($prct1, 2)
                                Write-Progress -Activity "(-) Suppression récursive de la permission $ACLAccess pour $ACLUser sur le répertoire $ACLPath..." -CurrentOperation "$prct1% achevé" -SecondsRemaining $remain1 -Status $object.FullName -PercentComplete $prct1
                                Remove-NTFSAccess -Path $ACLPath -Account $ACLUser -AccessRights $ACLAccess
                            }
                        }else{
                            Add-Content -Path 'log/log.txt' -value "[$begindate] (-) Suppression récursive de la permission $ACLAccess pour $ACLUser sur le répertoire $ACLPath..."
                            Write-Host "     (-)     Suppression récursive de la permission $ACLAccess pour $ACLUser sur le répertoire $ACLPath..."
                            $ChildItemRecurse | Remove-NTFSAccess -Account $ACLUser -AccessRights $ACLAccess
                        }
                    }
                }else{
                    if($ACLRight -eq 'Allow'){
                        Add-Content -Path 'log/log.txt' -value "[$begindate] (+) Autorisation de la permission $ACLAccess pour $ACLUser sur le répertoire $ACLPath..."
                        Write-Host "     (+) Autorisation de la permission $ACLAccess pour $ACLUser sur le répertoire $ACLPath..." 
                        Add-NTFSAccess -Path $ACLPath -Account $ACLUser -AccessRights $ACLAccess
                    }elseif($ACLRight -eq 'Deny'){
                        Add-Content -Path 'log/log.txt' -value "[$begindate] (-) Suppression de la permission $ACLAccess pour $ACLUser sur le répertoire $ACLPath..."
                        Write-Host "     (-) Suppression $ACLAccess pour $ACLUser sur le répertoire $ACLPath..."
                        Remove-NTFSAccess -Path $ACLPath -Account $ACLUser -AccessRights $ACLAccess
                    }
                }
                $i = 0
                $prct = 0
                $prct1 = 0
            # Sinon :(
            }elseif($ACLRight -eq "error"){
                if($ACLAccess -eq "error"){
                    Add-Content -Path 'log/log.txt' -value "[$begindate] (!)  Ligne $lineacl : Erreurs détectées (Right et Access) dans le fichier ACL $Path"
                    Write-Host "(!)  Ligne $lineacl : Erreurs détectées (Right et Access) dans le fichier ACL $Path"
                }else{
                    Add-Content -Path 'log/log.txt' -value "[$begindate] (!)  Ligne $lineacl : Erreur détectée (Right) dans le fichier ACL $Path"
                    Write-Host "(!)  Ligne $lineacl : Erreur détectée (Right) dans le fichier ACL $Path" 
                }
            }elseif($ACLAccess -eq "error"){
                if($ACLRight -eq "error"){
                    Add-Content -Path 'log/log.txt' -value "[$begindate] (!)  Ligne $lineacl : Erreurs détectées (Right et Access) dans le fichier ACL $Path"
                    Write-Host "(!)  Ligne $lineacl : Erreurs détectées (Right et Access) dans le fichier ACL $Path"
                }else{
                    Add-Content -Path 'log/log.txt' -value "[$begindate] (!)  Ligne $lineacl : Erreur détectée (Access) dans le fichier ACL $Path"
                    Write-Host "(!)  Ligne $lineacl : Erreur détectée (Access) dans le fichier ACL $Path" 
                }         
            }
        } 
    }
    Write-Host
    $endinvoke = Get-Date
    $invoketime = $endinvoke - $begininvoke
    if($Language -eq 1036){
        Write-Host "     Permissions délivrées en : $invoketime."
        Write-Host
        if($Recurse){
            Write-Host "(OK) Exécuter .\NTFS.ps1 -Action 'Child-Audit' -Path '$Path2' pour vérifier les nouvelles permissions."
        }else{
            Write-Host "(OK) Exécuter .\NTFS.ps1 -Action 'Audit' -Path '$Path2' pour vérifier les nouvelles permissions."
        }
	}elseif($Language -eq 1033){
        Write-Host "    Permissions issued in : $invoketime."
        Write-Host
        if($Recurse){
		    Write-Host "(OK) Execute .\NTFS.ps1 -Action 'Child-Audit' -Path '$Path2' to verify new permissions."
        }else{
            Write-Host "(OK) Execute .\NTFS.ps1 -Action 'Audit' -Path '$Path2' to verify new permissions."
        }
	}
   	Write-Host   
}

# Politique de sécurité faible
if ($Action -eq "Low") {
    Add-Content -Path 'log/log.txt' -value "[$actiondate] Application des paramètres du niveau de sécurité $Action sur '$Path'."
   	if($Language -eq 1036){
		Write-Host "(?)  Politique de sécurité faible :"
   		Write-Host "     $admins : Contrôle total"
   		Write-Host "     $usersA : Modification" 
   		Write-Host "     $users : Modification"
		Write-Host
		Write-Host "(!)  Application des paramètres du niveau de sécurité $Action sur '$Path'."
        Write-Host
	}elseif($Language -eq 1033){
		Write-Host "(?)  Low security level :"
		Write-Host "     $admins : Full Control" 
   		Write-Host "     $usersA : Modification"
   		Write-Host "     $users : Modification"
		Write-Host
		Write-Host "(!)  Applying new security level $Action settings on '$Path'."
        Write-Host
	}
    $begininvoke = Get-Date
    # On appelle le script correspondant au niveau de sécurité faible.
   	Invoke-Expression "levels\low-sec.ps1 -Path '$Path' -Recurse '$Recurse' -Account '$Account' -Language '$Language'"
    $endinvoke = Get-Date
    $invoketime = $endinvoke - $begininvoke
   	if($Language -eq 1036){
        Write-Host "     Permissions délivrées en : $invoketime."
        Write-Host
        if($Recurse){
            Write-Host "(OK) Exécuter .\NTFS.ps1 -Action 'Child-Audit' -Path '$Path' pour vérifier les nouvelles permissions."
        }else{
            Write-Host "(OK) Exécuter .\NTFS.ps1 -Action 'Audit' -Path '$Path' pour vérifier les nouvelles permissions."
        }
	}elseif($Language -eq 1033){
        Write-Host "    Permissions issued in : $invoketime."
        Write-Host
        if($Recurse){
		    Write-Host "(OK) Execute .\NTFS.ps1 -Action 'Child-Audit' -Path '$Path' to verify new permissions."
        }else{
            Write-Host "(OK) Execute .\NTFS.ps1 -Action 'Audit' -Path '$Path' to verify new permissions."
        }
	}
   	Write-Host
}

# Politique de sécurité modérée
if ($Action -eq "Medium") {
    Add-Content -Path 'log/log.txt' -value "[$actiondate] Application des paramètres du niveau de sécurité $Action sur '$Path'."
   	if($Language -eq 1036){
		Write-Host "(?)  Politique de sécurité modérée :"
   		Write-Host "     $admins : Contrôle total" 
   		Write-Host "     $usersA : Lecture et exécution"
   		Write-Host "     $users : Lecture et exécution"
		Write-Host
		Write-Host "(!)  Application des paramètres du niveau de sécurité $Action sur '$Path'."
        Write-Host
	}elseif($Language -eq 1033){
		Write-Host "(?)  Medium security level :"
		Write-Host "     $admins : Full Control" 
   		Write-Host "     $usersA : Read and execute"
   		Write-Host "     $users : Read and execute"
		Write-Host
		Write-Host "(!)  Applying new security level $Action settings on '$Path'."
        Write-Host
	}
    $begininvoke = Get-Date
   	Invoke-Expression "levels\medium-sec.ps1 -Path '$Path' -Recurse '$Recurse' -Account '$Account' -Language '$Language'"
   	$endinvoke = Get-Date
    $invoketime = $endinvoke - $begininvoke
    if($Language -eq 1036){
        Write-Host "     Permissions délivrées en : $invoketime."
        Write-Host
		if($Recurse){
            Write-Host "(OK) Exécuter .\NTFS.ps1 -Action 'Child-Audit' -Path '$Path' pour vérifier les nouvelles permissions."
        }else{
            Write-Host "(OK) Exécuter .\NTFS.ps1 -Action 'Audit' -Path '$Path' pour vérifier les nouvelles permissions."
        }
	}elseif($Language -eq 1033){
        Write-Host "     Permissions issued in : $invoketime."
        Write-Host
		if($Recurse){
		    Write-Host "(OK) Execute .\NTFS.ps1 -Action 'Child-Audit' -Path '$Path' to verify new permissions."
        }else{
            Write-Host "(OK) Execute .\NTFS.ps1 -Action 'Audit' -Path '$Path' to verify new permissions."
        }
	}
   	Write-Host
}

# Politique de sécurité élevée
if ($Action -eq "High") {
    Add-Content -Path 'log/log.txt' -value "[$actiondate] Application des paramètres du niveau de sécurité $Action sur '$Path'."
	if($Language -eq 1036){
   		Write-Host "(?)  Politique de sécurité élevée :"
   		Write-Host "     $admins : Contrôle total" 
   		Write-Host "     $usersA : Lecture seule"
   		Write-Host "     $users : Aucun droit"
		Write-Host
		Write-Host "(!)  Application des paramètres du niveau de sécurité $Action sur '$Path'."
        Write-Host
	}elseif($Language -eq 1033){
		Write-Host "(?)  High security level :"
   		Write-Host "     $admins : Full Control" 
   		Write-Host "     $usersA : Read-Only"
   		Write-Host "     $users : None Rights"
		Write-Host
		Write-Host "(!)  Applying new security level $Action settings on '$Path'."
        Write-Host
	}
    $begininvoke = Get-Date
   	Invoke-Expression "levels\high-sec.ps1 -Path '$Path' -Recurse '$Recurse' -Account '$Account' -Language '$Language'"
    $endinvoke = Get-Date
    $invoketime = $endinvoke - $begininvoke
   	if($Language -eq 1036){
        Write-Host "     Permissions délivrées en : $invoketime."
        Write-Host
		if($Recurse){
            Write-Host "(OK) Exécuter .\NTFS.ps1 -Action 'Child-Audit' -Path '$Path' pour vérifier les nouvelles permissions."
        }else{
            Write-Host "(OK) Exécuter .\NTFS.ps1 -Action 'Audit' -Path '$Path' pour vérifier les nouvelles permissions."
        }
	}elseif($Language -eq 1033){
        Write-Host "    Permissions issued in : $invoketime."
        Write-Host
		if($Recurse){
		    Write-Host "(OK) Execute .\NTFS.ps1 -Action 'Child-Audit' -Path '$Path' to verify new permissions."
        }else{
            Write-Host "(OK) Execute .\NTFS.ps1 -Action 'Audit' -Path '$Path' to verify new permissions."
        }
	}
   	Write-Host
}

# Audit (récursif ou non) des permissions NTFS du dossier et de ses enfants
if ($Action -eq "Child-Audit") { 
	if($Language -eq 1036){
        if($Recurse){
            Add-Content -Path 'log/log.txt' -value "[$actiondate] Audit récursif des permissions NTFS des enfants du répertoire '$Path'."
		    Write-Host "(~)  Audit récursif des permissions NTFS des enfants du répertoire '$Path'"
        }else{
            Add-Content -Path 'log/log.txt' -value "[$actiondate] Audit des permissions NTFS des enfants du répertoire '$Path'."
            Write-Host "(~)  Audit des permissions NTFS des enfants du répertoire '$Path'"
        }
    }elseif($Language -eq 1033){
        if($Recurse){
		    Write-Host "(~)  '$Path' children's NTFS permissions recursive audition."
        }else{
            Write-Host "(~)  '$Path' children's NTFS permissions audition."
        }
	}
	if($Language -eq 1036){
        Write-Host "     Importation des permissions NTFS des enfants du répertoire..."
    }elseif($Language -eq 1033){
        Write-Host "     Importing child NTFS permissions from folder..."
    }
    $auditdate = Get-Date -format "yyyy-MM-dd_HH-mm-ss"
	if($Recurse){
        
        # Déclaration d'un tableau vide
        $array = @()
        $i = 0
        $j = 0
        # Si le mode graphique est activé
        if($Graphical){
            # On affiche une barre de progression
            # Pour chaque objet contenu dans $ChildItemRecurse, on alimente le tableau $array des permissions NTFS de cet objet
            # On actualise le niveau d'avancement de l'opération et on l'affiche avec le cmdlet Write-Progress 
            $beginprintdate = Get-Date
            foreach($object in $ChildItemRecurse){
                $array += $object | Get-NTFSAccess | Select-Object -Property FullName, Account, AccessRights
                $i++
                $elapsed1 = (Get-Date) - $beginprintdate
                $prct1 = ($i / $counter * 100.0) 
                $totaltime1 = ($elapsed1.TotalSeconds) / ($prct1 / 100.0)
                $remain1 = $totaltime1 - $elapsed1.TotalSeconds
                $prct1 = [Math]::Round($prct1, 2)
                Write-Progress -Activity "Audit récursif des permissions NTFS des enfants du répertoire '$Path'..." -CurrentOperation "$prct1% achevé" -SecondsRemaining $remain1 -Status $object.FullName -PercentComplete $prct1
            }
            $endprintdate = Get-Date

        # Si le mode graphique est désactivé, on importe l'ensemble des résultats dans une seule variable pour gagner de la vitesse.
        }else{
            Write-Host
            Write-Host "     Importation en cours, veuillez patienter..."
            $beginprintdate = Get-Date
            $RecurseAudit = $ChildItemRecurse | Get-NTFSAccess | Select-Object -Property FullName, Account, AccessRights 
            Write-Host "     Tri des résultats..."
            Write-Host
            $RecurseAudit = $RecurseAudit | Sort-Object -Property FullName, Account
            $endprintdate = Get-Date
        }
        Write-Progress -Activity "Audit récursif des permissions NTFS des enfants du répertoire '$Path'..." -Completed
        $printtime = $endprintdate - $beginprintdate
        if($Language -eq 1036){
            Write-Host "     Importation effectuée en : $printtime."
	        Write-Host
        }elseif($Language -eq 1033){
            Write-Host "     Importation performed in : $printtime."
            Write-Host
        }
        Write-Host "     [1]     Afficher les permissions NTFS importées"
        Write-Host "     [2]     Exporter (.csv) les permissions NTFS importées"
        Write-Host
        $Choice = Read-Host -Prompt "     Faites votre choix [1/2] " 
        Write-Host
        $beginexporttime = Get-Date
        $begindate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        if($Choice -eq 1){
            Add-Content -Path 'log/log.txt' -value "[$begindate] Affichage des résultats de l'audit du répertoire '$Path'."
            if($Graphical){
                Write-Host "     Tri des résultats..."
                $array = $array | Sort-Object -Property FullName, Account
                Write-Host "     Affichage..."
                $array | Out-GridView -Title "Audit récursif des permissions NTFS du répertoire '$Path'"
            }else{
                Write-Host "     Affichage..."
                $RecurseAudit | Out-GridView -Title "Audit récursif des permissions NTFS du répertoire '$Path'"
            }
        }elseif($Choice -eq 2){
            $CsvFile = "export\export_$auditdate.csv"
            Add-Content -Path 'log/log.txt' -value "[$begindate] Exportation des résultats de l'audit du répertoire '$Path' dans le fichier $CsvFile."
            if($Graphical){
                Write-Host "     Tri des résultats..."
                $array = $array | Sort-Object -Property FullName, Account
                Write-Host "     Exportation..." 
                $array | Export-Csv $CsvFile -Encoding UTF8 -NoTypeInformation
            }else{
                Write-Host "     Exportation..."
                $RecurseAudit | Export-Csv $CsvFile -Encoding UTF8 -NoTypeInformation
            }
        }
        $endexporttime = Get-Date
    }else{
        $beginprintdate = Get-Date
        $NonRecurseAudit = $ChildItem | Get-NTFSAccess | Select-Object -Property FullName, Account, AccessRights | Sort-Object -Property FullName, Account
        $endprintdate = Get-Date
        $printtime = ($endprintdate - $beginprintdate)
        if($Language -eq 1036){
            Write-Host "     Importation effectuée en : $printtime."
	        Write-Host
            Write-Host "     [1]     Afficher les permissions NTFS importées"
            Write-Host "     [2]     Exporter (.csv) les permissions NTFS importées"
            Write-Host
        $Choice = Read-Host -Prompt "     Faites votre choix [1/2] "
        }elseif($Language -eq 1033){
            Write-Host "     Importation performed in : $printtime."
            Write-Host
            $Choice = Read-Host -Prompt "     Display or export (.csv) imported NTFS permissions ? [1/2] "
        }
        $beginexporttime = Get-Date
        if($Choice -eq 1){
            $NonRecurseAudit | Out-GridView
        }elseif($Choice -eq 2){
            $NonRecurseAudit | Export-Csv "export/export_'$auditdate'.csv" -Encoding UTF8 -NoTypeInformation
        }
        $endexporttime = Get-Date
	}
    $exporttime = $endexporttime - $beginexporttime
	$audittime = $counttime + $printtime + $exporttime

    if($CsvFile){
        $CsvFileLength = ("{0:N2}" -f ((Get-Item $CsvFile | Measure-Object -Property length -sum).sum / 1KB) + "Ko")
    }
    
	if($Language -eq 1036){
        if($CsvFile){
            Write-Host "     Exporté vers le fichier $CsvFile ($CsvFileLength)."
        }
        Write-Host "     Export effectué en : $exporttime."
	    Write-Host
	    Write-Host "(OK) Audit effectué en : $audittime."
	    Write-Host
    }elseif($Language -eq 1033){
        Write-Host "     Exportation performed in : $exporttime ($CsvFileLength)."
        Write-Host
        Write-Host "(OK) Audit performed in : $audittime."
        Write-Host
    }
}

# Audit des permissions NTFS du dossier
if ($Action -eq "Audit") {
	if($Language -eq 1036){
		Write-Host "(~)  Audit des permissions NTFS du répertoire '$Path'"
        Write-Host
	}elseif($Language -eq 1033){
		Write-Host "(~)  '$Path' NTFS permissions audition."
        Write-Host
	}
	if($Language -eq 1036){
        Write-Host "     Importation des permissions NTFS du répertoire..."
    }elseif($Language -eq 1033){
        Write-Host "     Importing child NTFS permissions from folder..."
    }
	$beginprintdate = Get-Date
	Get-NTFSAccess | Select-Object -Property Name, Account, AccessRights, Length | Sort-Object -Property Name, Account | Out-GridView
	$endprintdate = Get-Date
	$printtime = ($endprintdate - $beginprintdate)
	$audittime = $counttime + $printtime
	if($Language -eq 1036){
        Write-Host "     Importation effectuée en : $printtime."
	    Write-Host
	    Write-Host "(OK) Audit effectué en : $audittime."
	    Write-Host
    }elseif($Language -eq 1033){
        Write-Host "     Importation performed in : $printtime."
        Write-Host
        Write-Host "(OK) Audit performed in : $audittime."
        Write-Host
    }
}

if($Action -eq 'Recovery'){
    Add-Content -Path 'log/log.txt' -value "Restauration des permissions de la sauvegarde $Path..."
    if($Language -eq 1036){
        Write-Host "(~)  Ouverture de la sauvegarde des permissions contenues dans $Path..."
    }elseif($Language -eq 1033){
        Write-Host "(~)  Loading $Path permissions save..."
    }
    $beginprintdate = Get-Date
    if($Recovery = Import-Csv -Path $Path -Delimiter ","){
        $Recovery | Out-GridView
        $endprintdate = Get-Date
        $printtime = ($endprintdate - $beginprintdate)
        if($Language -eq 1036){
            Write-Host "     Chargement effectué en : $printtime."
        }elseif($Language -eq 1033){
            Write-Host "     Loaded in : $printtime."
        }
        Write-Host
        Write-Host "     Êtes-vous sûr de vouloir écraser les permissions actuelles ?"
        Write-Host
        Write-Host "     [y]     Ecraser les permissions actuelles"
        Write-Host "     [n]     Ne pas écraser les permissions actuelles"
        Write-Host
        $Choice = Read-Host -Prompt "     Faites votre choix [y/n] "
        if($Choice -eq 'y'){
            $begininvoke = Get-Date
            $RecoveryLength = $Recovery.Count
            foreach ($Data in $Recovery){ 
                $i++
                $AccountData = $Data.Account
                $DataFile = $Data.FullName
                $DataRight = $Data.AccessRights
                $prct = ($i / $RecoveryLength * 100.0)
                $elapsed = (Get-Date) - $beginprintdate 
                $totaltime = ($elapsed.TotalSeconds) / ($prct / 100.0)
                $remain = $totaltime - $elapsed.TotalSeconds
                Write-Progress -Activity "Restauration des permissions de la sauvegarde $Path..." -SecondsRemaining $remain -Status $DataFile -PercentComplete $prct
                Add-NTFSAccess -Path $DataFile -Account $AccountData -AccessRights $DataRight
            }
            $endinvoke = Get-Date
            $invoketime = $endinvoke - $begininvoke
            if($Language -eq 1036){
                Write-Host
                Write-Host "     Permissions restaurées en : $invoketime."
                Write-Host
            }elseif($Language -eq 1033){
                Write-Host
                Write-Host "     Permissions restaured in : $invoketime."
                Write-Host
            }
        }
    }
}

# SIG # Begin signature block
# MIIETQYJKoZIhvcNAQcCoIIEPjCCBDoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU0ms6roN1slSt5VqnyTm8213U
# HA6gggJQMIICTDCCAbmgAwIBAgIQJAmc9NnbXaZE0prhdWiNczAJBgUrDgMCHQUA
# MDMxMTAvBgNVBAMeKABOAFQARgBTAFAAcgBvAGoAZQBjAHQAIABNAEIAXwBKAFIA
# XwBBAEgwHhcNMTcwMTMxMjE0MDIxWhcNMzkxMjMxMjM1OTU5WjAfMR0wGwYDVQQD
# ExROVEZTLnBzMSBDZXJ0aWZpY2F0ZTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkC
# gYEAylGcUYBHeBYXNDr8BhE8zu6rFH4ho3USz+VEzVAFopgKa+gjFADsOTyT6tRR
# SkIlVHTbSpKYq+tHHXB1cxWcUE4BYWSJutAIjjGg9ouDj1HqIWiMltMIq33+Y7LW
# V1+o3BS/3nu+wmH21t1l4zUKUFOvC66Z/BilqyqMPE244W8CAwEAAaN9MHswEwYD
# VR0lBAwwCgYIKwYBBQUHAwMwZAYDVR0BBF0wW4AQW1Yba+TNBVxyLKXjdvAocqE1
# MDMxMTAvBgNVBAMeKABOAFQARgBTAFAAcgBvAGoAZQBjAHQAIABNAEIAXwBKAFIA
# XwBBAEiCEFBzJcVu2EmmQKiOJslwy9swCQYFKw4DAh0FAAOBgQBgR9MwXAJMrUha
# Ut7XKgmEkVPJVXPcAAEkBdbOPhZIa8Fl3d1bJmorMPmfElN3LEJHczISv7xz9rhZ
# CfAvjRKhtkB5m64+ksaBHfZWYdtMlGWU5Yta3orX6otO4qUkzUzhxXaaCdWJQVX4
# QJVbL3m9gu17SMd2ED2Byz2TDEvgxzGCAWcwggFjAgEBMEcwMzExMC8GA1UEAx4o
# AE4AVABGAFMAUAByAG8AagBlAGMAdAAgAE0AQgBfAEoAUgBfAEEASAIQJAmc9Nnb
# XaZE0prhdWiNczAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKA
# ADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYK
# KwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU0amjSrVTXkhC7dXnPFGyRNGGUOow
# DQYJKoZIhvcNAQEBBQAEgYCQNjleHRMYM5PA8rSPFthmUe3jwuNk+JCbgdcayRd5
# HzPf9KpKUXQ+HQuNBn/U8aC0zqZ3Jd+/ITdjSQF5ZUHuToQWLI/PBn28xPey7OCm
# kJfCrJp1+2xnpP6WGgE74nxzawxCNUOOdQg3kfa933xhWlLY3oMjCgXUUFAttYvk
# kg==
# SIG # End signature block
