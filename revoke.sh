#!/bin/bash

# Default values
declare -A options=(
    [ca_output_folder]="keys"
    [certificate_req_filename]="test"
    [certificate_filename]="ca"
)

# Function to display usage information
usage() {
    echo "Usage:"
    echo ""
    echo "    ./$(basename "$0") [-h] [-r path/to/output/folder] [-c Certificate Filename] [-f Output Filename]"
    exit 1
}

# Function to revoke the certificate and generate CRL
revoke_certificate() {
    openssl ca -revoke "${options[ca_output_folder]}/${options[certificate_req_filename]}.crt" -config openssl.cnf
    openssl ca -gencrl -out "${options[ca_output_folder]}/crl.pem" -config openssl.cnf

    cat "${options[ca_output_folder]}/${options[certificate_filename]}.crt" "${options[ca_output_folder]}/crl.pem" > "${options[ca_output_folder]}/revoke_test_file.pem"
    openssl verify -CAfile "${options[ca_output_folder]}/revoke_test_file.pem" -crl_check "${options[ca_output_folder]}/${options[certificate_req_filename]}.crt"

    # Delete temporary test file
    rm "${options[ca_output_folder]}/revoke_test_file.pem"
}

# Iterate over command-line options
while [ $# -gt 0 ]; do
    case "$1" in
        -h)
            usage
            ;;
        -r)
            options[ca_output_folder]="$2"
            shift
            ;;
        -c)
            options[certificate_filename]="$2"
            shift
            ;;
        -f)
            options[certificate_req_filename]="$2"
            shift
            ;;
        *)
            usage
            ;;
    esac
    shift
done

# Revoke certificate and generate CRL
revoke_certificate
