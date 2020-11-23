#Chemin d’accès vers un fichier d’importation CSV
$ADUsers = Import-csv .\users_list.csv

foreach ($User in $ADUsers)
{
    $Username    = $User.username
    $Password    = $User.password
    $Firstname   = $User.firstname
    $Lastname    = $User.lastname
    $Department  = $User.department
    $OU          = $User.ou

    #Si le compte utilisateur existe déjà dans AD
    if (Get-ADUser -F {SamAccountName -eq $Username})
    {
        #Si l’utilisateur existe: message d’avertissement
        Write-Warning "User $Username has already exist."
    }
    else
    {
        #Si l'utilisateur n’existe pas:  nouveau compte utilisateur
        #Le compte sera créé dans l’unité d’organisation indiquée dans la variable $OU du fichier CSV 
        New-ADUser `
        -SamAccountName $Username `
        -UserPrincipalName "$Username@mondomaine.com" `
        -Name "$Firstname $Lastname" `
        -GivenName $Firstname `
        -Surname $Lastname `
        -Enabled $True `
        -ChangePasswordAtLogon $True `
        -DisplayName "$Lastname, $Firstname" `
        -Department $Department `
        -Path $OU `
        -AccountPassword (convertto-securestring $Password -AsPlainText -Force)

        Write-Host "User $Username added."
    }
}


