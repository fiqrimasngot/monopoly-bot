function Start-Game {
    param (
        [string]$memucPath
    )

    $tapLocation = "527 901" 
    $packageName = "com.scopely.monopolygo"

    while ($true) {
        # Start game logic here
        # Restart the Ethernet adapter for syncing
        Enable-NetAdapter -Name "Ethernet"


        # Starting up the choices VM to be starting the apps
        if (![string]::IsNullOrWhiteSpace($goodRes)) {
            # Your game logic when $goodRes is not empty
            foreach ($vm in 1..7) {
                if ($vm -eq [int]$goodRes) {
                    & $memucPath startapp com.scopely.monopolygo -i $vm
                }
            }  
        }

        # Make the bot to click the multiplier button x1 > x100 takes 7 time clicks
        # Enter nothing just simply starting the apps
        $multiplier = Read-Host "Include a multiplier and initiate the game? Leave the input empty if you only want to start the game."

        # Ensure all VM and apps starting up
        foreach ($vm in 1..7) {
            # Check if the VM is not running, then start it
            $vmStatus = & $memucPath  isvmrunning -i $vm
            if ($vmStatus -notlike "Running") {
                & $memucPath start -i $vm 
            }
            # & $memucPath connect -i $vm    
            # & $memucPath -i $vm adb "kill-server"
            & $memucPath startapp com.scopely.monopolygo -i $vm
            
        }

        # module to click on multiplier button
        if (![string]::IsNullOrWhiteSpace($multiplier)) {
            # Your game logic with multiplier
            for ($i = 1; $i -le [int]$multiplier; $i++) {
                foreach ($vm in 1..7) {
                    & $memucPath -i $vm adb "shell input tap 527 901"
                    # & $memucPath -i $vm adb "shell input tap 527 936"
                }
            }            
        }

        # sometime the apps do crash, bot will take care to click the button
        $rollOrRestart = Read-Host "Roll the dice? Press Enter to proceed; otherwise, type 'yes' if prompted to restart."

        if ([string]::IsNullOrWhiteSpace($rollOrRestart)) {
            # Your game logic on rolling dice
            Disable-NetAdapter -Name "Ethernet" -Confirm:$false

            # Click on the Roll button on each VMs
            foreach ($vm in 1..7) {
                & $memucPath -i $vm adb "shell input tap 386 1039"
                # & $memucPath disconnect -i $vm    
                # & $memucPath -i $vm adb "shell input tap 379 1029"
            }
            
            $goodRes = Read-Host "Enter the VM ID (1-7), or leave it blank to abort."
            

            if ([string]::IsNullOrWhiteSpace($goodRes)) {
                # Closing all apps
                foreach ($vm in 1..7) {
                    & $memucPath -i $vm adb "shell am force-stop com.scopely.monopolygo"
                    # & $memucPath -i $vm adb "shell rm -rf /data/data/com.scopely.monopolygo/cache/*"
                }
            }
            else {
                # Closing all apps when aborting without restarting the apps
                foreach ($vm in 1..7) {
                    # if ($vm -ne [int]$goodRes) {
                        & $memucPath -i $vm adb "shell am force-stop com.scopely.monopolygo"
                        # & $memucPath -i $vm adb "shell rm -rf /data/data/com.scopely.monopolygo/cache/*"
                    # }
                }
            } 


        } else {
            # Your game logic for restart
            foreach ($vm in 1..7) {
                # if ($vm -ne [int]$goodRes) {
                    & $memucPath -i $vm adb "shell input tap 435 800"
                    # & $memucPath -i $vm adb "shell am force-stop com.scopely.monopolygo"
                    # & $memucPath -i $vm adb "shell rm -rf /data/data/com.scopely.monopolygo/cache/*"
                    # & $memucPath disconnect -i $vm    
                # }
            }
        }
    }
}

$memucPath = "C:\Program Files\Microvirt\MEmu\memuc.exe"
# Ensure the tap button has been remapped using "adb shell getevent -l"
Start-Game -memucPath $memucPath
