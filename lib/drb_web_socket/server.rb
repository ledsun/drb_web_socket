# frozen_string_literal: true

module DrbWebSocket
  # A protocol instance from DrbWebSocket::Protocol.open_server.
  class Server
    def initialize(uri, socket, config = {})
      @uri = uri
      @socket = socket
      @config = config
    end

    def accept
      Socket.new(@uri, @socket, @config)
    end
  end
end
