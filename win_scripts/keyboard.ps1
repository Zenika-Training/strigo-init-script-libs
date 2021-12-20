# Set language to fr-FR then en-US
Set-WinUserLanguageList -Force -LanguageList fr-FR,en-US
# Set default input method to fr-FR
Set-WinDefaultInputMethodOverride -InputTip ((Get-WinUserLanguageList)[0].InputMethodTips)[0]

# Disable Language Bar HotKey
Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Keyboard Layout\Toggle' -Name 'Language HotKey' -Value 3
Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Keyboard Layout\Toggle' -Name 'HotKey' -Value 3
Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Keyboard Layout\Toggle' -Name 'Layout HotKey' -Value 3

# Then, need to change "Keyboard language settings" in Strigo and change language in the Windows language bar (or sign out from Windows)
