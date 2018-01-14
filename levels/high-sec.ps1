#   *** Politique de sécurité Haute ***
#
# Utilisateurs : Aucun droit
# Utilisateurs Authentifiés : Lecture seule
# Système : Lecture et exécution
# Administrateurs : Contrôle total
# $Account : Lecture seule

[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True)]
	[String]$Path,
    [String]$Language,
    [Parameter(Mandatory=$False)]
	[String]$Recurse,
	[String]$Account
)

# Encodage UTF-8
$OutputEncoding = New-Object -typename System.Text.UTF8Encoding
[Console]::OutputEncoding = New-Object -typename System.Text.UTF8Encoding

# Suppression de l'héritage de permissions NTFS
Disable-NTFSAccessInheritance -Path $Path

if($Account){
    # Si l'argument $Account a été renseigné, et s'il correspond à un objet de type
    # "Comptes d'utilisateurs" défini, appliquer la politique de sécurité Haute en vigueur pour ce type de compte.
    # Par défaut, si $Account ne correspond à aucun objet préalablement défini,
    # il hérite des mêmes permissions que celles des Utilisateurs Authentifiés.

	if($Language -eq 1036){
		Write-Host "     Suppression de permissions pour $Account..."
	}elseif($Language -eq 1033){
		Write-Host "     Erasing rights for $Account..."
	}
    if($Account -eq $users){
        if($Language -eq 1036){
	        Write-Host "     Suppression de tous les droits pour $users..."
	    }elseif($Language -eq 1033){
		    Write-Host "     Erasing all rights for $users..."
	    }
		if($Recurse){
            Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Modify
		    Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Write
		    Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Read
		    Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Execute
		    Remove-NTFSAccess -Path $Path -Account $users  -AccessRights FullControl
            $ChildItemRecurse | Remove-NTFSAccess -Account $users  -AccessRights Modify
		    $ChildItemRecurse | Remove-NTFSAccess -Account $users  -AccessRights Write
		    $ChildItemRecurse | Remove-NTFSAccess -Account $users  -AccessRights Read
		    $ChildItemRecurse | Remove-NTFSAccess -Account $users  -AccessRights Execute
		    $ChildItemRecurse | Remove-NTFSAccess -Account $users  -AccessRights FullControl
        }else{
            Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Modify
		    Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Write
		    Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Read
		    Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Execute
		    Remove-NTFSAccess -Path $Path -Account $users  -AccessRights FullControl
        }
        Write-Host

    }elseif($Account -eq $usersA){
        if($Language -eq 1036){
	        Write-Host "     Autorisation en lecture seule pour $usersA..."
	    }elseif($Language -eq 1033){
	        Write-Host "     Read-only authorization for $usersA..."
	    }
        if($Recurse){
            Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Modify
	        Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Write
	        Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Execute
	        Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights FullControl
            $ChildItemRecurse | Remove-NTFSAccess -Account $usersA -AccessRights Modify
	        $ChildItemRecurse | Remove-NTFSAccess -Account $usersA -AccessRights Write
	        $ChildItemRecurse | Remove-NTFSAccess -Account $usersA -AccessRights Execute
	        $ChildItemRecurse | Remove-NTFSAccess -Account $usersA -AccessRights FullControl
            Add-NTFSAccess    -Path $Path -Account $usersA -AccessRights Read
	        $ChildItemRecurse | Add-NTFSAccess    -Account $usersA -AccessRights Read
            
        }else{
            Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Modify
	        Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Write
	        Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Execute
	        Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights FullControl
	        Add-NTFSAccess    -Path $Path -Account $usersA -AccessRights Read
        }   
        Write-Host

    }elseif($Account -eq $system){
        if($Language -eq 1036){
	        Write-Host "     Autorisation en lecture et exécution pour $system..."
	    }elseif($Language -eq 1033){
	        Write-Host "     Read and execution authorization for $system..."
	    }
        if($Recurse){
            Remove-NTFSAccess -Path $Path -Account $system -AccessRights Write
	        Remove-NTFSAccess -Path $Path -Account $system -AccessRights Modify
            $ChildItemRecurse | Remove-NTFSAccess -Account $system -AccessRights Write
	        $ChildItemRecurse | Remove-NTFSAccess -Account $system -AccessRights Modify
            Add-NTFSAccess    -Path $Path -Account $system -AccessRights Execute
	        Add-NTFSAccess    -Path $Path -Account $system -AccessRights Read
	        $ChildItemRecurse | Add-NTFSAccess    -Account $system -AccessRights Execute
	        $ChildItemRecurse | Add-NTFSAccess    -Account $system -AccessRights Read
        }else{
            Remove-NTFSAccess -Path $Path -Account $system -AccessRights Write
	        Remove-NTFSAccess -Path $Path -Account $system -AccessRights Modify
	        Add-NTFSAccess    -Path $Path -Account $system -AccessRights Execute
	        Add-NTFSAccess    -Path $Path -Account $system -AccessRights Read
        }
        Write-Host

    }elseif($Account -eq $admins){
        if($Language -eq 1036){
	        Write-Host "     Autorisation en Contrôle total pour $admins..."
	    }elseif($Language -eq 1033){
	        Write-Host "     Full Control athorization for $admins..."
	    }
        if($Recurse){
            Add-NTFSAccess    -Path $Path -Account $admins -AccessRights FullControl
            $ChildItemRecurse | Add-NTFSAccess    -Account $admins -AccessRights FullControl
        }else{
            Add-NTFSAccess    -Path $Path -Account $admins -AccessRights FullControl
        }
        Write-Host

    }else{
       if($Language -eq 1036){
	        Write-Host "     Lecture seule pour $Account..."
	   }elseif($Language -eq 1033){
	        Write-Host "     Read-only for $Account..."
	   }
       if($Recurse){
           Remove-NTFSAccess -Path $Path -Account $Account -AccessRights Modify
           Remove-NTFSAccess -Path $Path -Account $Account -AccessRights Modify
           Remove-NTFSAccess -Path $Path -Account $Account -AccessRights Execute
           Remove-NTFSAccess -Path $Path -Account $Account -AccessRights FullControl
           $ChildItemRecurse | Remove-NTFSAccess -Account $Account -AccessRights Modify
	       $ChildItemRecurse | Remove-NTFSAccess -Account $Account -AccessRights Modify
	       $ChildItemRecurse | Remove-NTFSAccess -Account $Account -AccessRights Execute
	       $ChildItemRecurse | Remove-NTFSAccess -Account $Account -AccessRights FullControl
           Add-NTFSAccess    -Path $Path -Account $Account -AccessRights Read
	       $ChildItemRecurse | Add-NTFSAccess    -Account $Account -AccessRights Read
       }else{
           Remove-NTFSAccess -Path $Path -Account $Account -AccessRights Modify
           Remove-NTFSAccess -Path $Path -Account $Account -AccessRights Modify
           Remove-NTFSAccess -Path $Path -Account $Account -AccessRights Execute
           Remove-NTFSAccess -Path $Path -Account $Account -AccessRights FullControl
           Add-NTFSAccess    -Path $Path -Account $Account -AccessRights Read
       }
       Write-Host
    }

}else{
    # Si l'argument $Account n'a pas été renseigné, appliquer la politique de 
    # sécurité Haute en vigueur pour tous les objets de type "Comptes d'Utilisateurs" préalablement définis. 

    if($Language -eq 1036){
	    Write-Host "     Suppression de tous les droits pour $users..."
	}elseif($Language -eq 1033){
	    Write-Host "     Erasing all rights for $users..."
	}
	if($Recurse){
        Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Modify
		Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Write
		Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Read
		Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Execute
		Remove-NTFSAccess -Path $Path -Account $users  -AccessRights FullControl
        $ChildItemRecurse | Remove-NTFSAccess -Account $users  -AccessRights Modify
		$ChildItemRecurse | Remove-NTFSAccess -Account $users  -AccessRights Write
		$ChildItemRecurse | Remove-NTFSAccess -Account $users  -AccessRights Read
		$ChildItemRecurse | Remove-NTFSAccess -Account $users  -AccessRights Execute
		$ChildItemRecurse | Remove-NTFSAccess -Account $users  -AccessRights FullControl
    }else{
        Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Modify
	    Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Write
        Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Read
	    Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Execute
	    Remove-NTFSAccess -Path $Path -Account $users  -AccessRights FullControl
    }

	if($Language -eq 1036){
		Write-Host "     Autorisation en lecture seule pour $usersA..."
	}elseif($Language -eq 1033){
		Write-Host "     Read-only authorization for $usersA..."
	}
	if($Recurse){
        Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Modify
        Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Write
	    Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Execute
	    Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights FullControl
        $ChildItemRecurse | Remove-NTFSAccess -Account $usersA -AccessRights Modify
	    $ChildItemRecurse | Remove-NTFSAccess -Account $usersA -AccessRights Write
	    $ChildItemRecurse | Remove-NTFSAccess -Account $usersA -AccessRights Execute
	    $ChildItemRecurse | Remove-NTFSAccess -Account $usersA -AccessRights FullControl
	    Add-NTFSAccess    -Path $Path -Account $usersA -AccessRights Read
        $ChildItemRecurse | Add-NTFSAccess    -Account $usersA -AccessRights Read
    }else{
        Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Modify
	    Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Write
	    Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Execute
	    Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights FullControl
	    Add-NTFSAccess    -Path $Path -Account $usersA -AccessRights Read
    }

	if($Language -eq 1036){
		Write-Host "     Autorisation en lecture et exécution pour $system..."
	}elseif($Language -eq 1033){
		Write-Host "     Read and execution authorization for $system..."
	}
	if($Recurse){
        Remove-NTFSAccess -Path $Path -Account $system -AccessRights Write
	    Remove-NTFSAccess -Path $Path -Account $system -AccessRights Modify
        $ChildItemRecurse | Remove-NTFSAccess -Account $system -AccessRights Write
	    $ChildItemRecurse | Remove-NTFSAccess -Account $system -AccessRights Modify
        Add-NTFSAccess    -Path $Path -Account $system -AccessRights Execute
	    Add-NTFSAccess    -Path $Path -Account $system -AccessRights Read
	    $ChildItemRecurse | Add-NTFSAccess    -Account $system -AccessRights Execute
	    $ChildItemRecurse | Add-NTFSAccess    -Account $system -AccessRights Read      
    }else{
        Remove-NTFSAccess -Path $Path -Account $system -AccessRights Write
	    Remove-NTFSAccess -Path $Path -Account $system -AccessRights Modify
	    Add-NTFSAccess    -Path $Path -Account $system -AccessRights Execute
	    Add-NTFSAccess    -Path $Path -Account $system -AccessRights Read
    }

	if($Language -eq 1036){
		Write-Host "     Autorisation en contrôle total pour $admins..."
	}elseif($Language -eq 1033){
		Write-Host "     Full Control authorization for $admins..."
	}
	if($Recurse){
        Add-NTFSAccess    -Path $Path -Account $admins -AccessRights FullControl
        $ChildItemRecurse | Add-NTFSAccess    -Account $admins -AccessRights FullControl
    }else{
        Add-NTFSAccess    -Path $Path -Account $admins -AccessRights FullControl
    }
	Write-Host
}
