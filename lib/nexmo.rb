require 'nexmo'
class SMS
  class << self
    def send(to, body)
      nexmo = Nexmo::Client.new(ENV['CM_NEXMO_SID'],ENV['CM_NEXMO_SECRET'])
      response = nexmo.send_message!({:to => to, :from => 'Charity Map', :text => body})
      if response.ok?
        return true
      else
        return false
      end
    end
  end
end