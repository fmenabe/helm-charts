# fmenabe Helm charts

## Usage

```
helm install <RELEASE> oci://charts.fmena.be/charts/<CHART>
```

## Third-party charts

* [collabora-online](https://github.com/CollaboraOnline/online/tree/master/kubernetes/helm)

```
git clone https://github.com/CollaboraOnline/online build/collabora-online
cd build/collabora-online/kubernetes/helm
helm package collabora-online/
helm cm-push collabora-online-1.0.0.tgz
```

* [doh-server](https://github.com/satishweb/docker-doh/tree/master/helm)

```
git clone https://github.com/satishweb/docker-doh build/docker-doh
cd build/docker-doh/helm
helm package --version 2.2.3 doh-server/
helm cm-push doh-server-2.2.3.tgz
```

* [piraeus](https://github.com/piraeusdatastore/piraeus-operator/tree/v2/charts/piraeus)

```
git clone --branch v2 https://github.com/piraeusdatastore/piraeus-operator build/piraeus-operator
cd build/piraeus-operator/charts
helm package piraeus
helm cm-push piraeus-<VERSION>.tgz
```
