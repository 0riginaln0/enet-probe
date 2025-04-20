# ENet library

ENet library is network communication layer on top of UDP. The primary feature it provides is both `"unsequenced"`, `"unreliable"` and `"reliable"` delivery of packets.
- *Unsequenced* packets are neither guaranteed to arrive, nor do they have any guarantee on the order they arrive.
- *Unreliable* packets arrive in the order in which they are sent, but they aren't guaranteed to arrive.
- *Reliable* packets are guaranteed to arrive, and arrive in the order in which they are sent.

# Terminology
## Host

A host in networking terminology refers to any device that connects to a network and has an Internet address. Hosts can be any device capable of sending and receiving data over a network, including computers, servers, smartphones, and IoT devices.

## Address

ip:port

"127.0.0.1:8888", "localhost:2232", "*:6767"

## Channel

Channels in ENet are used to seperate `"reliable"`, `"unsequenced"` and `"unreliable"` messages.

Each channel is independently sequenced, and so the delivery status of a packet in one channel will not stall the delivery of other packets in another channel.

If you will send `"reliable"` and `"unreliable"` messages in the same channel, your unreliable messages will be blocked by the `"reliable"` one. So please use different channels for different types of messages.

## Peer

Any *host* that you have connection to.

The server's peers could be all the clients (players) that are connected to the server. While client's peer could be one server it joined in.

Peers are used to send messages.

## Event

Event is a Lua table with several fields depending on the event type.

|  event.type  | event.peer | event.data | event.channel |
| :----------: | :--------: | :--------: | :-----------: |
|  "receive"   |    peer    |   string   |    number     |
| "disconnect" |    peer    |   number   |               |
|  "connect"   |    peer    |   number   |               |

All of event types have a peer.

When event type is "receive" it's data is a `string` and only this type of event has a channel field which specifies the number of the channel.

Every other event's data is `number`

