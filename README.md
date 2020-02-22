# Docker image for ROS Melodic with VNC

## Quick start
```
docker run -it -p 6080:80 nxtruong/rosmelodicvnc
```
Then open your browser and go to http://127.0.0.1:6080/.
After you've connected to the Ubuntu in Docker, click the button at the bottom left of the screen, go to System Tools, and run one of the terminals.

If you want to use a dedicated remote desktop program (VNC) instead of your web
browser, start the container with the following command:
```
docker run -it --rm -p 6080:80 -p 5900:5900 nxtruong/rosmelodicvnc
```
Use your favorite VNC program to log onto `127.0.0.1:5900`.

Sometimes, an error may happen that the port 5900 is already used. In that case, change the command to
```
docker run -it --rm -p 6080:80 -p 5901:5900 nxtruong/rosmelodicvnc
```
and use your VNC program to log onto `127.0.0.1:5901`.
