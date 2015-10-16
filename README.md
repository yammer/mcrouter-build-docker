# mcrouter package builder

This `Dockerfile` will create a `.deb` package for [mcrouter](https://github.com/facebook/mcrouter) for use on Ubuntu 12.04.  Yammer uses this package to deploy mcrouter to its production environments.


## Building

To build and copy the package to your local filesystem, run `make`.


## Testing package

To start up a new 12.04 Docker container with the built package installed, run `make test`.


## Updating

For updating to a new version of mcrouter, update the `MCROUTER_VERSION` and
`MCROUTER_SHA` environment variables in the `Dockerfile`.  You'll probably have
to update the `FOLLY_SHA` variable as well since mcrouter usually depends on the
latest version of Folly.
