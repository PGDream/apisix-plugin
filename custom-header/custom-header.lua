local core = require("apisix.core")
local plugin_name = "custom-header"

local schema = {
    type = "object",
    properties = {
        header_name = {
            type      = "string",
            minLength = 1,
            maxLength = 2048
        },
        header_value = {
            type      = "string",
            minLength = 1,
            maxLength = 2048
        },
        is_over = {
            type    = "boolean",
            default = true
        }
    },
    require = { "source_header", "dest_header" }
}

local _M = {
    version  = 0.1,
    priority = 1,
    name     = plugin_name,
    schema   = schema
}

function _M.check_schema(conf)
   
    return core.schema.check(schema, conf)
end

function _M.access(conf, ctx)
    core.log.warn("config header:" .. core.json.encode(conf))
    
    if not ngx.req.get_headers() then 
        return 403, "request header not empty"
    end

    local s = ngx.req.get_headers()[conf.header_name]
    if not s then
        ngx.req.set_header(conf.header_name, conf.header_value)
        return
    end

    if s and conf.is_over then
        ngx.req.set_header(conf.header_name, conf.header_value)
    end
end

function _M.headers_filter(conf, ctx)
    
    ngx.header[conf.header_name] = conf.header_value
end

return _M
