#!/bin/bash

# Function to print usage
usage() {
  echo "Usage: $0 -n INSTANCE_NAME -z ZONE -m MACHINE_TYPE -i IMAGE_FAMILY -p PROJECT_ID"
  echo "  -n INSTANCE_NAME   Name of the VM instance to create"
  echo "  -z ZONE            Zone to deploy the instance (e.g., us-central1-a)"
  echo "  -m MACHINE_TYPE    Machine type (e.g., e2-medium)"
  echo "  -i IMAGE_FAMILY    Image family (e.g., debian-11)"
  echo "  -p PROJECT_ID      Google Cloud Project ID"
  exit 1
}

# Parse arguments
while getopts "n:z:m:i:p:" opt; do
  case "$opt" in
    n) INSTANCE_NAME="$OPTARG" ;;
    z) ZONE="$OPTARG" ;;
    m) MACHINE_TYPE="$OPTARG" ;;
    i) IMAGE_FAMILY="$OPTARG" ;;
    p) PROJECT_ID="$OPTARG" ;;
    *) usage ;;
  esac
done

# Check for mandatory arguments
if [[ -z "$INSTANCE_NAME" || -z "$ZONE" || -z "$MACHINE_TYPE" || -z "$IMAGE_FAMILY" || -z "$PROJECT_ID" ]]; then
  usage
fi

# Set default values (optional)
NETWORK="default"
SUBNETWORK="default"

# Check if gcloud CLI is installed
if ! command -v gcloud &> /dev/null; then
  echo "Error: gcloud CLI is not installed. Please install it and try again."
  exit 1
fi

# Enable required services
echo "Enabling required APIs..."
gcloud services enable compute.googleapis.com --project="$PROJECT_ID"

# Get the latest image from the specified family
IMAGE_PROJECT="debian-cloud" # Change this if using a different project for images
IMAGE=$(gcloud compute images list --project="$IMAGE_PROJECT" \
  --filter="family:$IMAGE_FAMILY" --format="value(name)" | head -n 1)

if [[ -z "$IMAGE" ]]; then
  echo "Error: No image found for family '$IMAGE_FAMILY' in project '$IMAGE_PROJECT'."
  exit 1
fi

echo "Creating VM instance '$INSTANCE_NAME'..."

# Create the VM instance
gcloud compute instances create "$INSTANCE_NAME" \
  --project="$PROJECT_ID" \
  --zone="$ZONE" \
  --machine-type="$MACHINE_TYPE" \
  --subnet="$SUBNETWORK" \
  --network="$NETWORK" \
  --image="$IMAGE" \
  --image-project="$IMAGE_PROJECT" \
  --tags="http-server,https-server" \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-standard

if [[ $? -eq 0 ]]; then
  echo "VM instance '$INSTANCE_NAME' created successfully."
else
  echo "Error: Failed to create VM instance."
  exit 1
fi
