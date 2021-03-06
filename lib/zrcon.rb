require 'socket'

require_relative 'zrcon/packet'
require_relative 'zrcon/version'

class Zrcon
  ConnectError = Class.new(StandardError)

  attr_accessor :host, :port, :password, :id

  def initialize(host: ENV['RCON_HOST'], port: ENV['RCON_PORT'], password: ENV['RCON_PASSWORD'])
    @host = host.to_s
    @port = port.to_i
    @password = password.to_s
    @id = 0
  end

  def auth
    request = auth_packet password
    send request
    response = receive

    response.type == 2 && request.id == response.id
  end

  def command(command)
    send command_packet command
    response = receive

    if response.id == -1
      nil
    else
      response.data
    end
  end

  def send(packet)
    conn.write packet.encode
  end

  def command_packet(cmd)
    Packet.new id: next_id, type: 2, data: cmd
  end

  def conn
    @conn ||= TCPSocket.new host, port
  rescue SocketError
    raise ConnectError, "bad hostname perhaps? (#{host})"
  rescue Errno::ETIMEDOUT
    raise ConnectError, "timed out connecting to #{host}:#{port}"
  rescue Errno::ECONNREFUSED
    raise ConnectError, "connection refused"
  end

  def next_id
    @id ||= 0
    @id += 1
  end

  def receive
    length = read_int
    Packet.decode conn.read(length)
  end

  def read_int
    conn.read(4).to_s.unpack("l<").first
  end

  def auth_packet(password)
    Packet.new id: next_id, type: 3, data: password
  end

end
