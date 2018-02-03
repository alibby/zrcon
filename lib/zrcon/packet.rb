class Zrcon
  class Packet
    attr_accessor :id, :type, :data

    def initialize(id: next_id, type: 2, data: "")
      @id = id
      @type = type
      @data = data
    end

    def next_id
      @@id ||= -1
      @@id += 1
    end

    def encode
      [10+data.length, id, type, data].pack("l<l<l<A#{data.length}xx")
    end

    def self.auth password
      new type: 3, data: password
    end

    def self.command cmd
      new type: 2, data: cmd
    end

    def self.decode raw
      raw = raw.to_s
      fields = raw.unpack("l<l<Z*x")

      Packet.new id: fields.shift, type: fields.shift, data: fields.shift
    end
  end
end

