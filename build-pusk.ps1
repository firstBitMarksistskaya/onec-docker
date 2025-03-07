$envFilePath = ".env"

# Чтение .env файла и загрузка переменных окружения
if (Test-Path $envFilePath) {
    Get-Content $envFilePath | ForEach-Object {
        if ($_ -match '^(?<key>[^=]+)=(?<value>.*)$') {
            $key = $matches['key'].Trim()
            $value = $matches['value'].Trim()
            [System.Environment]::SetEnvironmentVariable($key, $value)
        }
    }
}

if (-not [string]::IsNullOrEmpty($env:DOCKER_LOGIN) -and -not [string]::IsNullOrEmpty($env:DOCKER_PASSWORD) -and -not [string]::IsNullOrEmpty($env:DOCKER_REGISTRY_URL)) {
    docker login -u $env:DOCKER_LOGIN -p $env:DOCKER_PASSWORD $env:DOCKER_REGISTRY_URL
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Docker login failed"
        exit 1
    }
} else {
    Write-Host "Skipping Docker login due to missing credentials"
}

docker build `
    --tag "$($env:DOCKER_REGISTRY_URL)/pusk:1.2.1" `
    --file pusk/Dockerfile `
    .

docker push "$($env:DOCKER_REGISTRY_URL)/pusk:1.2.1"