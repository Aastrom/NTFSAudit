# NTFSProject

Auditing and changing massive NTFS permissions on a Windows directory



SYNTAX : 

	.\NTFS.ps1 -Action '[ ACL | Audit | Child-Audit | High | Medium | Low ]' -Path '[Directory]' -Path2 '[Directory]' -Recurse '[yes]' -Account '[Account]'
	
	

PARAMETERS :

	- Action -
	
		- ACL -           Applying a $Path type text ACL to the $Path2 directory. Accepts recursion.
              			  
				  Text file syntax : $Account ($Right [Allow | Deny]) $Access
	             		  Example : Users Allow Modify --> Add-NTFSAccess -Path $Path2 -Account $Account -Recurse $Recurse -AccessRights $Access


		- Audit -         Auditing NTFS permissions in the $Path directory.


		- Child-Audit -   Recursive audit of NTFS permissions in the $Path directory 


		- Help -	  Displays this help panel. :)
 

		- High -          Application of the high security policy (levels / high-sec.ps1).
				  Users: No rights
				  Authenticated Users: Read-only
				  System: Read and Execution
				  Administrators: Full Control
				  Other: Read-only

		- Medium -        Application of the moderate security policy (levels/medium-sec.ps1).
			          Users : Read-only
			          Authenticated Users : Read-only
			          System : Read and Execution
			          Administrateurs : Full Control


		- Low -           Application of the weak security policy (levels/low-sec.ps1).
			          Users : Modification
			          Authenticated Users : Modification
			          System : Full Control
			          Administrators : Full Control


	- Path - 	Specifies the directory in which the action should be performed. 
			If $Action = 'ACL', $Path indicates the path of the user text file containing the ACLs to apply the $Path2 directory.


	- Path2 -       Specifies the directory in which the ACLs in the text file specified in $Path are to be applied.


	- Recurse -     Enables recursion if not empty.


	- Account -     Specifies the user object for which the action is to be performed.




EXAMPLES :

	- 1 - 		.\NTFS.ps1 -Action 'Child-Audit' -Path 'C:\' -Recurse 'yes'
			Recursive audit of the C: \ system partition.

	- 2 - 		.\NTFS.ps1 -Action 'ACL' -Path 'C:\Users\user\acl.txt' -Path2 'D:\Files' -Recurse 'yes'
			Recursive application of the rights proposed by the user in the text file acl.txt on the directory D:\Files.

	- 3 - 		.\NTFS.ps1 -Action 'High' -Path 'D:\' -Recurse 'yes'
			Recursive application of the rights proposed by the high security policy on the D:\ partition, all users of the system combined.




SEE ALSO :

https://github.com/raandree/NTFSSecurity 


