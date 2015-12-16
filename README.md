# mcrouter package builder

This `Dockerfile` will create a `.deb` package for [mcrouter](https://github.com/facebook/mcrouter) for use on Ubuntu 12.04 or 14.04.  Yammer uses this package to deploy mcrouter to its production environments.


## Building

To build and copy the package to your local filesystem, run `make`.


## Testing package

To start up a new 12.04 or 14.04 Docker container with the built package installed, edit
the `UBUNTU_RELEASE` variable at the top of the Makefile and run `make test`.


## Updating

For updating to a new version of mcrouter, update the `MCROUTER_VERSION` and
`MCROUTER_SHA` environment variables in the `Dockerfile`. This will default to the latest
release tag, but you can replace that with a specific commit hash if you need to.
