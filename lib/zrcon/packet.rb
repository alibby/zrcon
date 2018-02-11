class Zrcon
  class Packet
    attr_accessor :id, :type, :data

    def initialize(id:,  type: 2, data: "")
      @id = id
      @type = type
      @data = data
    end

    def encode
      [10 + data.length, id, type, data].pack("l<l<l<A#{data.length}xx")
    end

    def self.decode(raw)
      raw = raw.to_s
      fields = raw.unpack("l<l<A#{raw.length - 10}xx")

      Packet.new id: fields.shift, type: fields.shift, data: fields.shift
    end
  end
end
