# Публикация разбора на GitHub Pages. Запуск: powershell -ExecutionPolicy Bypass -File D:\DEV\yur-razbor-registraciya\publish.ps1
# Первый запуск откроет вход в GitHub в браузере. Репозиторий открытый: на бесплатном GitHub Pages работает только так.
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$repo = 'razbor-registraciya-uchastnikov'
gh auth status 2>$null
if ($LASTEXITCODE -ne 0) { gh auth login --web --git-protocol https }
$login = gh api user --jq .login
gh repo view "$login/$repo" 2>$null
if ($LASTEXITCODE -ne 0) {
  gh repo create $repo --public --source . --remote origin --push --description "ИП регистрирует участников на чужое мероприятие: риски и решение (Россия, 2026)"
} else {
  git push origin main
}
gh api -X POST "repos/$login/$repo/pages" -f "source[branch]=main" -f "source[path]=/" 2>$null
$url = "https://$login.github.io/$repo/"
Write-Host "Готово. Через 1-2 минуты страница откроется: $url"
Start-Process chrome $url
