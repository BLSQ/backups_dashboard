# Dashboard backups 

## Context

Dasboard backups is a flexible backup monitoring solution for heroku applications. It
 
  - automatically schedule backups on new heroku application
  - provide a helpful summary of the current state of the backups (per app)

Currently the following backup systems:  

  - heroku pg:backups 
  - heroku autobus  

It uses google for authentication.  

## Installation on Heroku

### Basic Setup
	
	- heroku create dashboard_backups
	- heroku addons:create heroku-postgresql:hobby-basic --app dashboard_backups
	- heroku addons:create rediscloud:30 --app scorpio-dev
	- heroku ps:scale web=1 worker=1
	- heroku buildpacks:set https://github.com/BLSQ/heroku-buildpack-toolbelt.git
	- git clone repo_url dashboard_backups
	- cd dashboard_backups
	- heroku git:remote -a dashboard_backups
	- git push heroku master
	- heroku run rake db:migrate

### Configuring authentication 

The application is currently using google as main authentication provider, hence the 
following environment variable has to be setup. 

    - heroku config:set google_app_id=your_google_app_id 
    - heroku config:set google_auth_secret=your_google_auth_secret
    - heroku config:set google_domain=your_google_domain_name

### Configuring heroku PG:Backups

Using a sidekick worker dashboard backups will connect to heroku and 

   - retrieve the list of application and their backups information 
   - if not set define a backup schedule time for every application 

To enable the connection to heroku pg:backups:

	- heroku config:set HEROKU_TOOLBELT_API_PASSWORD=your_toolbelt_password
	- heroku config:set HEROKU_TOOLBELT_API_EMAIL=your_toolbelt_email
	- heroku config:set backups_frequency=backup_frequency_for_every_app (example: '07:00 Europe/Brussels')


### Configuring Heroku Autobus 

Using a sidekick worker dashboard backups will connect to autobus and 

  - retrieve the list of backups per app 

To enable the connection to autobus, the user will have to manually setup the autobus token per application in dashboard backups. The list of applications to configure will be listed on top of the home page as 'missing configuration' applications. 


## Testing 

To test that all connection works use the following command 

	- heroku run rake projects:update 

This will populate the database with all heroku application and backups information available 

## Schedule 

To schedule the task, use 

	- heroku addons:create scheduler:standard
	- heroku addons:open scheduler 
