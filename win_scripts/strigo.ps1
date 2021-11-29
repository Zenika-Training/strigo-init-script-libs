# Prerequisite: AWS EC2 Tools for 'Get-EC2InstanceMetadata', already installed in Strigo Windows Server 2016

# Inject Strigo context
[System.Environment]::SetEnvironmentVariable("INSTANCE_NAME", "{{ .STRIGO_RESOURCE_NAME }}", [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("PUBLIC_DNS", "{{ .STRIGO_RESOURCE_DNS }}", [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("PUBLIC_IP", (Get-EC2InstanceMetadata -Category PublicIpv4), [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("PRIVATE_DNS", "{{ .STRIGO_RESOURCE_DNS }}", [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("PRIVATE_IP", (Get-EC2InstanceMetadata -Category LocalIpv4), [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("HOSTNAME", "{{ .STRIGO_RESOURCE_NAME }}", [System.EnvironmentVariableTarget]::Machine)
