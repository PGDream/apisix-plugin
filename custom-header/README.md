# 操作手册

`ingress-apisix` 命名空间与`apisix`集群同命名空间

```=shell
# kubectl create configmap custom-header -n ingress-apisix --from-file /Users/zengqiang/lua-repository/apisix-plugin/custom-header/custom-header.lua
# kubectl get configmap -n ingress-apisix
```

### `helm upgrade APISIX`

- `customPlugins.luaPath:` `APISIX`集群加载自定义插件路径，这边只需要写`mounts`前缀，因为集群在加载时会默认加`apisix/plugin`目录
- `customPlugins.plugins.attrs:` 加载插件时需要的属性，示例插件不需要默认属性所以临时定义几个属性，因为在`helm apisix 0.9.1`版本中该字段为空`apisix`启动就抛解析`config.yaml`异常
- `customPlugins.plugins.configMap.mounts.path:` 犹如上面提到的该字段值是`luaPath`与默认路径的拼接值，需要挂载到具体文件`/opts/apisix/plugins/custom-header.lua`

```=yaml
customPlugins:
  enabled: true
  # the lua_path that tells APISIX where it can find plugins,
  # note the last ';' is required.
  luaPath: "/opts/?.lua;"
  plugins:
    # plugin name.
    - name: "custom-header"
      # plugin attrs
      attrs:
        custom-header:
           custom_header_name: "CUSTOM_HEADER"
      # plugin codes can be saved inside configmap object.
      configMap:
        # name of configmap.
        name: "custom-header"
        # since keys in configmap is flat, mountPath allows to define the mount
        # path, so that plugin codes can be mounted hierarchically.
        mounts:
          - key: "custom-header.lua"
            path: "/opts/apisix/plugins/custom-header.lua"
```
