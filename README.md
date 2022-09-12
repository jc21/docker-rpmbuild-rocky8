# Rocky Linux 8 RPM Build Environment

This container allows you to use your existing RPM build folders but build within the Rocky Linux 8 environment.

The container has:

* EPEL
* Common build packages

## Setup

You'll need to create your standard RPM build directory structure as follows:

```
rpmbuild
  - BUILD
  - BUILDROOT
  - RPMS
  - SOURCES
  - SPECS
  - SRPMS
  - tmp
```

Of course put your spec files in SPECS and your source files in SOURCES.

## Usage

If you want to build just one spec in particular:

```bash
sudo docker run \
    --name rpmbuild-rocky8 \
    -v /path/to/your/rpmbuild:/home/rpmbuilder/rpmbuild \
    --rm=true \
    jc21/rpmbuild-rocky8 \
    /bin/build-spec /home/rpmbuilder/rpmbuild/SPECS/something.spec
```

Or if you want to build all specs in your SPECS folder:

```bash
sudo docker run \
    --name rpmbuild-rocky8 \
    -v /path/to/your/rpmbuild:/home/rpmbuilder/rpmbuild \
    --rm=true \
    jc21/rpmbuild-rocky8 \
    /bin/build-all
```

The build-spec script will go to the trouble of installing any requires that the spec file needs to build.

Built RPMS will show up in the RPMS/SRPMS folders if successful.

## Script it!

Here's an example of wrapping that stuff above in a script. Let's call it build.sh:

```bash
#!/bin/bash

SPEC=$1
RPMBUILDROOT=/path/to/your/rpmbuild

if [ "$1" == "" ]; then
    echo "Usage: build.sh specfile.spec"
    exit 1;
else
    sudo docker run \
        --name rpmbuild-rocky8 \
        -v $RPMBUILDROOT:/home/rpmbuilder/rpmbuild \
        --rm=true \
        jc21/rpmbuild-rocky8 \
        /bin/build-spec /home/rpmbuilder/rpmbuild/SPECS/$SPEC

    exit $?
fi
```

Then to run it:

```bash
./build.sh something.spec
```

## Building with the latest C++ compiler

Devtools-8 is part of this image. To enable it as part of the building process just add the following environment variable to the docker command:

```bash
-e DEVTOOLS=1
```
