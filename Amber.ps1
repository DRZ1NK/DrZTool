# Load the required assembly
Add-Type -AssemblyName System.Windows.Forms

# Print the message in the PowerShell console
Write-Host "Very good Tweak tool" -ForegroundColor Green

# Create the Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Remove Apps"
$form.Size = New-Object System.Drawing.Size(600, 600)  # Increased size to 600x600
$form.StartPosition = "CenterScreen"

# Create a hashtable to map user-friendly names to actual package names
$appMapping = @{
    "Solitaire" = "*solitaire*"
    "Candy Crush" = "*candycrush*"
    "Xbox" = "*xbox*"
    "Solitaire Collection" = "*solitairecollection*"
    "Microsoft News" = "*Microsoft.BingNews*"
    "Mail and Calendar" = "*windowscommunicationsapps*"
    "Weather" = "*bingweather*"
    "Movies & TV" = "*zunevideo*"
    "People" = "*Microsoft.People*"
    "Your Phone" = "*YourPhone*"
    "Cortana" = "*Cortana*"
    "3D Viewer" = "*Microsoft.3DViewer*"
    "Paint 3D" = "*Microsoft.MSPaint*"
    "Mixed Reality Portal" = "*Microsoft.MixedReality.Portal*"
    "OneNote" = "*Microsoft.Office.OneNote*"
    "Groove Music" = "*Microsoft.ZuneMusic*"
    "Microsoft Help" = "*Microsoft.GetHelp*"
}

# Add Checkboxes to the form
$yPosition = 20
foreach ($friendlyName in $appMapping.Keys) {
    $checkBox = New-Object System.Windows.Forms.CheckBox
    $checkBox.Text = $friendlyName
    $checkBox.Location = New-Object System.Drawing.Point(20, $yPosition)
    $checkBox.AutoSize = $true
    $form.Controls.Add($checkBox)
    $yPosition += 30  # Keep this spacing between checkboxes
}

# Create the Button
$button = New-Object System.Windows.Forms.Button
$button.Text = "Remove Selected Apps"
$button.Location = New-Object System.Drawing.Point(20, $yPosition)
$button.AutoSize = $true

# Define the Button Click event
$button.Add_Click({
    foreach ($checkBox in $form.Controls | Where-Object { $_ -is [System.Windows.Forms.CheckBox] -and $_.Checked }) {
        $friendlyName = $checkBox.Text
        $appName = $appMapping[$friendlyName] # Get the actual package name from the mapping
        # Execute the command to remove the app
        Write-Host "Removing $friendlyName with package name $appName..."
        Get-AppxPackage $appName | Remove-AppxPackage -ErrorAction SilentlyContinue
    }
    [System.Windows.Forms.MessageBox]::Show("Selected apps have been removed.")
    $form.Close()
})

$form.Controls.Add($button)

# Show the Form
$form.ShowDialog()
