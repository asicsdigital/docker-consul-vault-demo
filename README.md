# docker-consul-vault-demo

`docker-compose up -d`

check `docker-compose logs`
Until you see :
> consul: New leader elected:

Then run :
`docker-compose -f docker-compose-init.yml run consul-agent-kv-put-me`

to populate some data in the kv

now dump all the values

`docker-compose -f docker-compose-init.yml run consul-agent-kv-get-all`


consul template example

`docker-compose -f docker-compose-init.yml run consul-template-me`

`docker run --rm -it -v $(pwd)/tpl:/tpl --network docker-consul-vault-demo_consul-demo  hashicorp/consul-template -consul-addr "consul-server-bootstrap:8500" -template "/tpl/in.tpl:/tpl/out.txt" -once`
