A few months ago, SSL was rolled out as an included feature for every app on the Heroku platform by enabling secure connection to each app's **heroku/herokuapp.com** domain, so even if developers prefer to use a custom domain, they'll at least have an SSL option for the components of their app where a secure connection is critical.

The platform's answer for developers requiring SSL on a custom domain is the use of the [SSL Endpoint](https://devcenter.heroku.com/articles/ssl-endpoint) is priced at $20 a month (the good news being that at least the $100 a month ssl:ip is being phased out). After adding the SSL Endpoint addon to an app, it allows an endpoint to be created using a single cert, and proceeds to route secure traffic to your app with no coding changes required.

Any given request on the Heroku platform enters through the [routing mesh](https://devcenter.heroku.com/articles/http-routing), which finds an appropriate runtime where the the requested app is deployed and forwards it through.

The Sharing Trick
-----------------

Requests coming through an SSL Endpoint are no exception&mdash;the request may enter through an endpoint but from there is routed normally through the mesh. In short, it's not an SSL Endpoint's associated app that decides where a request goes, but rather the incoming domain that's been CNAME'd to the endpoint.

This behavior can be leveraged to allow a single SSL Endpoint to route to more than one Heroku app. For the connection to stay secure, the cert uploaded to the endpoint needs to be signed for any domains that you intend to use for it, but that's not usually a problem. Even a [free cert from StartCom](http://www.startcom.org/) allows up to two domains to be assigned to a cert without any special verification. A wildcard certificate (i.e. `*.mutelight.org`) will allow you to route to any number of different Heroku apps hosted on your subdomains.

Below is a simple example demonstrating how a single endpoint is shared for both [brandur.org](https://brandur.org) and [facts.brandur.org](https://facts.brandur.org):

``` bash
#
# the app brandur-org below has ssl:endpoint
# the app facts-web does not
#

$ heroku addons -a brandur-org
ssl:endpoint

$ heroku addons -a facts-web
No addons installed

#
# both www.brandur.org (entry point for the app brandur-org) and
# facts.brandur.org (app facts-web) are CNAME'd to mie-6498
#

$ host www.brandur.org
www.brandur.org is an alias for mie-6498.herokussl.com.

$ host facts.brandur.org
facts.brandur.org is an alias for mie-6498.herokussl.com.

#
# both apps get a secure connection because brandur-org's cert includes both
# domains
#

$ heroku certs -a brandur-org
Endpoint                Common Name(s)           Expires               Trusted
----------------------  -----------------------  --------------------  -------
mie-6498.herokussl.com  facts.brandur.org,       2013-07-21 03:31 UTC  True
                        www.brandur.org
```
