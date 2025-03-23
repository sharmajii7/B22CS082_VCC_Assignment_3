#!/bin/bash

# Set service account authentication (ensure your key file is secured)
export GOOGLE_APPLICATION_CREDENTIALS="Downloads/b22cs082-vcc-assigment-3-8b33b21cdb3c.json"
gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"

# Option 1: Permanently set the project
# gcloud config set project <YOUR_PROJECT_ID>

# Option 2: Temporarily set the project via environment variable
export CLOUDSDK_CORE_PROJECT="b22cs082-vcc-assigment-3"

# Get CPU usage (User + System load)
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')

# Get Memory usage percentage
MEMORY_USAGE=$(free | awk '/Mem:/ {printf "%.2f", $3/$2 * 100}')

echo "CPU Usage: $CPU_USAGE%"
echo "Memory Usage: $MEMORY_USAGE%"

# Use bc for floating-point comparison
if (( $(echo "$CPU_USAGE > 75" | bc -l) )); then
    echo "CPU usage exceeded 75%. Triggering auto-scaling..."

    # Create a new GCP VM instance with a unique name
    INSTANCE_NAME="scaled-vm-$(date +%s)"
    gcloud compute instances create "$INSTANCE_NAME" \
        --project="$CLOUDSDK_CORE_PROJECT" \
        --zone=us-central1-a \
        --machine-type=e2-medium \
        --image-project=debian-cloud \
        --image-family=debian-11 \
        --boot-disk-size=10GB

    # Retrieve the external IP of the new instance
    NEW_VM_IP=$(gcloud compute instances describe "$INSTANCE_NAME" \
        --project="$CLOUDSDK_CORE_PROJECT" \
        --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

    echo "New GCP VM created with IP: $NEW_VM_IP"

    # Offload part of the application load using SCP
    # For example, copy a configuration file or a workload file to the new VM.
    # scp -o StrictHostKeyChecking=no application_load.txt \
    #    user@"$NEW_VM_IP":/home/user/
fi
