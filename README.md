# Introduction 
Repository for provisioning the CodeBuildDeploy environment platform in Azure

# .ado
This folder contains the Azure DevOps (ADO) pipelines

# terraform
This folder contains the terraform used to provission the acual environments and all its associated infrastructure.

## WireGuard

The Environment pipeline provisions one WireGuard VM per platform environment. Both use `Standard_B2pts_v2` with Ubuntu 24.04 Minimal ARM64, a 32 GiB Standard HDD, and one static Standard IPv4 address. Override `vm_size` in the environment's `tfvars` to resize. If choosing an x64 size, set `image_sku = "minimal"` as well.

| Environment | Homelab UDP port | Azure tunnel address | Homelab peer address | Reachable AKS subnet |
| --- | --- | --- | --- | --- |
| Non-prod | `51821` | `10.254.0.1/30` | `10.254.0.2/32` | `10.0.4.64/26` |
| Prod | `51822` | `10.254.0.5/30` | `10.254.0.6/32` | `10.0.2.64/26` |

Azure initiates the tunnel to the homelab WAN endpoint in the environment's `tfvars` and sends a keepalive every 25 seconds. The static Azure IPv4 is used for egress. The subnet's stateful security group denies new inbound connections, including SSH. The guest forwards TCP 443 from the homelab tunnel address to the AKS subnet and masquerades that traffic to its Azure private IP. Use that private IP if the internal gateway needs a source allowlist.

Configure these public values in the existing `CodeBuildDeploy-Global` Azure DevOps variable group before the Environment plan runs. For local plans, supply the corresponding `TF_VAR_wireguard_admin_ssh_public_key` and `TF_VAR_wireguard_peer_public_key` environment variables.

| Pipeline variable | Value |
| --- | --- |
| `WireGuard.AdminSshPublicKey` | OpenSSH public key (`ssh-ed25519` or `ssh-rsa` followed by the base64 key, with the comment omitted) |
| `WireGuard.NonProd.HomelabPublicKey` | Public key of the non-prod homelab listener |
| `WireGuard.Prod.HomelabPublicKey` | Public key of the prod homelab listener |

Azure requires an SSH public key to provision the VM. Azure VM Run Command is used for administration. The pipeline and Terraform state receive only public keys. The homelab WireGuard private key stays on the homelab peer, and the VM generates its WireGuard private key locally in root-owned `/etc/wireguard/wg0.conf` with mode `0600`. A VM replacement generates a new Azure keypair and requires updating the homelab peer.

After applying, obtain the Azure source address from `wireguard_egress_ip`. Through Run Command, check `cloud-init status --wait` and `systemctl is-active nftables wg-quick@wg0`, then read the Azure public key with `wg show wg0 public-key`. On the homelab router, configure the listener and tunnel address from the table. Allow its UDP port from that environment's Azure egress address only. Add the Azure public key as a peer and leave the peer endpoint unset so it is learned from Azure's handshake. Include the Azure tunnel IP and the private Istio gateway IP in that peer's `AllowedIPs`. Route the gateway IP through the tunnel and source NAT Nginx Proxy Manager's traffic to the homelab tunnel address from the table.

Verify a recent WireGuard handshake and make an HTTPS request from Nginx Proxy Manager to the private gateway using the expected hostname for SNI and certificate verification. The private Istio endpoint and Nginx Proxy Manager upstream cutover are managed separately. Point Nginx Proxy Manager at its previous upstream if a validated cutover needs to be rolled back.
