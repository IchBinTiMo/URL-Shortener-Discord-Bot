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
        # event.message.delete_all_reactions
        event.respond("#{event.author.mention} #{res.body}")
        event.message.delete
    else
        event.respond("Invalid URL")
    end
end 

Bot.run(true)

puts "Bot started"
puts "Invite URL: #{Bot.invite_url}"