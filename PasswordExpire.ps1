param(
	[Parameter(Mandatory=$True,Position=1)]
		[string]$user,
	[Parameter(Mandatory=$True,Position=2)]
		[string]$PasswordExpireTime,
	[Parameter(Mandatory=$False,Position=3)]
		[bool]$Reset
		
)

import-module activedirectory

$userDetails=(get-aduser $user -properties *)
$userFirstName=$userDetails.GivenName
$userLastName=$userDetails.Surname
$userFullName="$userFirstName $userLastName"

$PasswordNeverExpires=(get-aduser -identity $user -properties passwordneverexpires | select passwordneverexpires).passwordneverexpires



$PasswordLastSet=(get-aduser -identity $user -properties PasswordLastSet | select PasswordLastSet).PasswordLastSet
$PasswordExpires=($PasswordLastSet).AddDays($PasswordExpireTime)
$TodaysDate=(date)
$AsOfDate=$TodaysDate.DateTime

$TotalDaysLastSet=($TodaysDate - $PasswordLastSet)

$PLSDays=($TodaysDate - $PasswordLastSet).days
$PLSHours=($TodaysDate - $PasswordLastSet).hours
$PLSMinutes=($TodaysDate - $PasswordLastSet).minutes
$PLSSeconds=($TodaysDate - $PasswordLastSet).seconds

$PEDays=($PasswordExpires - $TodaysDate).days
$PEHours=($PasswordExpires - $TodaysDate).hours
$PEMinutes=($PasswordExpires - $TodaysDate).minutes
$PESeconds=($PasswordExpires - $TodaysDate).seconds



cls
echo "User: $userFullName"
echo "Alias: $user"
echo "Password Last Set: $PasswordLastSet"

if($Reset -eq $True){
	echo ""
	echo "You have chosen to reset $userFullName's password."
	$newPWD1=read-host -assecurestring "Please enter the new password for $userFirstName"
		$newPWD2=read-host -assecurestring "Please confirm the new password for $userFirstName"
		$newPWD1_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPWD1))
		$newPWD2_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPWD2))

		echo ""
		if("$newPWD1_text" -ne "$newPWD2_text"){
			do{
				cls
				echo "User: $user"
				echo "Password Last Set: $PasswordLastSet"
				echo "The users' password expired $ToDays days, $ToHours hours, $ToMinutes minutes, and $ToSeconds seconds ago."
				echo ""
				echo "You are currently resetting it."
				echo ""
				echo ""
				$newPWD1=read-host -assecurestring "Unfortunately, the two passwords you entered did not match.`n`nPlease enter the new password for $userFirstName"
				$newPWD2=read-host -assecurestring "Please confirm the new password for $userFirstName"
				$newPWD1_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPWD1))
				$newPWD2_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPWD2))
				echo ""
			} while("$newPWD1_text" -ne "$newPWD2_text")
		}
		do{
			$newPWD=$newPWD1
			Set-ADAccountPassword $user -reset -newpassword $newPWD
			$newPWD1_text=1
			$newPWD2_text=2
			echo ""
		} while("$newPWD1_text" -eq "$newPWD2_text")
		$newPWD1_text=$null
		$newPWD2_text=$null
		$newPWD1=$null
		$newPWD2=$null
		$newPWD=$null
		$NewExpireDate=((date).adddays(90))
		$NewExpireDateDay=$NewExpireDate.day
		$NewExpireDateMonth=$NewExpireDate.month
		$NewExpireDateYear=$NewExpireDate.year

		echo "The password for $userFirstName` has been reset and will expire on $NewExpireDateMonth`\$NewExpireDateDay`\$NewExpireDateYear"
		echo ""
		echo ""
}
else{


if($PasswordNeverExpires -eq "False"){

echo "Password Expires: This users' password never expires"
echo ""

}
elseif($TotalDaysLastSet.days -gt "$PasswordExpireTime"){

$ToDays=($PasswordExpires - $TodaysDate).days -replace "-",""
$ToHours=($PasswordExpires - $TodaysDate).hours -replace "-",""
$ToMinutes=($PasswordExpires - $TodaysDate).minutes -replace "-",""
$ToSeconds=($PasswordExpires - $TodaysDate).seconds -replace "-",""

echo "The users' password expired $ToDays days, $ToHours hours, $ToMinutes minutes, and $ToSeconds seconds ago."
echo ""

$resetPWD=read-host "Do you want to reset $userFirstName`'s password? (Yes or No)"
echo ""
	if($resetPWD -eq "Yes" -or $resetPWD -eq "Y" -or $resetPWD -eq "yes" -or $resetPWD -eq "y"){
		$newPWD1=read-host -assecurestring "Please enter the new password for $userFirstName"
		$newPWD2=read-host -assecurestring "Please confirm the new password for $userFirstName"
		$newPWD1_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPWD1))
		$newPWD2_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPWD2))

		echo ""
		if("$newPWD1_text" -ne "$newPWD2_text"){
			do{
				cls
				echo "User: $user"
				echo "Password Last Set: $PasswordLastSet"
				echo "The users' password expired $ToDays days, $ToHours hours, $ToMinutes minutes, and $ToSeconds seconds ago."
				echo ""
				echo "You are currently resetting it."
				echo ""
				echo ""
				$newPWD1=read-host -assecurestring "Unfortunately, the two passwords you entered did not match.`n`nPlease enter the new password for $userFirstName"
				$newPWD2=read-host -assecurestring "Please confirm the new password for $userFirstName"
				$newPWD1_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPWD1))
				$newPWD2_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPWD2))
				echo ""
			} while("$newPWD1_text" -ne "$newPWD2_text")
		}
		do{
			$newPWD=$newPWD1
			Set-ADAccountPassword $user -reset -newpassword $newPWD
			$newPWD1_text=1
			$newPWD2_text=2
			echo ""
		} while("$newPWD1_text" -eq "$newPWD2_text")
		$newPWD1_text=$null
		$newPWD2_text=$null
		$newPWD1=$null
		$newPWD2=$null
		$newPWD=$null
		$NewExpireDate=((date).adddays(90))
		$NewExpireDateDay=$NewExpireDate.day
		$NewExpireDateMonth=$NewExpireDate.month
		$NewExpireDateYear=$NewExpireDate.year

		echo "The password for $userFirstName` has been reset and will expire on $NewExpireDateMonth`\$NewExpireDateDay`\$NewExpireDateYear"
		echo ""
		echo ""
	
	}
	elseif($resetPWD -eq "No" -or $resetPWD -eq "N" -or $resetPWD -eq "no" -or $resetPWD -eq "n"){

		echo ""
		echo "OK."
	
	}
	else{
	
		echo "Sorry, Invalid entry.  No action taken.  Please run the script again".
	
	}
}
else{

echo "Password Expires: $PasswordExpires"
echo ""
echo "The users' password will expire in $PEDays days, $PEHours hours, $PEMinutes minutes, and $PESeconds seconds."
echo ""

}
}