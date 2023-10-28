#!/bin/bash

# Default values
declare -A options=(
    [ca_output_folder]="keys"
    [country_name]="RO"
    [state_or_province_name]="IF"
    [locality_name]="Bucharest"
    [organizational_name]="UPB"
    [organizational_unit_name]="ACS"
    [common_name]="certificate"
    [email_address]="email@cs.pub.ro"
    [certificate_filename]="ca"
    [pkcs12_filename]="test2"
)

# Function to display usage information
usage() {
    echo "Usage:"
    echo ""
    echo "    ./$(basename "$0") [-h] [-r path/to/output/folder] [-c Country Name] [-p Province Name] [-l Locality] [-o Organizational Name] [-u Organizational Unit Name] [-n Common Name] [-e Email Address] [-f Output Filename] [-d Pkcs12 Filename] [-g Certificate Filename]"
    exit 1
}

# Function to generate PKCS12 file
generate_pkcs12() {
    openssl req -nodes -new -keyout "${options[ca_output_folder]}/${options[pkcs12_filename]}.key" -out "${options[ca_output_folder]}/${options[pkcs12_filename]}.csr" -subj "/C=${options[country_name]}/ST=${options[state_or_province_name]}/L=${options[locality_name]}/O=${options[organizational_name]}/OU=${options[organizational_unit_name]}/CN=${options[common_name]}/emailAddress=${options[email_address]}" -config openssl.cnf

    openssl ca -days 3650 -batch -out "${options[ca_output_folder]}/${options[pkcs12_filename]}.crt" -in "${options[ca_output_folder]}/${options[pkcs12_filename]}.csr" -config openssl.cnf

    openssl pkcs12 -export -inkey "${options[ca_output_folder]}/${options[pkcs12_filename]}.key" -in "${options[ca_output_folder]}/${options[pkcs12_filename]}.crt" -certfile "${options[ca_output_folder]}/${options[certificate_filename]}.crt" -out "${options[ca_output_folder]}/${options[pkcs12_filename]}.p12" -passout pass:

    # Delete any .old files created in this process
    rm "${options[ca_output_folder]}"/*.old
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
            options[country_name]="$2"
            shift
            ;;
        -p)
            options[state_or_province_name]="$2"
            shift
            ;;
        -l)
            options[locality_name]="$2"
            shift
            ;;
        -o)
            options[organizational_name]="$2"
            shift
            ;;
        -u)
            options[organizational_unit_name]="$2"
            shift
            ;;
        -n)
            options[common_name]="$2"
            shift
            ;;
        -e)
            options[email_address]="$2"
            shift
            ;;
        -f)
            options[certificate_filename]="$2"
            shift
            ;;
        -d)
            options[pkcs12_filename]="$2"
            shift
            ;;
        -g)
            options[pkcs12_filename]="$2"
            shift
            ;;
        *)
            usage
            ;;
    esac
    shift
done

# Generate the PKCS12 file
generate_pkcs12
