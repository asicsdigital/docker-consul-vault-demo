# docker-consul-vault-demo


This project provides examples of how you might integrate Consul with an application. The aim is to give software and infrastructure engineers working example patterns that can be followed.

I've tried to make these examples understandable, please feel free to contribute if they can be better!

A quick word about namespace. We will be populating keys under the `demo` namespace/folder in the KV store. `demo` is a place holder for "the name of your app", so for example, for redis, you might use, `redis/ports` or `redis/maxconns`and so on.

### Start your infrastructure

```sh
$ docker-compose up -d
```

check `docker-compose logs`
Until you see :
> consul: New leader elected:

Once your local consul cluster is online, you can connect by pointing a browser at:   [http://localhost:8500](http://localhost:8500)


### consul-template examples

What is consul-template? From the README in [consul-template](https://github.com/hashicorp/consul-template):

>The daemon consul-template queries a Consul or Vault cluster and updates any number of specified templates on the file system. As an added bonus, it can optionally run arbitrary commands when the update process completes.

To get an idea of all that the Templating language can do, check out the consul-template docs [here](https://github.com/hashicorp/consul-template#templating-language).

Once your infrastructure is up and running you can also open a browser window to [http://localhost:8080/](http://localhost:8080/) to view an example of consul-template populating a file served by nginx. Once your Consul cluster has elected a leader, you'll see a page that greets you with `Hello Docker!` This is the configured default if consul-template can't find a valid key.


To populate your local `$USER` environment variable in to the KV store as a value under the `demo` namespace run :

```sh
$ docker-compose -f docker-compose-init.yml run consul-agent-kv-put-me
```


To view what you've just populated, dump all the values under `demo`

```sh
$ docker-compose -f docker-compose-init.yml run consul-agent-kv-get-all
```

###### Using consul-template with a web application

Now that you have a value in Consul, refresh the brower tab we opened to view our nginx application [http://localhost:8080/](http://localhost:8080/) you should now see your username populated!

consul-template handles populating the value if it exists, as well as reloads the service.


###### consul-template simple template example with services


In this example, consul template will read a simple template `tpl/in.tpl` and create an output file `tpl/out.txt`!  Consul-template will reuse the same `demo/user` value in the KV store if we've created it, but will also loop through the published services and list them.

```sh
$ docker-compose -f docker-compose-init.yml run consul-template-me`
```

To view the output open or cat out the output file! `cat tpl/out.txt`

### envconsul examples

envconsul is a complementary toolkit to consul-template.  Rather than write out files to disk, envconsul queries Consul to retrieve key/value data, then inserts that data as variables into the environment of another process.  In addition, envconsul watches the specified keys for changes, and reacts to changes by updating the environment and sending a signal to the supervised process.

Why would one want to do this?  This tooling is designed to facilitate the storing of application configuration in the environment, which is the [third factor](https://12factor.net/config) of the [twelve-factor application pattern](https://12factor.net/).

##### Using envconsul with a web application

When you started up your Consul cluster earlier in the procedure, a simple "healthcheck" service was also started.  This service listens at [http://localhost:3000/healthcheck](http://localhost:3000/healthcheck) and returns some JSON representing a service healthcheck result, using an appropriate HTTP status code (200 for healthy, anything else for unhealthy).

This application reads its configuration from its environment; it looks for the environment variables `HEALTHCHECK_APP`, `HEALTHCHECK_STATUS`, and `HEALTHCHECK_METRICS` to tell it how to respond.  Take a look at the default response now:

```sh
$ curl http://localhost:3000/healthcheck
{"application":"healthcheck","status":200,"metrics":{}}
```

The application is supervised by envconsul, which talks to your Consul cluster and looks for keys under the `healthcheck` namespace.  To populate those keys (or to reset them to defaults after changing them), run the following command:

```sh
$ docker-compose -f docker-compose-init.yml run consul-agent-healthcheck-init
```

To inspect the keys, browse to the `healthcheck` namespace in the KV store via the [Consul UI](http://localhost:8500).

Now, try changing one of those keys.  Select the `healthcheck/healthcheck_app` key and change its value to `nyancat`, then click Update.  Then query the healthcheck service again:

```sh
$ curl http://localhost:3000/healthcheck
{"application":"nyancat","status":200,"metrics":{}}
```

Try changing the other keys under `healthcheck` and observe the effects!
