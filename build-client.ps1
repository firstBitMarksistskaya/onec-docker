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

if ($env:DOCKER_SYSTEM_PRUNE -eq 'true') {
    docker system prune -af
}

$last_arg = '.'
if ($env:NO_CACHE -eq 'true') {
    $last_arg = '--no-cache .'
}

docker build `
    --pull `
    --build-arg DOCKER_REGISTRY_URL=library `
    --build-arg BASE_IMAGE=ubuntu `
    --build-arg BASE_TAG=20.04 `
    --build-arg ONESCRIPT_PACKAGES="yard" `
    -t "$($env:DOCKER_REGISTRY_URL)/oscript-downloader:latest" `
    -f oscript/Dockerfile `
    $last_arg

docker build `
    --build-arg ONEC_USERNAME=$env:ONEC_USERNAME `
    --build-arg ONEC_PASSWORD=$env:ONEC_PASSWORD `
    --build-arg ONEC_VERSION=$env:ONEC_VERSION `
    --build-arg DOCKER_REGISTRY_URL=$env:DOCKER_REGISTRY_URL `
    --build-arg BASE_IMAGE=oscript-downloader `
    --build-arg BASE_TAG=latest `
    -t "$($env:DOCKER_REGISTRY_URL)/onec-client:$($env:ONEC_VERSION)" `
    -f client/Dockerfile `
    $last_arg

docker push "$($env:DOCKER_REGISTRY_URL)/onec-client:$($env:ONEC_VERSION)"
