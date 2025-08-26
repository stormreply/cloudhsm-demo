#!/bin/bash

echo "BEGIN -- 01-create-certificates.sh"

cluster_id=$1

touch ClusterCsr.csr

# get cluster CSR
while [ $(cat ClusterCsr.csr | wc -c) -eq 0 ] ; do
    sleep 1
    aws cloudhsmv2 describe-clusters \
    --filters clusterIds=${cluster_id} \
    --query 'Clusters[].Certificates.ClusterCsr' \
    --output text \
    > ClusterCsr.csr
done

# create customerCA
openssl req \
    -x509 \
    -nodes \
    -days 3652 \
    -newkey rsa:4096 \
    -subj "/O=ACME Examples, Inc/CN=example.com" \
    -keyout customerCA.key \
    -out customerCA.crt

# create CustomerHsmCertificate
openssl x509 \
    -req \
    -days 3652 \
    -in ClusterCsr.csr \
    -CA customerCA.crt \
    -CAkey customerCA.key \
    -CAcreateserial \
    -out CustomerHsmCertificate.crt

echo "END ---- 01-create-certificates.sh"
