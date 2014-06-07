require 'digest/sha1'
class InterfacesController < ActionController::Base
  def index
    render :text => signature_match?(params) ? params[:echostr] : 'not match'
  end

  def create
    puts "== request.body: #{request.body.sysread}"
    puts "params: #{params.inspect}"
    result = signature_match?(params) ? params[:echostr] : 'not match'
    puts "result : #{result}"
    render :text => result
  end
  private
  def signature_match? params
    puts " == checking `params: #{params.inspect}"
    token = 'siwei'
    string = [token, params[:timestamp], params[:nonce]].sort.join rescue ''
    signature = Digest::SHA1.hexdigest string
    return signature == params[:signature]
  end
end
