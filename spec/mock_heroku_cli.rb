class MockHerokuCli
  def initialize(commands)
    @commands = commands
  end

  def execute(command)
    file = @commands[command]
    puts @commands
    raise "no mock for '#{command}'" unless file
    return fixture_content :heroku, file
  end

  def fixture_content(type, name)
    File.read(File.join("spec", "fixtures", type.to_s, name))
  end

end 
