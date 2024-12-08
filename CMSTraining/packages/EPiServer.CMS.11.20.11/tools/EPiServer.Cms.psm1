
Function CopyDB($toolsPath, $sitePath, $dbName)
{
	$mdfFile = join-path $toolsPath  "EPiServer.Cms.mdf"
	if ([System.IO.File]::Exists([System.IO.Path]::Combine($sitePath, "App_Data", $dbName)) -eq $false)
	{
		CreateFolder $sitePath "App_Data"
		[void][System.IO.File]::Copy($mdfFile, [System.IO.Path]::Combine($sitePath, "App_Data", $dbName))
	}
}

Function CreateFolder($sitePath, $foldername)
{
	if ([System.IO.File]::Exists([System.IO.Path]::Combine($sitePath, $foldername)) -eq $false)
	{
		[void][System.IO.Directory]::CreateDirectory([System.IO.Path]::Combine($sitePath, $foldername))
	}
}

Function GetEPiDeployPath($installPath, $project)
{
	$frameWorkToolPath = GetPackagesToolPath $installPath $project "EPiServer.Framework"
	$dpeployEXEPath =  join-Path ($frameWorkToolPath) "epideploy.exe"
	return $dpeployEXEPath
}

Function GetEPiServerConnectionString($WebConfigFile)
{
	if (Test-Path $WebConfigFile) 
	{
		$webConfig = [XML] (Get-Content $WebConfigFile)
		if ($webConfig.configuration.connectionStrings.add -ne $null)
		{
			return FindEpiServerConnection($webConfig.configuration.connectionStrings.add)
		}
		if ($webConfig.connectionStrings.add -ne  $null) 
		{
			return FindEpiServerConnection($webConfig.connectionStrings.add)
		}
		if ($webConfig.configuration.connectionStrings.configSource -ne $null) 
		{
			if ([System.IO.Path]::IsPathRooted($webConfig.configuration.connectionStrings.configSource))
			{
				return GetEPiServerConnectionString($webConfig.configuration.connectionStrings.configSource)
			}
			else
			{
				return GetEPiServerConnectionString (Join-path  ([System.IO.Path]::GetDirectoryName($WebConfigFile))  $webConfig.configuration.connectionStrings.configSource)
			}
		}
	}
	return $null
}

Function FindEpiServerConnection($addElements)
{
	foreach($connString in $addElements)
	{
		if ($connString.name -eq 'EPiServerDB')
		{
			return $connString
		}
	}
	return $null
}

Function GetWebConfigPath($sitePath)
{
	$webConfigPath = join-path $sitePath "web.config"
	$appConfigPath = join-path $sitePath "app.config"
	if (Test-Path $webConfigPath) 
	{
		$configPath = $webConfigPath
	}
	elseif (Test-Path $appConfigPath)
	{
		$configPath = $appConfigPath
	}
	else 
	{
		Write-Host "Unable to find a configuration file."
		return
	}
	return $configPath
}

Function GetConnectionConfigPath($sitePath)
{
	$connectionsStringsPath = join-path $sitePath "connectionStrings.config"
	$webConfigPath = join-path $sitePath "web.config"
	if (Test-Path $connectionsStringsPath) 
	{
		$configPath = $connectionsStringsPath
	}
	elseif (Test-Path $webConfigPath)
	{
		$configPath = $webConfigPath
	}
	else 
	{
		Write-Host "Unable to find a Connection configuration file."
		return
	}
	return $configPath
}

Function GetPackagesToolPath($installPath, $project, $packageName)
{
	$thePackage = Get-package -ProjectName $project.ProjectName | where-object { $_.id -eq $packageName} | Sort-Object -Property Version -Descending | select-object -first 1
	$thePackageToolPath =[System.IO.Path]::Combine($installPath,  ".." , $thePackage.Id + "." + $thePackage.Version , "tools")
	return $thePackageToolPath
}
# SIG # Begin signature block
# MIIakAYJKoZIhvcNAQcCoIIagTCCGn0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUsMYdVg3ikeI/9VOs7RnA613X
# xg+gghWbMIIE/jCCA+agAwIBAgIQDUJK4L46iP9gQCHOFADw3TANBgkqhkiG9w0B
# AQsFADByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFz
# c3VyZWQgSUQgVGltZXN0YW1waW5nIENBMB4XDTIxMDEwMTAwMDAwMFoXDTMxMDEw
# NjAwMDAwMFowSDELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMu
# MSAwHgYDVQQDExdEaWdpQ2VydCBUaW1lc3RhbXAgMjAyMTCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBAMLmYYRnxYr1DQikRcpja1HXOhFCvQp1dU2UtAxQ
# tSYQ/h3Ib5FrDJbnGlxI70Tlv5thzRWRYlq4/2cLnGP9NmqB+in43Stwhd4CGPN4
# bbx9+cdtCT2+anaH6Yq9+IRdHnbJ5MZ2djpT0dHTWjaPxqPhLxs6t2HWc+xObTOK
# fF1FLUuxUOZBOjdWhtyTI433UCXoZObd048vV7WHIOsOjizVI9r0TXhG4wODMSlK
# XAwxikqMiMX3MFr5FK8VX2xDSQn9JiNT9o1j6BqrW7EdMMKbaYK02/xWVLwfoYer
# vnpbCiAvSwnJlaeNsvrWY4tOpXIc7p96AXP4Gdb+DUmEvQECAwEAAaOCAbgwggG0
# MA4GA1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsG
# AQUFBwMIMEEGA1UdIAQ6MDgwNgYJYIZIAYb9bAcBMCkwJwYIKwYBBQUHAgEWG2h0
# dHA6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzAfBgNVHSMEGDAWgBT0tuEgHf4prtLk
# YaWyoiWyyBc1bjAdBgNVHQ4EFgQUNkSGjqS6sGa+vCgtHUQ23eNqerwwcQYDVR0f
# BGowaDAyoDCgLoYsaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL3NoYTItYXNzdXJl
# ZC10cy5jcmwwMqAwoC6GLGh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9zaGEyLWFz
# c3VyZWQtdHMuY3JsMIGFBggrBgEFBQcBAQR5MHcwJAYIKwYBBQUHMAGGGGh0dHA6
# Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBPBggrBgEFBQcwAoZDaHR0cDovL2NhY2VydHMu
# ZGlnaWNlcnQuY29tL0RpZ2lDZXJ0U0hBMkFzc3VyZWRJRFRpbWVzdGFtcGluZ0NB
# LmNydDANBgkqhkiG9w0BAQsFAAOCAQEASBzctemaI7znGucgDo5nRv1CclF0CiNH
# o6uS0iXEcFm+FKDlJ4GlTRQVGQd58NEEw4bZO73+RAJmTe1ppA/2uHDPYuj1UUp4
# eTZ6J7fz51Kfk6ftQ55757TdQSKJ+4eiRgNO/PT+t2R3Y18jUmmDgvoaU+2QzI2h
# F3MN9PNlOXBL85zWenvaDLw9MtAby/Vh/HUIAHa8gQ74wOFcz8QRcucbZEnYIpp1
# FUL1LTI4gdr0YKK6tFL7XOBhJCVPst/JKahzQ1HavWPWH1ub9y4bTxMd90oNcX6X
# t/Q/hOvB46NJofrOp79Wz7pZdmGJX36ntI5nePk2mOHLKNpbh6aKLzCCBTEwggQZ
# oAMCAQICEAqhJdbWMht+QeQF2jaXwhUwDQYJKoZIhvcNAQELBQAwZTELMAkGA1UE
# BhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2lj
# ZXJ0LmNvbTEkMCIGA1UEAxMbRGlnaUNlcnQgQXNzdXJlZCBJRCBSb290IENBMB4X
# DTE2MDEwNzEyMDAwMFoXDTMxMDEwNzEyMDAwMFowcjELMAkGA1UEBhMCVVMxFTAT
# BgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEx
# MC8GA1UEAxMoRGlnaUNlcnQgU0hBMiBBc3N1cmVkIElEIFRpbWVzdGFtcGluZyBD
# QTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAL3QMu5LzY9/3am6gpnF
# OVQoV7YjSsQOB0UzURB90Pl9TWh+57ag9I2ziOSXv2MhkJi/E7xX08PhfgjWahQA
# OPcuHjvuzKb2Mln+X2U/4Jvr40ZHBhpVfgsnfsCi9aDg3iI/Dv9+lfvzo7oiPhis
# EeTwmQNtO4V8CdPuXciaC1TjqAlxa+DPIhAPdc9xck4Krd9AOly3UeGheRTGTSQj
# MF287DxgaqwvB8z98OpH2YhQXv1mblZhJymJhFHmgudGUP2UKiyn5HU+upgPhH+f
# MRTWrdXyZMt7HgXQhBlyF/EXBu89zdZN7wZC/aJTKk+FHcQdPK/P2qwQ9d2srOlW
# /5MCAwEAAaOCAc4wggHKMB0GA1UdDgQWBBT0tuEgHf4prtLkYaWyoiWyyBc1bjAf
# BgNVHSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823IDzASBgNVHRMBAf8ECDAGAQH/
# AgEAMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUEDDAKBggrBgEFBQcDCDB5BggrBgEF
# BQcBAQRtMGswJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBD
# BggrBgEFBQcwAoY3aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
# QXNzdXJlZElEUm9vdENBLmNydDCBgQYDVR0fBHoweDA6oDigNoY0aHR0cDovL2Ny
# bDQuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNybDA6oDig
# NoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9v
# dENBLmNybDBQBgNVHSAESTBHMDgGCmCGSAGG/WwAAgQwKjAoBggrBgEFBQcCARYc
# aHR0cHM6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzALBglghkgBhv1sBwEwDQYJKoZI
# hvcNAQELBQADggEBAHGVEulRh1Zpze/d2nyqY3qzeM8GN0CE70uEv8rPAwL9xafD
# DiBCLK938ysfDCFaKrcFNB1qrpn4J6JmvwmqYN92pDqTD/iy0dh8GWLoXoIlHsS6
# HHssIeLWWywUNUMEaLLbdQLgcseY1jxk5R9IEBhfiThhTWJGJIdjjJFSLK8pieV4
# H9YLFKWA1xJHcLN11ZOFk362kmf7U2GJqPVrlsD0WGkNfMgBsbkodbeZY4UijGHK
# eZR+WfyMD+NvtQEmtmyl7odRIeRYYJu6DC0rbaLEfrvEJStHAgh8Sa4TtuF8QkIo
# xhhWz0E0tmZdtnR79VYzIi8iNrJLokqV2PWmjlIwggVnMIIET6ADAgECAhEAmC+S
# aSXEmwKb5aP3fjOjVTANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJHQjEbMBkG
# A1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYD
# VQQKEw9TZWN0aWdvIExpbWl0ZWQxJDAiBgNVBAMTG1NlY3RpZ28gUlNBIENvZGUg
# U2lnbmluZyBDQTAeFw0xOTA1MjIwMDAwMDBaFw0yMjA1MjEyMzU5NTlaMIG1MQsw
# CQYDVQQGEwJTRTEOMAwGA1UEEQwFMTExNTYxDzANBgNVBAgMBlN3ZWRlbjESMBAG
# A1UEBwwJU3RvY2tob2xtMRowGAYDVQQJDBFSZWdlcmluZ3NnYXRhbiA2NzERMA8G
# A1UEEgwIQm94IDcwMDcxFTATBgNVBAoMDEVwaXNlcnZlciBBQjEUMBIGA1UECwwL
# RW5naW5lZXJpbmcxFTATBgNVBAMMDEVwaXNlcnZlciBBQjCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBALMg0HiSm99PJyVgbuJFKNjRyi98VFKF4lTVA4GX
# fXgixyErz+ISaHcXrjxEW1CkH55+Vh+LDjBIMqJ2mOC+2d/Dh9OwZINayxOxV+gs
# qGH7F+7o//+EAWztkRH9Etw2IBedwlTeZvZitKew6gYWZwMq7wM5Ndp7oaXw8E4M
# XviOY6Lof390xWWy3BhWRu9I37JhU4vkrnxg4cPZ8sZYb0OEw/n0mvJ2Y2wjyRUQ
# YZXtUHyAe2c5lfmDpdFkFf7QEPB9Erkm19MvF6RvAv9hkaeQbNnFAKbJcp57ewpD
# dEMzR+CrLkwjSZhX5HM39/Aq/O58e4fCfSIotBYSnDZcjrcCAwEAAaOCAagwggGk
# MB8GA1UdIwQYMBaAFA7hOqhTOjHVir7Bu61nGgOFrTQOMB0GA1UdDgQWBBT8FQmi
# bCssGc1dLqmLA0Jk40EuJDAOBgNVHQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIwADAT
# BgNVHSUEDDAKBggrBgEFBQcDAzARBglghkgBhvhCAQEEBAMCBBAwQAYDVR0gBDkw
# NzA1BgwrBgEEAbIxAQIBAwIwJTAjBggrBgEFBQcCARYXaHR0cHM6Ly9zZWN0aWdv
# LmNvbS9DUFMwQwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2NybC5zZWN0aWdvLmNv
# bS9TZWN0aWdvUlNBQ29kZVNpZ25pbmdDQS5jcmwwcwYIKwYBBQUHAQEEZzBlMD4G
# CCsGAQUFBzAChjJodHRwOi8vY3J0LnNlY3RpZ28uY29tL1NlY3RpZ29SU0FDb2Rl
# U2lnbmluZ0NBLmNydDAjBggrBgEFBQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5j
# b20wIAYDVR0RBBkwF4EVc3VwcG9ydEBlcGlzZXJ2ZXIuY29tMA0GCSqGSIb3DQEB
# CwUAA4IBAQCEvy8b9Y9uMcMSgC6H4qSrY0WetAMrQwTIea4KhaNDA/6C5hwfDv9H
# yOupMkBFgOUx2nxvH0MPy1yAC6EH2wtk+VCIbIYAhDPKLMdJ2s8UqCjbIAFKfCCh
# 1im+VtUkQnFDWKNt+fLfKk9CfAd2lhS0NnUEmSzj8/z4QwRO06asyL2i0VjdicUQ
# TvRVEEoVqABvUisChgJMyp+yRHi5SbXDoSfiaIV/Hx+JILrr2nBAQ0Cj5KXHW0Dn
# BAFyGqXTC62iFKz2ToNG250Dk+FWX1zBbQShc9nemuHX/HYmYWEg8M/9YorIYwDD
# EFNFjupbDPP67cA7vauuXqsuy2TcdXo9MIIF9TCCA92gAwIBAgIQHaJIMG+bJhjQ
# guCWfTPTajANBgkqhkiG9w0BAQwFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Ck5ldyBKZXJzZXkxFDASBgNVBAcTC0plcnNleSBDaXR5MR4wHAYDVQQKExVUaGUg
# VVNFUlRSVVNUIE5ldHdvcmsxLjAsBgNVBAMTJVVTRVJUcnVzdCBSU0EgQ2VydGlm
# aWNhdGlvbiBBdXRob3JpdHkwHhcNMTgxMTAyMDAwMDAwWhcNMzAxMjMxMjM1OTU5
# WjB8MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAw
# DgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxJDAiBgNV
# BAMTG1NlY3RpZ28gUlNBIENvZGUgU2lnbmluZyBDQTCCASIwDQYJKoZIhvcNAQEB
# BQADggEPADCCAQoCggEBAIYijTKFehifSfCWL2MIHi3cfJ8Uz+MmtiVmKUCGVEZ0
# MWLFEO2yhyemmcuVMMBW9aR1xqkOUGKlUZEQauBLYq798PgYrKf/7i4zIPoMGYmo
# bHutAMNhodxpZW0fbieW15dRhqb0J+V8aouVHltg1X7XFpKcAC9o95ftanK+ODtj
# 3o+/bkxBXRIgCFnoOc2P0tbPBrRXBbZOoT5Xax+YvMRi1hsLjcdmG0qfnYHEckC1
# 4l/vC0X/o84Xpi1VsLewvFRqnbyNVlPG8Lp5UEks9wO5/i9lNfIi6iwHr0bZ+UYc
# 3Ix8cSjz/qfGFN1VkW6KEQ3fBiSVfQ+noXw62oY1YdMCAwEAAaOCAWQwggFgMB8G
# A1UdIwQYMBaAFFN5v1qqK0rPVIDh2JvAnfKyA2bLMB0GA1UdDgQWBBQO4TqoUzox
# 1Yq+wbutZxoDha00DjAOBgNVHQ8BAf8EBAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIB
# ADAdBgNVHSUEFjAUBggrBgEFBQcDAwYIKwYBBQUHAwgwEQYDVR0gBAowCDAGBgRV
# HSAAMFAGA1UdHwRJMEcwRaBDoEGGP2h0dHA6Ly9jcmwudXNlcnRydXN0LmNvbS9V
# U0VSVHJ1c3RSU0FDZXJ0aWZpY2F0aW9uQXV0aG9yaXR5LmNybDB2BggrBgEFBQcB
# AQRqMGgwPwYIKwYBBQUHMAKGM2h0dHA6Ly9jcnQudXNlcnRydXN0LmNvbS9VU0VS
# VHJ1c3RSU0FBZGRUcnVzdENBLmNydDAlBggrBgEFBQcwAYYZaHR0cDovL29jc3Au
# dXNlcnRydXN0LmNvbTANBgkqhkiG9w0BAQwFAAOCAgEATWNQ7Uc0SmGk295qKoyb
# 8QAAHh1iezrXMsL2s+Bjs/thAIiaG20QBwRPvrjqiXgi6w9G7PNGXkBGiRL0C3da
# nCpBOvzW9Ovn9xWVM8Ohgyi33i/klPeFM4MtSkBIv5rCT0qxjyT0s4E307dksKYj
# alloUkJf/wTr4XRleQj1qZPea3FAmZa6ePG5yOLDCBaxq2NayBWAbXReSnV+pbjD
# bLXP30p5h1zHQE1jNfYw08+1Cg4LBH+gS667o6XQhACTPlNdNKUANWlsvp8gJRAN
# GftQkGG+OY96jk32nw4e/gdREmaDJhlIlc5KycF/8zoFm/lv34h/wCOe0h5DekUx
# wZxNqfBZslkZ6GqNKQQCd3xLS81wvjqyVVp4Pry7bwMQJXcVNIr5NsxDkuS6T/Fi
# kyglVyn7URnHoSVAaoRXxrKdsbwcCtp8Z359LukoTBh+xHsxQXGaSynsCz1XUNLK
# 3f2eBVHlRHjdAd6xdZgNVCT98E7j4viDvXK6yz067vBeF5Jobchh+abxKgoLpbn0
# nu6YMgWFnuv5gynTxix9vTp3Los3QqBqgu07SqqUEKThDfgXxbZaeTMYkuO1dfih
# 6Y4KJR7kHvGfWocj/5+kUZ77OYARzdu1xKeogG/lU9Tg46LC0lsa+jImLWpXcBw8
# pFguo/NbSwfcMlnzh6cabVgxggRfMIIEWwIBATCBkTB8MQswCQYDVQQGEwJHQjEb
# MBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgw
# FgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxJDAiBgNVBAMTG1NlY3RpZ28gUlNBIENv
# ZGUgU2lnbmluZyBDQQIRAJgvkmklxJsCm+Wj934zo1UwCQYFKw4DAhoFAKBwMBAG
# CisGAQQBgjcCAQwxAjAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisG
# AQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBTjwwGWhHFc
# B1Lh5lvojhAwyJiXDTANBgkqhkiG9w0BAQEFAASCAQCMFNtZGA4iZpzInDfW4Gdk
# G25UDdxfBxsT//W+iUdJix5xPmNVlqrrMknFNQGh6ZVE1YtDKodmHDNdwmmBxJ89
# 1FTMk288u9oOyxlj+tOUvB5+3Yb9tpxzNk/7oaE5ur76M33BTEWpVePR8vQBgyHh
# YZqftZLolsI2gTQg7SJZE5NH9qDjk44sU4JE6uA/m17zrtO5HpDef/PQTjoXpRQP
# SiRK5g8FCdt5b3G7p3dZSkGMn4GWkpY5VhUi531Skh+SPqMfVQbjzR+EP1GKCh2C
# a2x7GYU0EkshFSYWgNPMJa5vIRF2UOJnLizq8vlZqtKWUGWMqEHNAzV1PdxPrFjY
# oYICMDCCAiwGCSqGSIb3DQEJBjGCAh0wggIZAgEBMIGGMHIxCzAJBgNVBAYTAlVT
# MRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5j
# b20xMTAvBgNVBAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJRCBUaW1lc3RhbXBp
# bmcgQ0ECEA1CSuC+Ooj/YEAhzhQA8N0wDQYJYIZIAWUDBAIBBQCgaTAYBgkqhkiG
# 9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMTEyMTcxNDM2MjJa
# MC8GCSqGSIb3DQEJBDEiBCAhiz67Rg+YCfCl+3ohhzU3YIkBvbUe7/pxCearcs/a
# 6DANBgkqhkiG9w0BAQEFAASCAQBRHECcfRNtxfEMk/6U/UGIj1adHhe3GNWUsHtx
# IIx8r01Bz1nM9sK/Rj5eF7kKg6XhGY+T0QiLlF1pm0Cqc9HfpGBvDUw7DoXjeQ9i
# Id7mYaA+kF1o0GgsI3LKoFukWT4gkfe/7T7BHcnymNcnihBd8bpeIZQMe8fbKyUE
# FIuSWv054gglR+3BV9OgFxQI2+STKynIecQBgw7SU6DzzYXRVMVHXAUEn2ldh/Oe
# eVmzvYm/5Azu/gDf4fH8pPCK1QpUttFiYdd2KI+x9UWQnIUmPpXNG1U8c2RgHx3m
# vNZ12HrgPfMwHnDEHIHg0CfyYL7OhCu+/sFHzPWY3MP80Ax1
# SIG # End signature block
