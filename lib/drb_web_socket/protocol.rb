# frozen_string_literal: true

require "wands"
require "uri"

module DRbWebSocket
  # A protocol with WebSocket for drb.
  module Protocol
    class << self
      def open(uri, config)
        host, port = parse_uri(uri)
        socket = Wands::WebSocket.open(host, port)
        ConnectionToServer.new(uri, socket, config)
      end

      def open_server(uri, config)
        host, port = parse_uri(uri)
        server = Wands::WebSocketServer.open(host, port)

        if port.zero?
          addr = server.addr
          port = addr[1]
        end
        uri = "drbws://#{host}:#{port}"

        Server.new(uri, server, config)
      end

      def uri_option(uri, config)
        [uri, config]
      end

      private

      def parse_uri(uri)
        parsed_uri = URI.parse(uri)
        raise(DRb::DRbBadScheme, uri) unless parsed_uri.scheme == "drbws"

        [parsed_uri.host, parsed_uri.port]
      rescue URI::InvalidURIError
        raise(DRb::DRbBadURI, "can't parse uri:#{uri}")
      end
    end
  end
end
