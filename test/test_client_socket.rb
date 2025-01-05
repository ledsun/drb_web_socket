# frozen_string_literal: true

require "stringio"

class TestClientSocket < Minitest::Test
  def test_initialize
    assert_instance_of DRbWebSocket::ClientSocket, DRbWebSocket::ClientSocket.new("ws://localhost:8080", nil, {})
  end

  # rubocop:disable Metrics/MethodLength
  def test_recv_reply
    # Setup a DRb server
    array = [1, 2, 3]
    drb_server = DRb.start_service("druby://localhost:0", array)

    # Setup a ServerSocket
    buffer = StringIO.new(+"", "r+")
    server_socket = DRbWebSocket::ServerSocket.new("ws://localhost:8080", buffer, drb_server.config)
    server_socket.send_reply(true, [123, "abc"])

    # Receive the reply
    buffer.rewind
    client_socket = DRbWebSocket::ClientSocket.new("ws://localhost:8080", buffer, drb_server.config)
    succ, reply_value = client_socket.recv_reply

    assert succ
    assert_equal [123, "abc"], reply_value
  ensure
    buffer&.close
    drb_server&.stop_service
  end
  # rubocop:enable Metrics/MethodLength
end
