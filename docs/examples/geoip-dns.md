# GeoIP DNS

This tutorial aims to provide an end-to-end guideline of how to leverage Liqo and K8GB using the GeoIP strategy.

## Requirements

### GeoIP Database

As per the K8GB [documentation](https://www.k8gb.io/docs/strategy.html#geoip), in order to use the GeoIP strategy, you need a GeoIP Database which can be either ``crafted'' (following the instructions in the following [link](https://blog.maxmind.com/2020/09/enriching-mmdb-files-with-your-own-data-using-go/)) or otherwise, downloaded directly from [Maxmind](https://www.maxmind.com/en/home). For this guide, we will leverage the free GeoLite2 Country Database (to download it, you just need to [sign up](https://www.maxmind.com/en/geolite2/signup?lang=en) in Maxmind).

Once you register, you should have access to a file named `GeoLite2-Country.mmdb`.

## Provision the playground

*The following instructions are similar to the [Global Ingress Example](global-ingress.md)*

You need to check that you are compliant with the [requirements](/examples/requirements.md).
Additionally, this example requires [k3d](https://k3d.io/v5.4.1/#installation) to be installed in your system.
Specifically, this tool is leveraged instead of KinD to match the [K8GB Sample Demo](https://www.k8gb.io/docs/local.html#sample-demo).

To provision the playground, clone the [Liqo repository](https://github.com/liqotech/liqo) and run the setup script:

{{ env.config.html_context.generate_clone_example('geoip-dns') }}

The setup script creates three k3s clusters and deploys the appropriate infrastructural application on top of them, as detailed in the following:

* **edgedns**: this cluster will be used to deploy the DNS service.
  In a production environment, this should be an external DNS service (e.g. AWS Route53).
  It includes the Bind Server (manifests in `manifests/edge` folder).
* **gslb-eu** and **gslb-us**: these clusters will be used to deploy the application.
  They include:
  * [ExternalDNS](https://github.com/kubernetes-sigs/external-dns): it is responsible for configuring the DNS entries.
  * [Ingress Nginx](https://kubernetes.github.io/ingress-nginx/): it is responsible for handling the local ingress traffic.
  * [K8GB](https://www.k8gb.io/): it configures the multi-cluster ingress.
  * [Liqo](/index.rst): it enables the application to spread across multiple clusters, and takes care of reflecting the required resources.