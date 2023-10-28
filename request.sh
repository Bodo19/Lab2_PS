#!/bin/bash

declare -A options=(
    [ca_output_folder]="keys"
    [country_name]="RO"
    [state_or_province_name]="IF"
    [locality_name]="Bucharest"
    [organizational_name]="UPB"
    [organizational_unit_name]="ACS"
    [common_name]="certificate"
    [email_address]="email@cs.pub.ro"
    [certificate_req_filename]="test"
)

usage() {
    echo "Usage:"
    echo ""
    echo "    ./$(basename "$0") [-h] [-r path/to/output/folder] [-c Country Name] [-p Province Name] [-l Locality] [-o Organizational Name] [-u Organizational Unit Name] [-n Common Name] [-e Email Address] [-f Output Filename]"
    exit 1
}

generate_certificate() {
    openssl req -nodes -new -keyout "${options[ca_output_folder]}/${options[certificate_req_filename]}.key" -out "${options[ca_output_folder]}/${options[certificate_req_filename]}.csr" -subj "/C=${options[country_name]}/ST=${options[state_or_province_name]}/L=${options[locality_name]}/O=${options[organizational_name]}/OU=${options[organizational_unit_name]}/CN=${options[common_name]}/emailAddress=${options[email_address]}" -config openssl.cnf 2> /dev/null

    openssl ca -days 3650 -batch -out "${options[ca_output_folder]}/${options[certificate_req_filename]}.crt" -in "${options[ca_output_folder]}/${options[certificate_req_filename]}.csr" -config openssl.cnf

    rm "${options[ca_output_folder]}"/*.old 2> /dev/null
}

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
            options[certificate_req_filename]="$2"
            shift
            ;;
        *)
            usage
            ;;
    esac
    shift
done

generate_certificate
