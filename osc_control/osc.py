import argparse
import time

from pythonosc import osc_message_builder
from pythonosc import udp_client


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--ip", default="127.0.0.1",
                        help="The ip of the OSC server")
    parser.add_argument("--port", type=int, default=57200,
                        help="The port the OSC server is listening on")
    args = parser.parse_args()

    client = udp_client.UDPClient(args.ip, args.port)


    print("Sending message")
    msg = osc_message_builder.OscMessageBuilder(address="/*/note_on")
    msg.add_arg(1)
    msg.add_arg(35)
    msg.add_arg(60)
    msg = msg.build()
    client.send(msg)
    time.sleep(3)

    msg = osc_message_builder.OscMessageBuilder(address="/*/note_off")
    msg.add_arg(1)
    msg.add_arg(35)
    msg.add_arg(60)
    msg = msg.build()
    client.send(msg)
