# Setup Heroku Cloud
## 1. Heroku Buildpack: Dart
https://elements.heroku.com/buildpacks/stablekernel/heroku-buildpack-dart

## 2. Youtube deploy Heroku Dart
https://www.youtube.com/watch?v=IRZ7WH98lLA

## 3. Buildpack workaround 
https://github.com/igrigorik/heroku-buildpack-dart/issues/54#issuecomment-1137209312



### Setup Heroku
https://devcenter.heroku.com/articles/getting-started-with-go#set-up
```
brew install heroku/brew/heroku
heroku login
```
### Setup project Commands: 
```sh
git init
heroku create <app_id>

heroku config:set DART_SDK_URL=https://storage.googleapis.com/dart-archive/channels/stable/release/2.17.5/sdk/dartsdk-linux-x64-release.zip
heroku config:add BUILDPACK_URL=https://github.com/Becca-Saka/heroku-buildpack-dart
heroku config:set DATABASE_URL=<db_url>
heroku config:set HOST=0.0.0.0
heroku config:set POSTGRES_SSL=true
heroku config:set PATH=/app/bin:/usr/local/bin:/usr/bin:/bin

git add -A .
git commit -am "first commit"
git branch -M 'main'
git push heroku main
```