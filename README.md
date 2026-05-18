# gscm_app_nghiencuu

## Day code tu may Windows len Git

Cloud Agent khong truy cap truc tiep duoc duong dan Windows local nhu:

```powershell
C:\ThuyNT_Viec\3. gscm_app_git_khoadulieu\3. gscm_app_git_khoadulieu
```

Hay copy/chay script `scripts/push-to-git.ps1` tren may Windows cua ban.

Vi du:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\push-to-git.ps1 `
  -ProjectPath "C:\ThuyNT_Viec\3. gscm_app_git_khoadulieu\3. gscm_app_git_khoadulieu" `
  -RemoteUrl "https://github.com/thuynt5853/gscm_app_nghiencuu.git" `
  -Branch "main" `
  -CommitMessage "Initial commit"
```

Neu dung dung repo nay, co the bo qua tham so `-RemoteUrl` vi script da dat san:

```powershell
https://github.com/thuynt5853/gscm_app_nghiencuu.git
```
