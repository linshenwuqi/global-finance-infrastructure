param(
    [Parameter(Mandatory = $true)][string]$Message
)
$ErrorActionPreference = 'Stop'
$bookRoot = Split-Path -Parent $PSScriptRoot
Push-Location -LiteralPath $bookRoot
try {
    git diff --cached --quiet
    if ($LASTEXITCODE -eq 1) { throw '已有暂存内容；请先检查，脚本不会把它一起发布。' }
    if ($LASTEXITCODE -ne 0) { throw '无法检查暂存状态。' }
    git diff --check
    if ($LASTEXITCODE -ne 0) { throw '发现空白格式错误，请先修复。' }
    $bookFiles = @('README.md', '目录.md', '版权说明.md', '更新日志.md', '风险说明.md', '参考资料', '第一篇｜先看懂全球金融地图', '第二篇｜真正进入海外证券市场', '第三篇｜Crypto与链上金融', '第四篇｜从投资全球到赚全球的钱', '第五篇｜实操手册', 'assets', 'AGENTS.md', '.gitignore', '.gitattributes', '工具')
    git add -- $bookFiles
    if ($LASTEXITCODE -ne 0) { throw '暂存失败。' }
    git diff --cached --stat
    git diff --cached --quiet
    if ($LASTEXITCODE -eq 1) {
        git commit -m $Message
        if ($LASTEXITCODE -ne 0) { throw '本地提交失败。' }
    } elseif ($LASTEXITCODE -ne 0) { throw '无法检查暂存内容。' }
    git push origin HEAD
    if ($LASTEXITCODE -ne 0) { throw '推送失败；本地提交已保留，尚未确认远程发布。' }
} finally { Pop-Location }
