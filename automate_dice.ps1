# Ensure that you're running this script as an administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as an administrator."
    Read-Host "Press Enter to exit"
    Exit
}

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process

# Set the path to the memuc.exe
$memucPath = "C:\Program Files\Microvirt\MEmu\memuc.exe"
# $multiplier = Read-Host "Multiplier? Enter to skip"
# x1 -> X100 takes 7 times
# ((tls.record.content_type == 20) || (tls.record.content_type == 22))

while ($true) {
    
    Enable-NetAdapter -Name "Ethernet"

    if (![string]::IsNullOrWhiteSpace($goodRes)) {
        # foreach ($vm in 1..7) {
        #     if ($vm -eq [int]$goodRes) {
        #         & $memucPath -i $vm adb "shell am force-stop com.scopely.monopolygo"
        #         & $memucPath -i $vm adb "shell rm -rf /data/data/com.scopely.monopolygo/cache/*"
        #     }
        # }    
        # $waitForUser = Read-Host "Restart the game? Enter to proceed"
        foreach ($vm in 1..7) {
            if ($vm -eq [int]$goodRes) {
                & $memucPath startapp com.scopely.monopolygo -i $vm
            }
        }    
    }        
    
    $multiplier = Read-Host "Add multiplier and start the Game? Enter nothing to only start the game"
    
    # if (![string]::IsNullOrWhiteSpace($goodRes)) { foreach ($vm in 1..7) { if ($vm -ne [int]$goodRes) { & $memucPath connect -i $vm ; & $memucPath -i $vm adb "kill-server" } } }
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
    

    if (![string]::IsNullOrWhiteSpace($multiplier)) {
        for ($i = 1; $i -le [int]$multiplier; $i++) {
            foreach ($vm in 1..7) {
                & $memucPath -i $vm adb "shell input tap 527 901"
                # & $memucPath -i $vm adb "shell input tap 527 936"
            }
        }
    }
    
    $rollOrRestart = Read-Host "Roll DICE? Press Enter to proceed else, type yes if you're prompted to restart"


    if ([string]::IsNullOrWhiteSpace($rollOrRestart)) {
        Disable-NetAdapter -Name "Ethernet" -Confirm:$false
        
        foreach ($vm in 1..7) {
            & $memucPath -i $vm adb "shell input tap 386 1039"
            # & $memucPath disconnect -i $vm    
            # & $memucPath -i $vm adb "shell input tap 379 1029"
        }
        
        $goodRes = Read-Host "Which VM ID? (1-7), Enter nothing to abort"
        
        if ([string]::IsNullOrWhiteSpace($goodRes)) {
            foreach ($vm in 1..7) {
                & $memucPath -i $vm adb "shell am force-stop com.scopely.monopolygo"
                # & $memucPath -i $vm adb "shell rm -rf /data/data/com.scopely.monopolygo/cache/*"
            }
        }
        else {
            foreach ($vm in 1..7) {
                # if ($vm -ne [int]$goodRes) {
                    & $memucPath -i $vm adb "shell am force-stop com.scopely.monopolygo"
                    # & $memucPath -i $vm adb "shell rm -rf /data/data/com.scopely.monopolygo/cache/*"
                # }
            }
        }    

    }
    else {
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