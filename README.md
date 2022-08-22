#  README

https://github.com/worthingtonse/RAIDAX

https://github.com/worthingtonse/RAIDAX/blob/main/OFF_LEDGER.md

https://github.com/worthingtonse/RAIDAX/blob/main/Request_Response_Headers.md

https://github.com/worthingtonse/RAIDAX/blob/main/HOST.md

https://github.com/worthingtonse/RAIDAX/blob/main/Skywallet.md

https://www.webappfactory.co/super/host.txt

https://github.com/worthingtonse/RAIDAX/blob/main/file_format.md

#0-31 is 0s, 32/33/34 = serial number, 35-47 (13 bytes) for powning status, 48 - 448 (400 bytes) = 16 bytes of an X 25 = 400 bytes



/**
* For Multi packet powning (typically powning more than 28 coins at one go, we need to use multiple UDP packets. When using multiple UDP packets, here are the rules -

* 1. Only First packet contains header and challenge. This packet does NOT contain the separator (3E3E).

* 2. Intermediary packets contain just the body (no header or challenge or separator)

* 3. Last packet contains just the body(no header or challenge) AND the separator.

* 4. Even for multi packet powning, challenge is generated only once (for the first packet). Therefore, only 25 challenges are needed 1 for each RAIDA. We should generate them beforehand, because we need to generate the CRC32 of the entire body (all packets combined) to be put in the header for multi packet request, at byte position 6

* 5. We also need to generate the PANS of all the coins preemptively, so that we can generate the total body, and calculate the CRC32.

* 6. Also, at one time when sending a multi packet request, we can send only 64 packets at a time. Therefore, if you are powning > 28x64 coins at a time, you need to split it into arrays of 28x64 coins at a time, then consider each of them a separate multi packet powning request.
*/
