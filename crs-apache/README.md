# Сервер хранилища + Apache 2

Пример запуска:

в каталоге `C:\Temp\crs` - разные хранилища, например есть `C:\Temp\crs\sample-svn`
```
docker run --rm -v "C:\Temp\crs:/home/usr1cv8/.1cv8/crs" -p 1548:80 localhost:5000/crs-apache:8.3.25.1546
```

Доступ к хранилищу:
```
http://localhost:1548/crs/repo.1ccr/sample-svn
```
