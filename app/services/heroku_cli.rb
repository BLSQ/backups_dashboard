class HerokuCli

  HEROKU_CMD = Rails.env.production? ? '/app/vendor/heroku-toolbelt/bin/heroku' : 'heroku'

  def execute(command)
    return `#{HEROKU_CMD} #{command}`
  end 
end 
