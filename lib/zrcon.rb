require 'socket'

require_relative 'zrcon/packet'
require_relative 'zrcon/version'

class Zrcon
  attr_accessor :host, :port, :password

  def initialize(host=ENV['RCON_HOST'], port=ENV['RCON_PORT'], password=ENV['RCON_PASSWORD'])
    @host = host.to_s
    @port = port.to_i
    @password = password.to_s
  end

  def auth
    request = Packet.auth password
    send request
    response = receive

    response.type == 2 && request.id == response.id
  end

  def command(cmd)
    request = Packet.command cmd
    send request
    response = receive
    response.data
  end

  private

  def conn
    @conn ||= TCPSocket.new host, port
  end

  def next_id
    @id ||= 0
    @id += 1
  end

  def send packet
    conn.write packet.encode
  end

  def receive
    length = read_int
    Packet.decode conn.read(length)
  end

  def read_int
    conn.read(4).to_s.unpack("l<").first
  end
end
