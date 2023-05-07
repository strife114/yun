# 开放镜像权限

```
glance member-create 镜像ID 项目ID
glance member-update 镜像ID 项目ID accepted
```

# glance对接后端存储

```
vim /etc/cinder/cinder.conf
allowed_direct_url_schemes = cinder
image_upload_use_internal_tenant = true

vim /etc/glance/glance-api.conf
show_multiple_locations = true
```

# Nova清除缓存

```
vim /etc/nova/nova.conf
remove_unused_base_images=true

openstack-service restart

```

