# Telnet Server container image

This Dockerfile builds a Windows Servercore container image with the SimpleTCP Windows services, so you can test connectivity to a Windows the container through TCP/IP. It publishes the following ports:

*  7: echo, repeats any character you send to it using a telnet session
*  9: discard, discards all the bytes it receives
* 13: quotd, returns a quote of the day text and ends the connection
* 19: chargen, generates all the charset infinitely