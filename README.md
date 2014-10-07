Hochschober
===========

Boilerplate for REST Api with automatic JSON to HTML presentation layer. Based on Plack.


### How to run


Use any [Plack](http://plackperl.org/) compliant web server.

```
starman web/server.psgi
```

### How to add resources

1. make a module with GET, POST, DELETE subs
2. map URL to this module in config.yaml


### How to add more JSON -> HTML methods

1. make a module with `do` sub which accepts a perl variable (hash)
2. map JSON path to this module in config.yaml

### Acknowledgements

Parts of this project are clean room implementations of ideas seen elsewhere.

### Used Open Source Projects

* jQuery
* Bootstrap
* Perl and CPAN
