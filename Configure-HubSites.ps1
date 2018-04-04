$spo = "https://<tenant>-admin.sharepoint.com"

# URL for the top level site (hub site)
$hubSite = "https://<tenant>.sharepoint.com/sites/hubsite2"

# email addresses of users who can Join to the hub.  Must be an owner on a site that will be joined.
$principals = "admin@<tenant>.onmicrosoft.com"

# sites to join to the hub
$sitesToJoin = "https://<tenant>.sharepoint.com/sites/teamtwo", "https://<tenant>.sharepoint.com/sites/teamthree"


# Connects a SharePoint Online global administrator to a SharePoint Online connection
connect-sposervice $spo

$hub = Get-SPOSite $hubSite
$isHubSite = $hub.IsHubSite

if ($isHubSite -ne $true)
{
    # Enables the hub site feature on a site to make it a hub site.
    Register-SPOHubSite $hubSite
}

# Grants rights to users or mail-enabled security groups to access the hub site.
Grant-SPOHubSiteRights $hubSite -Principals $principals -Rights Join 

# Foreach site, associate it with the hub site.
$sitesToJoin | % { Add-SPOHubSiteAssociation $_ -HubSite $hubSite }
