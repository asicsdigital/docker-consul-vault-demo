# docker-consul-vault-demo


This project provides examples of how you might integrate Consul with an application. The aim is to give software and infrastructure engineers working example patterns that can be followed.

I've tried to make these examples understandable, please feel free to contribute if they can be better!

A quick word about namespace. We will be populating keys under the `demo` namespace/folder in the KV store. `demo` is a place holder for "the name of your app", so for example, for redis, you might use, `redis/ports` or `redis/maxconns`and so on.

### Start your infrastructure

`docker-compose up -d`

check `docker-compose logs`
Until you see :
> consul: New leader elected:

Once your local consul cluster is online, you can connect by pointing a browser at:   [http://localhost:8500](http://localhost:8500)


### consul-template examples

What is consul-template? From the README in : [consul-template](https://github.com/hashicorp/consul-template)

>The daemon consul-template queries a Consul or Vault cluster and updates any number of specified templates on the file system. As an added bonus, it can optionally run arbitrary commands when the update process completes.

To get an idea of all that the Templating language can to, check out the consul-template docs [here](https://github.com/hashicorp/consul-template#templating-language)

Once your infrastructure is up and running you can also open a browser window to [http://localhost:8080/](http://localhost:8080/) to view an example of consul-template populating a file served by nginx. Once your Consul cluster has elected a leader, you'll see a page that greets you with `Hello Docker!` This is the configured default if consul-template can't find a valid key.


To populate your local `$USER` environment variable in to the KV store as a value under the `demo` namespace run :

`docker-compose -f docker-compose-init.yml run consul-agent-kv-put-me`


To view what you've just populated, dump all the values under `demo`

`docker-compose -f docker-compose-init.yml run consul-agent-kv-get-all`

###### Using consul-template with a Web application

Now that you have a value in Consul, refresh the brower tab we opened to view our nginx application [http://localhost:8080/](http://localhost:8080/) you should now see your username populated!

consul-template handles populating the value if it exists, as well as reloads the service.


###### consul-template simple template example with services


In this example, consul template will read a simple template `tpl/in.tpl` and create an output file `tpl/out.txt`!  Consul-template will reuse the same `demo/user` value in the KV store if we've created it, but will also loop through the published services and list them.

`docker-compose -f docker-compose-init.yml run consul-template-me`

To view the output open or cat out the output file! `cat tpl/out.txt`

### envconsul examples
Coming Soon!
