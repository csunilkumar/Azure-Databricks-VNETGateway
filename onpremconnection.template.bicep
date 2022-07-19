param connections_azureonpremconnection_name string = 'azureonpremconnection'
//param VirtualNetworkGateway_id string
param LocalNetworkGateway_id string
param location string = 'westus2'


param VirtualNetworkGateway_id string 
param gatewayResourceGroupName string 
param gatewaySubscriptionId string 

//Reference Existing Resource In a Different Resource Group and Subscription
//If the resource group of the existing resource is located in a different subscription, then we can use another overload of resourceGroup function which accepts subscriptionId.

// Creating a symbolic name for an existing resource
resource RemoteVirtualNetwork 'Microsoft.Network/virtualNetworkGateways@2022-01-01' existing = {
  name: VirtualNetworkGateway_id
  scope: resourceGroup(gatewaySubscriptionId, gatewayResourceGroupName)
}



resource connections_azureonpremconnection_name_resource 'Microsoft.Network/connections@2020-11-01' = {
  name: connections_azureonpremconnection_name
  location: location
  properties: {
    virtualNetworkGateway1: {
      properties:{}
      id: resourceId('Microsoft.Network/virtualNetworkGateways',LocalNetworkGateway_id)      
    }
    virtualNetworkGateway2: {
      properties:{}
      id: RemoteVirtualNetwork.id
    }
    connectionType: 'Vnet2Vnet'
    connectionProtocol: 'IKEv2'
    routingWeight: 0
    sharedKey: '4v3ry53cr371p53c5h4r3dk3yshgd65tsfgdvvx7654sakjs78ihd'
    enableBgp: false
    useLocalAzureIpAddress: false
    usePolicyBasedTrafficSelectors: false
    ipsecPolicies: []
    trafficSelectorPolicies: []
    expressRouteGatewayBypass: false
    dpdTimeoutSeconds: 0
    connectionMode: 'Default'
  }
}
