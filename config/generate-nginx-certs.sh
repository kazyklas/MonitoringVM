#!/bin/sh

# domain name
export certfile="grafana-server"

# Self generated certs
# for using them edit config/sites/grafan-server.config 
# to lookup for the cert and not pem
# openssl req -new \
#     -newkey rsa:4096 \
#     -days 365 \
#     -nodes -x509 \
#     -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.grafana-server.cz" \
#     -keyout /opt/nginx/etc/nginx/certs/grafana-server.key \
#     -out /opt/nginx/etc/nginx/certs/grafana-server.cert


# # generate new certificates
# For the first time you have to run nginx without certs enabled
# after that you can generate cert with this script, uncoment and restart 
docker exec nginx \
	/root/.acme.sh/acme.sh \
	--issue --keylength 3072 \
	--domain ${certfile} \
	--webroot /etc/nginx/certs/webroot/${certfile} \
	--certpath /etc/nginx/certs/${certfile}.crt \
	--keypath /etc/nginx/certs/${certfile}.key \
	--capath /etc/nginx/certs/ca-${certfile}.crt \
	--fullchainpath /etc/nginx/certs/${certfile}.pem \
	--reloadcmd "nginx -s reload"

result=$?

if [ $result -eq 2 ];
then
	# We've got 
	## Domains not changed.
	## Skip, Next renewal time is: Mon Aug 19 09:16:38 UTC 2019
	## Add '--force' to force to renew.
	exit 0
fi
exit $result
