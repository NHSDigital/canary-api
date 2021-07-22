function setQuotaVars(prefix, quotaVars, topKey) {
    if (quotaVars !== null && quotaVars.hasOwnProperty(topKey)){
        for (var key in quotaVars[topKey]){
            context.setVariable(prefix + key, quotaVars[topKey][key]);
        }
    }
}

// First check the product placeholder values
var productQuota = {
    "limit": context.getVariable("apiproduct.developer.quota.limit"),
    "interval": context.getVariable("apiproduct.developer.quota.interval"),
    "timeunit": context.getVariable("apiproduct.developer.quota.timeunit")
}
setQuotaVars("proxy_quota_", productQuota)

var quotas = context.getVariable("apiproduct.quotas")
var proxyName = context.getVariable("apiproxy.name")

if (quotas){
    quotas = JSON.parse(quotas)

    // generic proxy values - overrides placeholder values
    setQuotaVars("proxy_quota_", quotas, "proxy")

    // specific proxy values - overrides the generic proxy values
    setQuotaVars("proxy_quota_", quotas, proxyName)

    // default per-app quota values
    setQuotaVars("app_quota_", quotas, "app")
}


var appQuotas = context.getVariable("app.quotas")
if (quotas){
    appQuotas = JSON.parse(appQuotas)

    // specific per-app quota values - overrides default per-app quota values
    setQuotaVars("app_quota_", appQuotas, proxyName)
}
