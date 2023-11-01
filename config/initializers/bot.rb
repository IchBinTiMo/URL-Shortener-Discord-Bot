require "discordrb"
require "faraday"

Bot = Discordrb::Commands::CommandBot.new(
  token: Rails.application.credentials.discord[:token],
  prefix: '!'
)

conn = Faraday.new(
  url: 'http://localhost:3000',
  headers: { 'Content-Type' => 'application/json' },
)


Bot.command(:url) do |event, text|
    if text =~ URI::DEFAULT_PARSER.make_regexp
        res = conn.get('url', { url: text })
        event.respond("#{event.author.mention} #{res.body}")
        event.message.delete
    else
        event.respond("Invalid URL")
    end
end 

Bot.run(true)

puts "Bot started"
puts "Invite URL: https://discord.com/api/oauth2/authorize?client_id=1168807061514100846&permissions=8&scope=bot"