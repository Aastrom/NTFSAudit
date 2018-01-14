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
    if($Account -eq $users){
        if($Language -eq 1036){
	        Write-Host "     Lecture et exécution pour $users..."
        }elseif($Language -eq 1033){
	        Write-Host "     Read and execute for $users..."
        }
        if($Recurse){
            Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Modify
            Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Write
            $ChildItemRecurse | Remove-NTFSAccess -Account $users  -AccessRights Modify
            $ChildItemRecurse | Remove-NTFSAccess -Account $users  -AccessRights Write

            Add-NTFSAccess    -Path $Path -Account $users  -AccessRights Read
            Add-NTFSAccess    -Path $Path -Account $users  -AccessRights Execute
            $ChildItemRecurse | Add-NTFSAccess    -Account $users  -AccessRights Read
            $ChildItemRecurse | Add-NTFSAccess    -Account $users  -AccessRights Execute
        }else{
            Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Modify
            Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Write
            Add-NTFSAccess    -Path $Path -Account $users  -AccessRights Read
            Add-NTFSAccess    -Path $Path -Account $users  -AccessRights Execute
        }
        Write-Host

    }elseif($Account -eq $usersA){
        if($Language -eq 1036){
	        Write-Host "    Lecture et exécution pour $usersA..."
        }elseif($Language -eq 1033){
	        Write-Host "    Read and execution for $usersA..."
        }
        if($Recurse){
            Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Write
            Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Modify
            Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Synchronize
            $ChildItemRecurse | Remove-NTFSAccess -Account $usersA -AccessRights Write
            $ChildItemRecurse | Remove-NTFSAccess -Account $usersA -AccessRights Modify
            $ChildItemRecurse | Remove-NTFSAccess -Account $usersA -AccessRights Synchronize

            Add-NTFSAccess    -Path $Path -Account $usersA -AccessRights Execute
            Add-NTFSAccess    -Path $Path -Account $usersA -AccessRights Read
            $ChildItemRecurse | Add-NTFSAccess    -Account $usersA -AccessRights Execute
            $ChildItemRecurse | Add-NTFSAccess    -Account $usersA -AccessRights Read
        }else{
            Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Write
            Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Modify
            Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Synchronize
            Add-NTFSAccess    -Path $Path -Account $usersA -AccessRights Execute
            Add-NTFSAccess    -Path $Path -Account $usersA -AccessRights Read
        }
        Write-Host

    }elseif($Account -eq $system){
        if($Language -eq 1036){
	        Write-Host "     Lecture et exécution pour $system..."
        }elseif($Language -eq 1033){
	        Write-Host "     Read and execution for $system..."
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
	        Write-Host "     Contrôle total pour $admins..."
        }elseif($Language -eq 1033){
	        Write-Host "     Full Control for $admins..."
        }
        if($Recurse){
            Add-NTFSAccess    -Path $Path -Account $admins -AccessRights FullControl
            $ChildItemRecurse | Add-NTFSAccess -Account $admins -AccessRights FullControl
        }else{
            Add-NTFSAccess    -Path $Path -Account $admins -AccessRights FullControl
        }
        Write-Host

    }else{
        if($Language -eq 1036){
	        Write-Host "     Lecture et exécution pour $Account..."
        }elseif($Language -eq 1033){
	        Write-Host "     Read and execute for $Account..."
        }
        if($Recurse){
            Remove-NTFSAccess -Path $Path -Account $Account  -AccessRights Modify
            Remove-NTFSAccess -Path $Path -Account $Account  -AccessRights Write
            $ChildItemRecurse | Remove-NTFSAccess -Account $Account  -AccessRights Modify
            $ChildItemRecurse | Remove-NTFSAccess -Account $Account  -AccessRights Write

            Add-NTFSAccess    -Path $Path -Account $Account  -AccessRights Read
            Add-NTFSAccess    -Path $Path -Account $Account  -AccessRights Execute
            $ChildItemRecurse | Add-NTFSAccess    -Account $Account  -AccessRights Read
            $ChildItemRecurse | Add-NTFSAccess    -Account $Account  -AccessRights Execute
        }else{
            Remove-NTFSAccess -Path $Path -Account $Account  -AccessRights Modify
            Remove-NTFSAccess -Path $Path -Account $Account  -AccessRights Write
            $ChildItemRecurse | Remove-NTFSAccess -Account $Account  -AccessRights Modify
            $ChildItemRecurse | Remove-NTFSAccess -Account $Account  -AccessRights Write
        }
        Write-Host
    }

}else{

    if($Language -eq 1036){
	    Write-Host "     Lecture et exécution pour $users..."
    }elseif($Language -eq 1033){
	    Write-Host "     Read and execute for $users..."
    }  
    if($Recurse){
        Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Modify
        Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Write
        $ChildItemRecurse | Remove-NTFSAccess -Account $users  -AccessRights Modify
        $ChildItemRecurse | Remove-NTFSAccess -Account $users  -AccessRights Write

        Add-NTFSAccess    -Path $Path -Account $users  -AccessRights Read
        Add-NTFSAccess    -Path $Path -Account $users  -AccessRights Execute
        $ChildItemRecurse | Add-NTFSAccess    -Account $users  -AccessRights Read
        $ChildItemRecurse | Add-NTFSAccess    -Account $users  -AccessRights Execute
    }else{
        Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Modify
        Remove-NTFSAccess -Path $Path -Account $users  -AccessRights Write
        Add-NTFSAccess    -Path $Path -Account $users  -AccessRights Read
        Add-NTFSAccess    -Path $Path -Account $users  -AccessRights Execute
    }

    if($Language -eq 1036){
	    Write-Host "     Lecture et exécution pour $usersA..."
    }elseif($Language -eq 1033){
	    Write-Host "     Read and execution for $usersA..."
    }
    if($Recurse){
        Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Write
        Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Modify
        Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Synchronize
        $ChildItemRecurse | Remove-NTFSAccess -Account $usersA -AccessRights Write
        $ChildItemRecurse | Remove-NTFSAccess -Account $usersA -AccessRights Modify
        $ChildItemRecurse | Remove-NTFSAccess -Account $usersA -AccessRights Synchronize

        Add-NTFSAccess    -Path $Path -Account $usersA -AccessRights Execute
        Add-NTFSAccess    -Path $Path -Account $usersA -AccessRights Read
        $ChildItemRecurse | Add-NTFSAccess    -Account $usersA -AccessRights Execute
        $ChildItemRecurse | Add-NTFSAccess    -Account $usersA -AccessRights Read
    }else{
        Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Write
        Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Modify
        Remove-NTFSAccess -Path $Path -Account $usersA -AccessRights Synchronize
        Add-NTFSAccess    -Path $Path -Account $usersA -AccessRights Execute
        Add-NTFSAccess    -Path $Path -Account $usersA -AccessRights Read
    }
    
    if($Language -eq 1036){
	    Write-Host "     Lecture et exécution pour $system..."
    }elseif($Language -eq 1033){
	    Write-Host "     Read and execution for $system..."
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
	    Write-Host "     Contrôle total pour $admins..."
    }elseif($Language -eq 1033){
	    Write-Host "     Full Control for $admins..."
    }
    if($Recurse){
        Add-NTFSAccess    -Path $Path -Account $admins -AccessRights FullControl
        $ChildItemRecurse | Add-NTFSAccess -Account $admins -AccessRights FullControl
    }else{
        Add-NTFSAccess    -Path $Path -Account $admins -AccessRights FullControl
    }
    Write-Host
}
