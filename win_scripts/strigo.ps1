# Install https://www.powershellgallery.com/packages/AWS.Tools.EC2 to have 'Get-EC2InstanceMetadata'
Install-Module -Name AWS.Tools.EC2

# Inject Strigo context
[System.Environment]::SetEnvironmentVariable("INSTANCE_NAME", "{{ .STRIGO_RESOURCE_NAME }}", [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("PUBLIC_DNS", "{{ .STRIGO_RESOURCE_DNS }}", [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("PUBLIC_IP", (Get-EC2InstanceMetadata -Category PublicIpv4), [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("PRIVATE_DNS", "{{ .STRIGO_RESOURCE_DNS }}", [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("PRIVATE_IP", (Get-EC2InstanceMetadata -Category LocalIpv4), [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("HOSTNAME", "{{ .STRIGO_RESOURCE_NAME }}", [System.EnvironmentVariableTarget]::Machine)
