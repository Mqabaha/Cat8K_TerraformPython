import sys
from netmiko import ConnectHandler


def configure_router(public_ip):
    hostname = "Terraform-Router"
    loopback_ip = "10.0.2.10"

    # SSH connection details
    device = {
        'device_type': 'cisco_ios',  
        'host': public_ip,
        'username': 'ec2-user',  
        'key_file': '/Users/mqabaha/Desktop/Terraform/mqabaha-key.pem', 
    }

    # Commands to configure the router
    commands = [
        f"hostname {hostname}",
        "interface Loopback0",
        f"ip address {loopback_ip} 255.255.255.255",
        "end",
        "write memory"
    ]

    # Establish SSH connection and send commands
    try:
        print(f"Connecting to {public_ip}")
        connection = ConnectHandler(**device)
        print("SSH connection established")

        output = connection.send_config_set(commands)
        print("Configuration output:")
        print(output)

        connection.disconnect()
        print("SSH connection closed")
    except Exception as e:
        print(f"Failed to configure router: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 configure_router.py <public_ip>")
        sys.exit(1)

    public_ip = sys.argv[1]
    configure_router(public_ip)