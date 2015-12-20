module SlackGamebot
  module Commands
    class Register < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        ts = Time.now.utc
        user = ::User.find_create_or_update_by_slack_id!(client, data.user)
        message = if user.created_at >= ts
                    "Welcome <@#{data.user}>! You're ready to play."
                  elsif user.updated_at >= ts
                    "Welcome back <@#{data.user}>, I've updated your registration."
                  else
                    "Welcome back <@#{data.user}>, you're already registered."
        end
        message += " You're also a team admin." if user.is_admin?
        send_message_with_gif client, data.channel, message, 'welcome'
        logger.info "REGISTER: #{data.user}"
        user
      end
    end
  end
end
