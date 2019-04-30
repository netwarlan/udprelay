UDP RELAY
=========
CREDIT: Luke Bratch @ http://www.bratch.co.uk/udprelay/
Disclosure: I didn't write the main UDP Relay software package - I'm just packaging this into a docker container for easy deployment.

This container is responsible for making Steam SRCDS games like CS:GO, TF2, L4D2 and others, show in the Steam Server browser. Due to how Linux handles broadcast traffic and we are not attaching our game containers to our host network directly, our game servers lose their "discoverability". This script assists in relaying UDP packets from the broadcast address to our game servers who reply with the information. 

How to use
----------
```
docker run -d --rm --net=host \
netwarlan/udprelay 255.255.255.255 <Listening Port> <SRCDS Destination Port> <SRCDS Game Server IPs>
```

- The `255.255.255.255` tells the `udprelay` script to listen to our broadcast address on the network. (We need to use `--net=host` to ensure we are on the correct broadcast network).
- `<Listening Port>` is the port the Steam Client is looking for. In almost all cases, this is `27015` through `27020`. 
- `<SRCDS Destination Port>` is the port this container will forward udp traffic to. 
- `<SRCDS Game Server IPs>` is the ip addresses of our game servers (or the host where our game containers are running. This can be multiple IP addresses spaced. `192.168.1.2 192.168.1.3 ....`


Example:
```
docker run -d --rm --net=host \
netwarlan/udprelay 255.255.255.255 27015 27015 10.10.10.101 10.10.10.102
```
In the above example, we're listening on the broadcast address: `255.255.255.255` for udp traffic on port `27015`. When traffic is found, we are forwarding to ports `27015` on `10.10.10.101` and `10.10.10.102`.


Other Use Cases
---------------
Note in the above section our `<SRCDS Destination Port>`. Because we can expose non-SRCDS via Docker and it's port publishing, we don't actually need to stick to Valve ports like `27015`. 


Let's say we have something like this for our CS:GO container:
```
docker run -d -p 6666:27015/udp \
netwarlan/csgo-5v5
```

Docker-proxy is taking care of our traffic routes between our host port `6666` and internal port of `27015`. Because of this, we can change our udp relay script to look like this:

```
docker run -d --rm --net=host \
netwarlan/udprelay 255.255.255.255 27015 6666 10.10.10.101
```

We will get the result of our game container being available via Steam's LAN browser. This is really neat as we can host way more game containers per host (well beyond the normal 5 SRCDS per IP limit) and we can set them to all be discoverable. Now, our LAN parties solve this problem by giving our host multiple IP addresses and binding docker containers to those IPs - but if you're in a limited IP space, this option may work for you or if you need to run your game server on a non-standard SRCDS port and don't want to mess with the container's internal port. 