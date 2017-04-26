class HerokuCli
  HEROKU_CMD = Rails.env.production? ? "/app/vendor/heroku-toolbelt/bin/heroku" : "heroku"

  def execute(command)
    result = nil
    Bundler.with_clean_env do
      result = `#{HEROKU_CMD} #{command}`
    end
    puts "#{HEROKU_CMD} #{command} \n#{result}"
    result
  end
end
