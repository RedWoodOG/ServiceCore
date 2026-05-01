# Fix Flutter Windows plugin symlinks by modifying generated_plugins.cmake
# CMake cannot handle \\?\ UNC prefixed symlinks or cross-drive junctions
# This script rewrites the generated_plugins.cmake to use absolute paths

$pluginSymlinksDir = Join-Path $PSScriptRoot "flutter\ephemeral\.plugin_symlinks"
$cmakeFile = Join-Path $PSScriptRoot "flutter\generated_plugins.cmake"

if (Test-Path $pluginSymlinksDir) {
    # Collect plugin information
    $plugins = @()
    Get-ChildItem $pluginSymlinksDir | ForEach-Object {
        $pluginName = $_.Name
        $target = $_.Target
        
        if ($target) {
            # Remove \\?\ prefix if present
            $cleanTarget = $target -replace '^\\\\\?\\', ''
            # Remove trailing backslash
            $cleanTarget = $cleanTarget.TrimEnd('\\')
            
            $plugins += @{
                Name = $pluginName
                Path = $cleanTarget
            }
        }
    }
    
    if ($plugins.Count -gt 0 -and (Test-Path $cmakeFile)) {
        # Read the original file to get the plugin list
        $content = Get-Content $cmakeFile -Raw
        
        # Extract plugin names from FLUTTER_PLUGIN_LIST
        if ($content -match 'list\(APPEND FLUTTER_PLUGIN_LIST([^)]+)\)') {
            $pluginListBlock = $matches[1]
            $pluginNames = $pluginListBlock -split '\s+' | Where-Object { $_ -ne '' }
            
            # Build new CMake content
            $newContent = @"
#
# Generated file, do not edit.
#

list(APPEND FLUTTER_PLUGIN_LIST
$($pluginNames -join "`n  ")
)

list(APPEND FLUTTER_FFI_PLUGIN_LIST
)

set(PLUGIN_BUNDLED_LIBRARIES)

"@
            
            # Add each plugin with absolute paths
            foreach ($pluginName in $pluginNames) {
                $plugin = $plugins | Where-Object { $_.Name -eq $pluginName } | Select-Object -First 1
                if ($plugin) {
                    $windowsPath = Join-Path $plugin.Path "windows"
                    # Convert backslashes to forward slashes for CMake
                    $windowsPath = $windowsPath -replace '\\', '/'
                    $newContent += @"
add_subdirectory(`"$windowsPath`" plugins/$pluginName)
target_link_libraries(`${BINARY_NAME} PRIVATE ${pluginName}_plugin)
list(APPEND PLUGIN_BUNDLED_LIBRARIES `$<TARGET_FILE:${pluginName}_plugin>)
list(APPEND PLUGIN_BUNDLED_LIBRARIES `${${pluginName}_bundled_libraries})

"@
                }
            }
            
            # Write the new content
            Set-Content -Path $cmakeFile -Value $newContent -NoNewline
            Write-Host "Fixed generated_plugins.cmake with absolute paths for $($plugins.Count) plugins"
        }
    }
}
