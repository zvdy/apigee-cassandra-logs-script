# Apigee Hybrid Cassandra Nodetool Script 🛠️

This script is designed to interact with Cassandra instances running within a Apigee Hybrid Kubernetes cluster. It utilizes `nodetool`, a command-line utility for managing a Cassandra cluster, to execute a series of diagnostic commands on all Cassandra pods matching a specific label within a given namespace.

## Features 🌟

- **Namespace and App Label Customization**: Easily specify the Kubernetes namespace and the application label to target specific Cassandra pods.
- **Secure Credential Handling**: Fetches Cassandra user and password credentials securely from a Kubernetes secret.
- **Comprehensive Diagnostics**: Executes a wide array of `nodetool` commands to gather detailed diagnostics from each targeted Cassandra pod.
- **Automated Output Management**: Saves the output of each `nodetool` command to a timestamped file for easy review and analysis.

## Prerequisites 📋

- A Kubernetes cluster with Cassandra pods deployed.
- `kubectl` configured to communicate with your cluster.
- A Kubernetes secret (`apigee-datastore-default-creds`) containing the Cassandra credentials. _(or any other secret/optionally you can hardcode USER & PASSWORD)_
- _The script is expected to be used on Apigee Hybrid default installations but simply modifying the exports would make this usable for any Cassandra Depoloyment_

## Usage 🚀

1. **Set Namespace and App Label**: Modify the `NAMESPACE` and `APP_LABEL` variables at the top of the script to match your deployment if needed, for Apigee Hybrid default installations, you can skip this step.

2. **Ensure Correct Permissions**: Make sure the script has execute permissions:

   ```shell
   chmod +x script.sh
   ```

3. **Run the Script**: Execute the script from your terminal:

   ```shell
   ./script.sh
   ```

## Output 📁

The script generates output files in the `/tmp` directory for each `nodetool` command executed. Files are named in the format `k_nodetool_<command>_<pod_name>_<timestamp>.txt`, making it easy to identify and correlate outputs.

Optionally, you can compress all files by uncommenting `line 53` or just executing:

```bash
tar -czvf /tmp/k_nodetool_files_$(date +%Y.%m.%d_%H.%M.%S).tar.gz /tmp/k_nodetool_*.txt
```

## Security Note 🔒

This script retrieves sensitive credentials from a Kubernetes secret. Ensure that access to the script and the output files is securely managed.

## Contribution 🤝

Contributions are welcome! Feel free to submit pull requests or open issues to improve the script or add new features.

## License 📄

This script is provided under an open-source license. Feel free to use and modify it as per your needs.

---

Enjoy managing your Cassandra clusters with ease! 🎉