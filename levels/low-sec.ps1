[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True)]
	[String]$Path,
	[String]$language,
	[Parameter(Mandatory=$False)]
    [String]$Recurse,
	[String]$Account
	
)

#Encodage UTF-8
$OutputEncoding = New-Object -typename System.Text.UTF8Encoding
[Console]::OutputEncoding = New-Object -typename System.Text.UTF8Encoding

# Suppression de l'héritage de permissions NTFS
Disable-NTFSAccessInheritance -Path $Path

if($Account){  
    if($Account -eq $users){
        if($Language -eq 1036){
	       Write-Host "     Autorisation de modification pour $users..."
        }elseif($Language -eq 1033){
	        Write-Host "     Allowing modification for $users..."
        }
        if($Recurse){
            Add-NTFSAccess -Path $Path -Account $users  -AccessRights Modify
            $ChildItemRecurse | Add-NTFSAccess    -Account $users  -AccessRights Modify 
        }else{
            Add-NTFSAccess -Path $Path -Account $users  -AccessRights Modify
        }
        Write-Host
    }elseif($Account -eq $usersA){
        if($language -eq 1036){
	        Write-Host "     Autorisation de modification pour $usersA..."
        }elseif($language -eq 1033){
	        Write-Host "     Allowing modification for $usersA..."
        }
        if($Recurse){
            Add-NTFSAccess    -Path $Path -Account $usersA -AccessRights Modify
            $ChildItemRecurse | Add-NTFSAccess    -Account $usersA  -AccessRights Modify
        }else{
            Add-NTFSAccess    -Path $Path -Account $usersA -AccessRights Modify
        }
        Write-Host
    }elseif($Account -eq $system){
        if($language -eq 1036){
	        Write-Host "     Autorisation de contrôle total pour $system..."
        }elseif($language -eq 1033){
	        Write-Host "     Full Control for $system..."
        }
        if($Recurse -eq 'yes'){
            Add-NTFSAccess    -Path $Path -Account $system -AccessRights FullControl
            $ChildItemRecurse | Add-NTFSAccess    -Account $system  -AccessRights FullControl
        }else{
            Add-NTFSAccess    -Path $Path -Account $system -AccessRights FullControl
        }
        Write-Host
    }elseif($Account -eq $admins){
        if($language -eq 1036){
	        Write-Host "     Autorisation de contrôle total pour $admins..."
        }elseif($language -eq 1033){
	        Write-Host "     Full Control for $admins..."
        }
        if($Recurse -eq 'yes'){
            Add-NTFSAccess    -Path $Path -Account $admins -AccessRights FullControl
            $ChildItemRecurse | Add-NTFSAccess    -Account $admins  -AccessRights FullControl
        }else{
            Add-NTFSAccess    -Path $Path -Account $admins -AccessRights FullControl
        }
        Write-Host
    }else{
        if($Language -eq 1036){
	       Write-Host "     Autorisation de modification pour $Account..."
        }elseif($Language -eq 1033){
	        Write-Host "     Allowing modification for $Account..."
        }
        if($Recurse){
            Add-NTFSAccess -Path $Path -Account $Account  -AccessRights Modify
            $ChildItemRecurse | Add-NTFSAccess    -Account $Account  -AccessRights Modify
        }else{
            Add-NTFSAccess -Path $Path -Account $Account  -AccessRights Modify
        }
        Write-Host
    }

}else{

    # Modification autorisée pour les Utilisateurs

    if($language -eq 1036){
	    Write-Host "     Autorisation de modification pour $users..."
    }elseif($language -eq 1033){
	    Write-Host "     Allowing modification for $users..."
    }
    if($Recurse){
        Add-NTFSAccess    -Path $Path -Account $users -AccessRights Modify
        $ChildItemRecurse | Add-NTFSAccess    -Account $users  -AccessRights Modify
    }else{
        Add-NTFSAccess    -Path $Path -Account $users -AccessRights Modify
    }


    # Modification autorisée pour les Utilisateurs Authentifiés
 
    if($language -eq 1036){
	    Write-Host "     Autorisation de modification pour $usersA..."
    }elseif($language -eq 1033){
	    Write-Host "     Allowing modification for $usersA..."
    }
    if($Recurse){
        Add-NTFSAccess    -Path $Path -Account $usersA -AccessRights Modify
        $ChildItemRecurse | Add-NTFSAccess    -Account $usersA  -AccessRights Modify
    }else{
        Add-NTFSAccess    -Path $Path -Account $usersA -AccessRights Modify
    }


    # Contrôle total pour le Système

    if($language -eq 1036){
	    Write-Host "     Autorisation de contrôle total pour $system..."
    }elseif($language -eq 1033){
	    Write-Host "     Full Control for $system..."
    }
    if($Recurse){
        Add-NTFSAccess    -Path $Path -Account $system -AccessRights FullControl
        $ChildItemRecurse | Add-NTFSAccess    -Account $system  -AccessRights FullControl
    }else{
        Add-NTFSAccess    -Path $Path -Account $system -AccessRights FullControl
    }


    # Contrôle total pour les Administrateurs

    if($language -eq 1036){
	    Write-Host "     Autorisation de contrôle total pour $admins..."
    }elseif($language -eq 1033){
	    Write-Host "     Full Control for $admins..."
    }
    if($Recurse){
        Add-NTFSAccess    -Path $Path -Account $admins -AccessRights FullControl
        $ChildItemRecurse | Add-NTFSAccess    -Account $admins  -AccessRights FullControl
    }else{
        Add-NTFSAccess    -Path $Path -Account $admins -AccessRights FullControl
    }

    Write-Host
}