# # 1. Write the resource block matching the existing record
# resource "cloudflare_record" "root" {
#   zone_id = var.cloudflare_zone_id
#   name    = "@"
#   type    = "CNAME"   # or A, whatever yours is
#   content = "your-blob-storage-endpoint"
#   proxied = true
# }

# # 2. Get the record's ID from Cloudflare (dashboard, or `cloudflare` API/CLI)
# # 3. Import it
# terraform import cloudflare_record.root <zone_id>/<record_id>

# # 4. Confirm zero drift
# terraform plan

# //always import, never blind-apply, for resources that already exist outside Terraform. If plan shows any diff after import, fix your .tf to match the live config exactly before doing anything else — don't apply a diff you didn't intend.
# //