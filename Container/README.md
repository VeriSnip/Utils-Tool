# Container Documentation

If you encounter the following error while building the image:

```
c++: fatal error: Killed signal terminated program cc1plus
```

It is likely that the VM is running out of available RAM. To resolve this, you should increase the RAM limit in Podman. Follow these steps:

```
podman machine stop
podman machine set --cpus 4 --memory 8196
podman machine start
```
