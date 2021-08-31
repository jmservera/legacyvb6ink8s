start /b "" c:\grok\grok_exporter.exe -config grok_config.yml &
myapp.exe
taskkill /f /im grok_exporter.exe
