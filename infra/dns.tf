#cloudflare edge servers act as my domain's autoritative dns ns.
#DNS operates below HTTP, it doesn't know what a URL is, it only resolves hostnames.
data "cloudflare_zone" "domain" {
  name = "weirdcloud.dev"
}
//frontend: root domain
resource "cloudflare_record" "test" {
  zone_id = data.cloudflare_zone.domain.id
  name    = "test"
  type    = "CNAME"  
  content = azurerm_storage_account.frontend.primary_web_host
  proxied = true //if false, Cloudflare acts strictly as a routing table. It returns the Azure Storage FQDN directly to the client. The client connects directly to Azure.
  //true -> Cloudflare intercepts the traffic. It returns Cloudflare's own Anycast IP addresses to the client, terminates the SSL connection at the edge, applies caching/WAF rules, and then proxies the request to your Azure backend.
}

# //www
# resource "cloudflare_record" "www"{
#   zone_id = data.cloudflare_zone.domain.id
#   name = "www"
#   type = "CNAME"
#   content = azurerm_storage_account.resume.primary_web_host
#   proxied =true 
# }
//api
resource "cloudflare_record" "api"{
  zone_id = data.cloudflare_zone.domain.id
  name = "pp"
  type = "CNAME"
  content = azurerm_function_app_flex_consumption.visitor_counter_api.default_hostname //fqdn -> [myaccount.z13.web.core.windows.net.], dns does not work at http level, no shema or url
  proxied = true
}

//not needed here
# # Force HTTPS to ALL of weirdcloud.dev, zone-wide.
# resource "cloudflare_zone_settings_override" "settings" {
#   zone_id = data.cloudflare_zone.domain.id
#   settings {
#     ssl            = "full" // 
#     always_use_https = "on" 
#     min_tls_version  = "1.2"
#   }
# }

////////////////////////////custom domain binding////////////////////////////////////
//azure's asuid method, TXT, newer than asverify CNAME method: separates the concepts of Routing and Proof of Ownership, instead use a cryptographic string (the custom_domain_verification_id) that acts as a password.

#The hidden TXT record to prove ownership to Azure
resource "cloudflare_record" "api_verification" {
  zone_id = data.cloudflare_zone.domain.id
  name    = "asuid.pp" #"asuid." prefix
  type    = "TXT"
  content = azurerm_function_app_flex_consumption.visitor_counter_api.custom_domain_verification_id // this is a token string that azure desgined this for custom domain verification, does not change over time
  proxied = false # TXT records cannot be proxied
}


//this is so azure does not query the asuid.app TXT record before cloudflare set it up.
resource "time_sleep" "wait_for_dns" {
  depends_on = [cloudflare_record.api_verification]
  create_duration = "30s"
}

#The Azure Custom Domain Binding
resource "azurerm_app_service_custom_hostname_binding" "api_binding" {
  hostname            = "pp.weirdcloud.dev"
  app_service_name    = azurerm_function_app_flex_consumption.visitor_counter_api.name
  resource_group_name = azurerm_resource_group.resume.name
  # Tell Terraform to wait for the TXT record to exist before trying to bind
  depends_on = [
    time_sleep.wait_for_dns,
    cloudflare_record.api_verification,
    cloudflare_record.api //needs the CNAME to exist
    ] 
}