#docker run -itd -p 80:80 -p 88:88 -p 8080:8080 -p 8081:8081 -p 8082:8082 -v /opt/docker-volumes/docker-proxy/opt/:/opt/  --privileged --volume /run/dbus/system_bus_socket:/run/dbus/system_bus_socket:ro   $1

docker run -itd -p 80:80 -p 48081:80  -p 4998:4998 -p 4997:4997 -p 4996:4996 --name inspection  --privileged  --volume /run/dbus/system_bus_socket:/run/dbus/system_bus_socket:ro  --add-host vicube:10.1.12.42  --add-host xj.com:127.0.0.1 $1  /sbin/init  
