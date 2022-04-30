
# `APISIX`内置模块介绍

- `conf`参数是插件的相关配置信息
- `ctx`参数缓存请求相关的数据信息

## `ngx` 变量

`ngx`内置变量即为`openresty`中的`ngx`全局变量

|变量路径|变量说明|
|-|-|
|ngx.req|所有请求中变量都可使用|
|ngx.resp|所有请求`response`变量都可以使用|

## `conf`参数列举

插件把函数注册到`apisix`插件引擎，默认会给插件提供`conf、ctx`等参数对象

|变量路径|变量协议|
|-|-|
|conf.{schema}|通过`conf.`定义`schema`获取数据|

## `ctx`参数列举

`local var = ctx.var`

|变量路径|变量说明|
|-|-|
|var.schem|请求协议|
|var.host|请求`host`|
|var.server_port|请求端口|
|var.upstream_uri|`upstream uri`|

- 自定义缓存数据各阶段传递

```=lua
function _M.rewrite(conf,ctx)
   ctx.metadata = { name = "plugin" }
end

function _M.access(conf,ctx)
   if ctx.metadata == "plugin" then
       return 403, "plugin name not validate"
   end
end
```

## `core`模块介绍

### `core.string` 子模块介绍

#### `core.string.find()`

```=shell
local user = "jxa"
local s, e = core.string.find(user, "jx")
```

### `core.schema.check()`

```=shell
schema 插件文件定义的schema
local ok, err = core.schema.check(schema, conf)
```

### `core.log.warn()`

日志级别: `info,warn,error`

```=shell
core.log.warn(")
```

### `core.json.encode()`

```=shell
local schema = core.json.encode(conf)

```
