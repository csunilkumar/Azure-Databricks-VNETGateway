

param vpngwLocation string = resourceGroup().location

@description('Name of the vnet associated witht the Firewall')
param vnetName string

param publicIPAddresses_azurevpnpubip_name string = 'azurevpnpubip'
param virtualNetworkGateways_azurevpngw_name string = 'azurevpngw'
//param azurevpnvnet_name_GatewaySubnet string = 'GatewaySubnet'

//@description('The public IP address of your local gateway')
//param gatewayIpAddress string

//Public IP address object that gets associated to the VPN gateway. The public IP address is dynamically assigned to this object when the VPN gateway is created. 
resource publicIPAddresses_azurevpnpubip_name_resource 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: publicIPAddresses_azurevpnpubip_name
  location: vpngwLocation
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    //ipAddress: '20.234.5.162'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}


resource virtualNetworkGateways_azurevpngw_name_resource 'Microsoft.Network/virtualNetworkGateways@2020-11-01' = {
  name: virtualNetworkGateways_azurevpngw_name
  location: vpngwLocation
  properties: {
    enablePrivateIpAddress: false
    ipConfigurations: [
      {
        name: 'vnetGatewayConfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_azurevpnpubip_name_resource.id
          }
          subnet: {
            id: resourceId( 'Microsoft.Network/virtualNetworks/subnets',vnetName,'GatewaySubnet')
            
          }
        }
      }
    ]
    sku: {
      name: 'Basic'
      tier: 'Basic'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: false
    activeActive: false
    vpnGatewayGeneration: 'Generation1'
  }
}
